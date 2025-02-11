const readline = require("readline");
const { updateAppName } = require("./updateAppName");
const { downloadInitialPackages } = require("./downloadInitialPackages");

const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout,
});

rl.question("Enter the new app name: ", (appName) => {
  updateAppName(appName);

  rl.close();
});
