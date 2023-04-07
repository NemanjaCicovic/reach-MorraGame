import { loadStdlib, ask } from '@reach-sh/stdlib';
import * as backend from './build/index.main.mjs';
const stdlib = loadStdlib();

const isAlice = await ask.ask(
  `Are you Alice?`,
  ask.yesno
);
const Who = isAlice ? 'Alice' : 'Bob';

console.log(`Starting Morra game! as ${Who}`);

let acc = null;
const createAcc = await ask.ask(
  `Would you like to create an account? (only possible on devnet)`,
  ask.yesno //Exprecting y or n (yes or no)
);
if (createAcc) {
  acc = await stdlib.newTestAccount(stdlib.parseCurrency(1000)); //Creating test account
} else {
  const secret = await ask.ask(
    `What is your account secret?`,
    (x => x)
  );
  acc = await stdlib.newAccountFromSecret(secret);
}

let ctc = null;
if (isAlice) {
  ctc = acc.contract(backend);
  ctc.getInfo().then((info) => {
    console.log(`The contract is deployed as = ${JSON.stringify(info)}`);
  });
} else {
  const info = await ask.ask(     //Asking for contract info
    `Please paste the contract information:`,
    JSON.parse  //Answer
  );
  ctc = acc.contract(backend, info);
}

const fmt = (x) => stdlib.formatCurrency(x, 4);
const getBalance = async () => fmt(await stdlib.balanceOf(acc));

const before = await getBalance();
console.log(`Your balance is ${before}`);

const FINGERS = [0, 1, 2, 3, 4, 5];
const SUMFINGERS = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
const OUTCOME = ['Bob wins', 'Draw', 'Alice wins'];

const interact = { ...stdlib.hasRandom };

interact.getFingers = async () => {
  const fingers = Math.floor(Math.random() * 6);
  console.log(`----------------------------`);
  console.log(`${Who} shoots ${FINGERS[fingers]} fingers`);
  if (Math.random() <= 0.01) {
    for (let i = 0; i < 10; i++) {
      console.log(`  ${Who} takes their sweet time sending it back...`);
      await stdlib.wait(1);
    }
  }
  return fingers;
};

interact.getSumFingers = async (fingers) => {
  // sumFingers should be greater than or equal to number of fingers thrown
  const sumFingers = Math.floor(Math.random() * 6) + FINGERS[fingers];
  // occasional timeout
  if (Math.random() <= 0.01) {
    for (let i = 0; i < 10; i++) {
      console.log(`${Who} takes their sweet time sending it back...`);
      await stdlib.wait(1);
    }
  }
  console.log(`${Who} guessed total of ${sumFingers}`);
  return sumFingers;
};

interact.seeWinning = (winningNumber) => {
  console.log(`Actual total fingers thrown: ${winningNumber}`);
};

interact.seePoints = (points) => {
  console.log(`Actual total points: ${points}`);
};

interact.seeOutcome = async (outcome) => {
  console.log(`The outcome is: ${OUTCOME[outcome]}`);
};

interact.informTimeout = () => {
  console.log(`There was a timeout.`);
  process.exit(1);
};

if (isAlice) {
  const amt = await ask.ask( //Asking how much Alice wants to wager
    `How much do you want to wager?`,
    stdlib.parseCurrency
  );
  interact.wager = amt;
  interact.deadline = { ETH: 100, ALGO: 100, CFX: 1000 }[stdlib.connector];
} else {
  interact.acceptWager = async (amt) => {
    const accepted = await ask.ask(
      `Do you accept the wager of ${fmt(amt)}?`,
      ask.yesno
    );
    if (!accepted) {
      process.exit(0);
    }
  };
}

const part = isAlice ? ctc.p.Alice : ctc.p.Bob;
await part(interact);

const after = await getBalance();
console.log(`Your balance is now ${after}`);

ask.done(); //Has to be used in order to run succesfully