const { installPackages } = require("./utils");

const downloadInitialPackages = () => {
  let packages = [];
  packages.push("flutter_riverpod");
  packages.push("widgetbook");
  
  installPackages(packages);
};

module.exports = { downloadInitialPackages };
