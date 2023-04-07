COMPILE INSTRUCITONS:
1. Open a terminal
2. Write the command ./reach compile and press enter, when the code is finished compiling, a message is printed to the console:
Compiling `main`...
Verifying knowledge assertions
Verifying for generic connector
  Verifying when ALL participants are honest
  Verifying when NO participants are honest
Checked 150 theorems; No failures!

RUN INSTRUCITONS:
1. Open two terminals
2. Write the command ./reach run in the first terminal and press enter, after that you have error
3. Write the command export REACH_CONNECTOR_MODE=ALGO and press enter, now you don't have error
4. Write the command ./reach run again
5. Following steps from 2 to 4 for the second terminal
6. The console application is running

Below are sample codes after the application is complete:

The first terminal (Player Alice):
[+] Building 3.6s (7/7) FINISHED                                                           
 => [internal] load build definition from Dockerfile                                  0.3s
 => => transferring dockerfile: 38B                                                   0.1s
 => [internal] load .dockerignore                                                     0.1s
 => => transferring context: 34B                                                      0.0s
 => [internal] load metadata for docker.io/reachsh/runner:0.1.13                      0.0s
 => CACHED [1/2] FROM docker.io/reachsh/runner:0.1.13                                 0.0s
 => [internal] load build context                                                     0.5s
 => => transferring context: 418.75kB                                                 0.4s
 => [2/2] COPY . /app                                                                 1.7s
 => exporting to image                                                                0.6s
 => => exporting layers                                                               0.4s
 => => writing image sha256:fe2d55dc7c9d72ab42933ee695570da0348ea6b5bdc6b70f29235f08  0.0s
 => => naming to docker.io/reachsh/reach-app-reach:0.1.13                             0.0s

> index
> node --experimental-modules --unhandled-rejections=strict index.mjs

Are you Alice?
y
Starting Morra game! as Alice
Would you like to create an account? (only possible on devnet)
y
Warning: your program uses stdlib.fundFromFaucet. That means it only works on Reach devnets!
Your balance is 1000
How much do you want to wager?
100
The contract is deployed as = {"type":"BigNumber","hex":"0xa7"}
----------------------------
Alice shoots 4 fingers
Alice guessed total of 7
Actual total fingers thrown: 6
Actual total points: 0
----------------------------
Alice shoots 2 fingers
Alice guessed total of 5
Actual total fingers thrown: 3
Actual total points: 0
----------------------------
Alice shoots 0 fingers
Alice guessed total of 2
Actual total fingers thrown: 0
Actual total points: 0
----------------------------
Alice shoots 1 fingers
Alice guessed total of 6
Actual total fingers thrown: 6
Actual total points: 1
----------------------------
Alice shoots 4 fingers
Alice takes their sweet time sending it back...
Alice takes their sweet time sending it back...
Alice takes their sweet time sending it back...
Alice takes their sweet time sending it back...
Alice takes their sweet time sending it back...
Alice takes their sweet time sending it back...
Alice takes their sweet time sending it back...
Alice takes their sweet time sending it back...
Alice takes their sweet time sending it back...
Alice takes their sweet time sending it back...
Alice guessed total of 5
Actual total fingers thrown: 4
Actual total points: 1
----------------------------
Alice shoots 3 fingers
Alice guessed total of 3
Actual total fingers thrown: 4
Actual total points: 1
----------------------------
Alice shoots 4 fingers
Alice guessed total of 6
Actual total fingers thrown: 5
Actual total points: 1
----------------------------
Alice shoots 3 fingers
Alice guessed total of 7
Actual total fingers thrown: 8
Actual total points: 1
The outcome is: Bob wins
Your balance is now 899.957
npm notice 
npm notice New major version of npm available! 8.3.1 -> 9.6.4
npm notice Changelog: https://github.com/npm/cli/releases/tag/v9.6.4
npm notice Run npm install -g npm@9.6.4 to update!
npm notice

The second terminal (Player Bob):
[+] Building 1.2s (7/7) FINISHED                                                         
 => [internal] load build definition from Dockerfile                                0.3s
 => => transferring dockerfile: 38B                                                 0.0s
 => [internal] load .dockerignore                                                   0.3s
 => => transferring context: 34B                                                    0.0s
 => [internal] load metadata for docker.io/reachsh/runner:0.1.13                    0.0s
 => [internal] load build context                                                   0.2s
 => => transferring context: 16.78kB                                                0.1s
 => [1/2] FROM docker.io/reachsh/runner:0.1.13                                      0.0s
 => CACHED [2/2] COPY . /app                                                        0.0s
 => exporting to image                                                              0.2s
 => => exporting layers                                                             0.0s
 => => writing image sha256:fe2d55dc7c9d72ab42933ee695570da0348ea6b5bdc6b70f29235f  0.0s
 => => naming to docker.io/reachsh/reach-app-reach:0.1.13                           0.0s

> index
> node --experimental-modules --unhandled-rejections=strict index.mjs

Are you Alice?
n
Starting Morra game! as Bob
Would you like to create an account? (only possible on devnet)
y
Warning: your program uses stdlib.fundFromFaucet. That means it only works on Reach devnets!
Please paste the contract information:
{"type":"BigNumber","hex":"0xa7"}
Your balance is 1000
Do you accept the wager of 100?
y
----------------------------
Bob shoots 2 fingers
Bob guessed total of 6
Actual total fingers thrown: 6
Actual total points: 1
----------------------------
Bob shoots 1 fingers
Bob guessed total of 6
Actual total fingers thrown: 3
Actual total points: 1
----------------------------
Bob shoots 0 fingers
Bob guessed total of 4
Actual total fingers thrown: 0
Actual total points: 1
----------------------------
Bob shoots 5 fingers
Bob guessed total of 5
Actual total fingers thrown: 6
Actual total points: 1
----------------------------
Bob shoots 0 fingers
Bob guessed total of 3
Actual total fingers thrown: 4
Actual total points: 1
----------------------------
Bob shoots 1 fingers
Bob guessed total of 6
Actual total fingers thrown: 4
Actual total points: 1
----------------------------
Bob shoots 1 fingers
Bob guessed total of 5
Actual total fingers thrown: 5
Actual total points: 2
----------------------------
Bob shoots 5 fingers
Bob guessed total of 8
Actual total fingers thrown: 8
Actual total points: 3
The outcome is: Bob wins
Your balance is now 1099.9728
npm notice 
npm notice New major version of npm available! 8.3.1 -> 9.6.4
npm notice Changelog: https://github.com/npm/cli/releases/tag/v9.6.4
npm notice Run npm install -g npm@9.6.4 to update!
npm notice