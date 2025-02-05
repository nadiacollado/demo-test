const fs = require("fs");
const { toSnakeCase } = require("../scripts/utils");
const { execSync } = require("child_process");

const updateAppName = (appName) => {
  console.log(`Updating app name to: ${appName}...`);
  const appNameSnakeCase = toSnakeCase(appName);

  try {
    const currentPackageName = getCurrentPackageName();
    replacePackageInFiles(currentPackageName, `com.${appNameSnakeCase}`);
    renameKotlinFolder(currentPackageName, appNameSnakeCase);
    replaceTextInFiles("Flutter Starter Kit", appName);
    replaceTextInFiles("flutter_starter_kit", appNameSnakeCase);

    console.log("✅ App name and package name updated successfully!");
  } catch (error) {
    console.error("❌ An error occurred:", error);
  }
};

const getCurrentPackageName = () => {
  const gradlePath = "android/app/build.gradle";
  if (!fs.existsSync(gradlePath)) {
    throw new Error("❌ build.gradle not found");
  }

  const gradleContent = fs.readFileSync(gradlePath, "utf8");
  const match = gradleContent.match(/namespace\s*=\s*"([\w.]+)"/);

  if (match && match[1] && match[1] !== "undefined") {
    return match[1];
  }

  throw new Error("❌ Could not detect a valid package name.");
};

const replaceTextInFiles = (oldName, newName) => {
  console.log(
    `Replacing package '${oldName}' with '${newName}' in all files...`
  );

  const files = execSync(`git grep -l '${oldName}'`)
    .toString()
    .split("\n")
    .filter(Boolean);

  files.forEach((file) => {
    console.log(`Updating file: ${file}`);
    const safeOldName = oldName.replace(/\./g, "\\.");
    execSync(`perl -pi -e "s/${safeOldName}/${newName}/g" "${file}"`);
  });
};

const replacePackageInFiles = (oldName, newName) => {
  const currentPackageName = getCurrentPackageName();
  console.log(
    `Replacing package '${oldName}' with '${newName}' in all files...`
  );

  const files = execSync(`git grep -l '${oldName}'`)
    .toString()
    .split("\n")
    .filter(Boolean);

  files.push(
    `android/app/src/main/kotlin/${currentPackageName.replace(
      /\./g,
      "/"
    )}/MainActivity.kt`
  );

  files.forEach((file) => {
    console.log(`Updating file: ${file}`);

    const safeOldName = oldName.replace(/\./g, "\\.");
    execSync(`perl -pi -e "s/${safeOldName}/${newName}/g" "${file}"`);
  });
};

const renameKotlinFolder = (currentPackageName, newAppName) => {
  let oldPath = `android/app/src/main/kotlin/${currentPackageName.replace(
    /\./g,
    "/"
  )}`;

  const newPath = `android/app/src/main/kotlin/com/${newAppName}`;

  if (fs.existsSync(oldPath)) {
    fs.renameSync(oldPath, newPath);
    console.log("✅ Kotlin package folder renamed successfully!");
  } else {
    console.log("⚠️ Old package path does not exist, skipping rename.");
  }
};

module.exports = { updateAppName };
