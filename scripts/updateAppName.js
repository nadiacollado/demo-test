const path = require("path");
const fs = require("fs");
const { toSnakeCase } = require("../scripts/utils");
const { execSync } = require("child_process");

const updateAppName = (appName) => {
  console.log(`Updating app name to: ${appName}...`);
  const appNameSnakeCase = toSnakeCase(appName);
  const newPackageName = `com.${appNameSnakeCase}`;

  try {
    replaceTextInFiles("Flutter Starter Kit", appName);
    replaceTextInFiles("flutter_starter_kit", appNameSnakeCase);
    replaceTextInFiles(`com.example.${appNameSnakeCase}`, newPackageName);
    renameKotlinFolder(appNameSnakeCase);

    console.log("✅ App name and package name updated successfully!");
  } catch (error) {
    console.error("❌ An error occurred:", error);
  }
};

const replaceTextInFiles = (oldName, newName) => {
  console.log(`Replacing '${oldName}' with '${newName}' in all files...`);
  
  const files = execSync(`git grep -l '${oldName}'`).toString().split("\n").filter(Boolean);

  files.forEach((file) => {
    console.log(`Updating file: ${file}`);
    execSync(`sed -i '' "s/${oldName}/${newName}/g" ${file}`);
  });
};

const renameKotlinFolder = (folderName) => {
  const oldPath = "android/app/src/main/kotlin/com/example/flutter_starter_kit";
  const newPath = `android/app/src/main/kotlin/com/${folderName}`;

  if (fs.existsSync(oldPath)) {
    fs.renameSync(oldPath, newPath);
    console.log("✅ Kotlin package folder renamed successfully!");
  } else {
    console.log("⚠️ Old package path does not exist, skipping rename.");
  }

  const exampleDir = path.join("android/app/src/main/kotlin/com/example");
  if (fs.existsSync(exampleDir) && fs.readdirSync(exampleDir).length === 0) {
    fs.rmdirSync(exampleDir);
    console.log("🗑️ Removed empty 'example' directory.");
  } else {
    console.log("⚠️ Old package path does not exist, skipping removal.");
  }
};

module.exports = { updateAppName };