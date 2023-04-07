'reach 0.1';

// definition of possible finger outcomes, possible sum of fingers outcomes and possible game outcomes
const [isFinger, ZERO, ONE, TWO, THREE, FOUR, FIVE] = makeEnum(6);
const [isSumFingers, SUM_ZERO, SUM_ONE, SUM_TWO, SUM_THREE, SUM_FOUR, SUM_FIVE, SUM_SIX, SUM_SEVEN, SUM_EIGHT, SUM_NINE, SUM_TEN] = makeEnum(11);
const [isOutcome, B_WINS, DRAW, A_WINS] = makeEnum(3);

// calculate winner of game
const winner = (fingersAlice, fingersBob, sumFingersAlice, sumFingersBob) => {
    if (sumFingersAlice == sumFingersBob) {
        const myoutcome = DRAW; //tie
        return myoutcome;
    } else {
        if (((fingersAlice + fingersBob) == sumFingersAlice)) {
            const myoutcome = A_WINS;
            return myoutcome; //player Alice wins
        }
        else {
            if (((fingersAlice + fingersBob) == sumFingersBob)) {
                const myoutcome = B_WINS;
                return myoutcome; //player Bob wins
            }
            else {
                const myoutcome = DRAW; //tie
                return myoutcome;
            }
        }
    }
};

// calculate point for Alice
const calculatePointOfAlice = (currentOutcome) => {
    if (currentOutcome == DRAW) {
        return 0;
    } else {
        if (currentOutcome == A_WINS) {
            return 1; // player Alice earns one point
        }
        else {
            if (currentOutcome == B_WINS) {
                return 0; // player Alice doesn't earn point
            }
            else {
                return 0;
            }
        }
    }
};

// calculate point for Bob
const calculatePointOfBob = (currentOutcome) => {
    if (currentOutcome == DRAW) {
        return 0;
    } else {
        if (currentOutcome == A_WINS) {
            return 0; // player Bob doesn't earn point
        }
        else {
            if (currentOutcome == B_WINS) {
                return 1; // player Bob earns point
            }
            else {
                return 0;
            }
        }
    }
};

// assert 
// Alice throws a 0, AND Bob throws a 2,
// and Alice guesses 0 and Bob guesses 2
// then Bob wins as the total thrown is 2
assert(winner(ZERO, TWO, SUM_ZERO, SUM_TWO) == B_WINS);
assert(winner(TWO, ZERO, SUM_TWO, SUM_ZERO) == A_WINS);
assert(winner(ZERO, ONE, SUM_ZERO, SUM_TWO) == DRAW);
assert(winner(ONE, ONE, SUM_ONE, SUM_ONE) == DRAW);

// asserts for all combinations
forall(UInt, fingersAlice =>
    forall(UInt, fingersBob =>
        forall(UInt, sumFingersAlice =>
            forall(UInt, sumFingersBob =>
                assert(isOutcome(winner(fingersAlice, fingersBob, sumFingersAlice, sumFingersBob)))))));

//  asserts for a draw - each guesses the same
forall(UInt, (fingerAlice) =>
    forall(UInt, (fingerBob) =>
        forall(UInt, (sumFingers) =>
            assert(winner(fingerAlice, fingerBob, sumFingers, sumFingers) == DRAW))));


// added a timeout function
const Player =
{
    ...hasRandom,
    getFingers: Fun([], UInt),
    getSumFingers: Fun([UInt], UInt),
    seeWinning: Fun([UInt], Null),
    seePoints: Fun([UInt], Null),
    seeOutcome: Fun([UInt], Null),
    informTimeout: Fun([], Null)
};

