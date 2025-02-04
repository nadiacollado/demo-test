const path = require("path");
const fs = require("fs");
const { updateFile, toSnakeCase } = require("../scripts/utils");
const { execSync } = require("child_process");

const updateAppName = (appName) => {
  console.log(`Updating app name to: ${appName}...`);
  const appNameSnakeCase = toSnakeCase(appName);
  const newPackageName = `com.${appNameSnakeCase}.app`;

  try {
    replaceTextInFiles("flutter_starter_kit", appNameSnakeCase);
    updateAndroidFiles(appName, newPackageName);
    updateIOSFiles(appName);
    renameKotlinFolder(appName);

    console.log("✅ App name and package name updated successfully!");
  } catch (error) {
    console.error("❌ An error occurred:", error);
  }
};

const replaceTextInFiles = (oldName, newName) => {
  console.log(`Replacing '${oldName}' with '${newName}' in files...`);
  execSync(
    `LC_ALL=C find . -type f ! -path "./macos/*" -exec sed -i "" "s/${oldName}/${newName}/g" {} +`
  );
};

const updateAndroidFiles = (appName, newPackageName) => {
  console.log(`Updating Android files with new app name and package name...`);

  updateFile(
    "android/app/src/main/AndroidManifest.xml",
    /android:label="[^"]*"/,
    `android:label="${appName}"`,
    "AndroidManifest.xml"
  );

  console.log(`Updating package name to: ${newPackageName}...`);
  replaceTextInFiles("flutter_starter_kit", newPackageName);
};

const updateIOSFiles = (appName) => {
  console.log("Updating iOS files...");

  updateFile(
    "ios/Runner/Info.plist",
    /<key>CFBundleDisplayName<\/key>\s*<string>.*<\/string>/,
    `<key>CFBundleDisplayName</key>\n<string>${appName}</string>`,
    "Info.plist"
  );

  updateFile(
    "ios/Runner/Info.plist",
    /<key>CFBundleName<\/key>\s*<string>.*<\/string>/,
    `<key>CFBundleName</key>\n<string>${appName}</string>`,
    "Info.plist"
  );
};

const renameKotlinFolder = (appName) => {
  const oldPath = path.join("android/app/src/main/kotlin/flutter_starter_kit");
  const newPath = path.join(`android/app/src/main/kotlin/com/${appName}`);

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