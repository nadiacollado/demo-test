const fs = require("fs");
const { updateFile, toSnakeCase } = require("../scripts/utils");

const updateAppName = (appName) => {
  console.log(`Updating app name to: ${appName}...`);
  const appNameSnakeCase = toSnakeCase(appName);

  // Update pubspec.yaml
  updateFile(
    "pubspec.yaml",
    /name:\s*".*"/,
    'name: "$appNameSnakeCase"',
    "pubspec.yaml"
  );

  // Update Info.plist
  updateFile(
    "ios/Runner/Info.plist",
    /<key>CFBundleDisplayName<\/key>\s*<string>.*<\/string>/,
    `<key>CFBundleDisplayName</key>\n<string>${appName}</string>`,
    "Info.plist"
  );

  // Update AndroidManifest.xml
  updateFile(
    "android/app/src/main/AndroidManifest.xml",
    /android:label="[^"]*"/,
    `android:label="${appName}"`,
    "AndroidManifest.xml"
  );

  console.log("✅ App name updated successfully!");
};

module.exports = { updateAppName };