export const main = Reach.App(() => {
    const Alice = Participant('Alice', {
        ...Player,
        wager: UInt, // atomic units of currency
        deadline: UInt, // time delta (blocks/rounds)
    });
    const Bob = Participant('Bob', {
        ...Player,
        acceptWager: Fun([UInt], Null),
    });
    init();

    const informTimeout = () => {
        each([Alice, Bob], () => {
            interact.informTimeout();
        });
    };

    Alice.only(() => {
        const wager = declassify(interact.wager);
        const deadline = declassify(interact.deadline);
    });
    Alice.publish(wager, deadline)
        .pay(wager);
    commit();

    Bob.only(() => {
        interact.acceptWager(wager);
    });
    Bob.pay(wager)
        .timeout(relativeTime(deadline), () => closeTo(Alice, informTimeout));

    var [outcome, pointsOfAlice, pointsOfBob] = [DRAW, 0, 0];
    invariant(balance() == 2 * wager && isOutcome(outcome));
    // loop until we have a winner
    while (outcome == DRAW || (pointsOfAlice < 3 && pointsOfBob < 3)) {
        commit();

        Alice.only(() => {
            const _fingersAlice = interact.getFingers();
            const _sumFingersAlice = interact.getSumFingers(_fingersAlice);
            // We need Alice to be able to publish her fingers and guesses,
            // but also keep it secret.  makeCommitment does this.
            const [_commitAlice, _saltAlice] = makeCommitment(interact, _fingersAlice);
            const commitAlice = declassify(_commitAlice);
            const [_sumFingersCommitAlice, _sumFingersSaltAlice] = makeCommitment(interact, _sumFingersAlice);
            const sumFingersCommitAlice = declassify(_sumFingersCommitAlice);
        });
        Alice.publish(commitAlice)
            .timeout(relativeTime(deadline), () => closeTo(Bob, informTimeout));
        commit();

        Alice.publish(sumFingersCommitAlice)
            .timeout(relativeTime(deadline), () => closeTo(Bob, informTimeout));
        commit();

        // Bob does not know the values for Alice, but Alice does know the values
        unknowable(Bob, Alice(_fingersAlice, _saltAlice));
        unknowable(Bob, Alice(_sumFingersAlice, _sumFingersSaltAlice));
        Bob.only(() => {
            const _fingersBob = interact.getFingers();
            const _sumFingersBob = interact.getSumFingers(_fingersBob);
            const fingersBob = declassify(_fingersBob);
            const sumFingersBob = declassify(_sumFingersBob);
        });
        Bob.publish(fingersBob)
            .timeout(relativeTime(deadline), () => closeTo(Alice, informTimeout));
        commit();
        Bob.publish(sumFingersBob)
            .timeout(relativeTime(deadline), () => closeTo(Alice, informTimeout));
        commit();
        // Alice will declassify the secret information
        Alice.only(() => {
            const [saltAlice, fingersAlice] = declassify([_saltAlice, _fingersAlice]);
            const [sumFingersSaltAlice, sumFingersAlice] = declassify([_sumFingersSaltAlice, _sumFingersAlice]);
        });
        Alice.publish(saltAlice, fingersAlice)
            .timeout(relativeTime(deadline), () => closeTo(Bob, informTimeout));
        // check that the published values match the original values.
        checkCommitment(commitAlice, saltAlice, fingersAlice);
        commit();

        Alice.publish(sumFingersSaltAlice, sumFingersAlice)
            .timeout(relativeTime(deadline), () => closeTo(Bob, informTimeout));
        checkCommitment(sumFingersCommitAlice, sumFingersSaltAlice, sumFingersAlice);
        commit();

        const currentOutcome = winner(fingersAlice, fingersBob, sumFingersAlice, sumFingersBob);
        const currentPointsOfAlice = calculatePointOfAlice(currentOutcome);
        const currentPointsOfBob = calculatePointOfBob(currentOutcome);
        
        Alice.only(() => {
            const WinningNumberAlice = fingersAlice + fingersBob;
            const pointsAlice = pointsOfAlice + currentPointsOfAlice;
            interact.seeWinning(WinningNumberAlice);
            interact.seePoints(pointsAlice);
        });

        Alice.publish(WinningNumberAlice, pointsAlice)
            .timeout(relativeTime(deadline), () => closeTo(Alice, informTimeout));

        Bob.only(() => {
            const WinningNumberBob = fingersAlice + fingersBob;
            const pointsBob = pointsOfBob + currentPointsOfBob;
            interact.seeWinning(WinningNumberBob);
            interact.seePoints(pointsBob);
        });
        commit();

        Bob.publish(WinningNumberBob, pointsBob)
            .timeout(relativeTime(deadline), () => closeTo(Alice, informTimeout));
        
        [outcome, pointsOfAlice, pointsOfBob] = [currentOutcome, pointsOfAlice + currentPointsOfAlice, pointsOfBob + currentPointsOfBob];
        continue;
    }

    assert(outcome == A_WINS || outcome == B_WINS);
    transfer(2 * wager).to(outcome == A_WINS ? Alice : Bob);
    commit();

    each([Alice, Bob], () => {
        interact.seeOutcome(outcome);
    });

    exit();
});