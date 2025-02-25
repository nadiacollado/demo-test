# Flutter Starter Kit

## Table of Contents

- [Requirements](#requirements)
- [VS Code Extensions](#vs-code-extensions)
- [Getting Started](#getting-started)
- [Running the App](#running-the-app)
- [Environment Variables](#environment-variables)
- [Localizations](#localizations)
- [Google Cloud Logging](#google-cloud-logging)
- [Running Integration Tests](#running-integration-tests)
- [Additional Documentation](#additional-documentation)

## Requirements

Ensure that you have Dart and Flutter properly installed by following the instructions on the [official Flutter website](https://flutter.dev/docs/get-started/install).

This project requires the following versions or newer:

- Dart SDK: >=3.6.0 <4.0.0
- Flutter: 3.27.1

Follow the official [Flutter installation guide](https://docs.flutter.dev/get-started/install)

You can verify your installation by running the following command, which will also check for any additional requirements that may need to be installed for development on various platforms:

```bash
flutter doctor
```

### Code Editor

You can build apps with Flutter using any text editor or IDE + Flutter's command-line tools, but the Flutter team recommends using an editor that supports a Flutter extension or plugin, like **VS Code** and **Android Studio**.

## VS Code Extensions

Some Flutter extensions for VS Code include:

- Flutter
- Dart
- Pubspec Assist
- Error Lens
- Flutter Tree
- Bracket Pain Colorizer 2
- Dart Data Class Generator
- Flutter Stylizer
- Better Comments
- Color Highlight
- Markdownlint
- JSON to Dart Model
- Coverage Gutters

## Getting Started

1. Before you can begin to run the app. You must create `.env`. See [Environment Variables](#environment-variables) for further details.
2. Ensure that you have your git hooks set up to help make certain that code you push up meets our code quality standards by running the following command in your terminal:

```shell
git config --local core.hooksPath githooks/
```

3. Install dependencies

```shell
flutter pub get
```

4. Generate necessary files

```shell
dart run build_runner clean
dart run build_runner build --delete-conflicting-outputs
```

You will also need the following files for Android and iOS setup:

**Android Setup**:

- Download the `google-services.json` file from the Firebase dashboard for the desired environment.
- Save the `google-services.json` file to `android/app/google-services.json`.

**iOS Setup**:

- Download the `GoogleService-Info.plist` file from the Firebase dashboard for the desired environment.
- Save the `GoogleService-Info.plist` file to `ios/GoogleService-Info.plist`.

After placing these files in the correct locations, run the following commands to clean and rebuild the project, ensuring the environment is properly set:

```bash
dart run build_runner clean
dart run build_runner build --delete-conflicting-outputs
```

## Running the App

**With VS Code:**

1. Open the Command Palette. (Command + Shift + P).
2. Type flutter.
3. Select the Flutter: Select Device. (If no devices are running, this command prompts you to enable a device.)
4. Select a target device from Select Device prompt.
5. After you select a target, start the app. Go to Run > Start Debugging or press F5.
6. Wait for the app to launch. After the app build completes, your device displays your app.

**On the command line:**

```bash
flutter run
```

Afterwards, you'll be prompted to select where to run the app: a wireless device, your machine, or Chrome.

See the [flutter-cli docs](https://docs.flutter.dev/reference/flutter-cli) for more commands you can run.

```bash
dart run build_runner clean
dart run build_runner build --delete-conflicting-outputs
```

## Environment Variables

Before building the app, create a file called `.env` in the base directory. The contents of the file can be found in 1Password for this project. Then run these commands in the terminal:

```shell
dart run build_runner clean
dart run build_runner build --delete-conflicting-outputs
```

To add an environment variable, first add the variable name and value to the .env file in the form of:

```
VAR_NAME=`var value`
```

Then update the file `lib/env/env.dart with your new variable following this format:

```dart
  @EnviedField(varName: 'VAR_NAME', obfuscate: true)
  static final String varName = _Env.varName;
```

Then re-run build

```shell
dart run build_runner clean
dart run build_runner build --delete-conflicting-outputs
```

Then in the code is can be referenced with:

```dart
Env.varName
```

Please note that after ANY update to a variable in the `.env` file, you will need to do the clean and build as above.

The contexts of `.env` file are never saved to git so you will need to update the 1Password version as well and let other team members know of the change in your PR.

## Localizations

Localizations can be accessed from anywhere in the app with context using the extension on BuildContext in `lib/l10n/translate.dart`
This makes accessing localizations simple and easy by simply typing `context.t.translation_key`

### Organization

Organizing localizations is a difficult topic with many considerations. We are taking a simple route in this starter kit. If a project's localization needs become such that this system is difficult or cumbersome then you may want to consider a more complicated and involved localization solution.

Localizations in arb files should be separated and named by feature with a section title in all caps like this:

```json
  "@_AUTHENTICATION": {},
```

This enables easy separation of section by sight, especially with the assistance of the highlight extension detailed below.

Additionally please follow the naming convention for translation keys as follows:

```json
  "feature_translationKeyInCamelCase": "A shorthand version of the feature first, then the key in camel case. Keeping this shortened in a reasonable way assists in calling this in the code",
```

For example:

```json
  "auth_enterEmail": "Please enter your email",
```

This can then be called in code like so `context.t.auth_enterEmail`

### arb-editor extension

The arb-editor extension, made by Google, can be very helpful in working with arb localization files. It is recommended to install it for adding data to arb files.

#### arb-editor settings

If you are using the arb-editor extension, you should add the following to your local vsCode settings to prevent warnings that we are ignoring.

```json
  "arb-editor.suppressedWarnings": [
    "missing_metadata_for_key",
    "metadata_for_missing_key"
  ],
```

### Highlight extension

With long arb files it can become difficult to make out the section titles we are using to separate features, for this reason we recommend installing the [Highlight](https://marketplace.visualstudio.com/items?itemName=fabiospampinato.vscode-highlight) extension

#### Highlight settings

After installing the extension you will need to add the following to your settings file:

```json
  "highlight.regexes": {
    "(\"@_[A-Z_]+\": {},)": {
      "filterFileRegex": ".*\\.arb",
      "decorations": [
        {
          "overviewRulerColor": "#70d187",
          "backgroundColor": "#70d187",
          "color": "#000000",
          "fontWeight": "bold"
        }
      ]
    },
  },
```

You can adjust these colors as desired.

## Google Cloud Logging

To see logs in the Google Cloud console for this app, please add the Google Cloud Logging environment variables to the `.env` file. You will find these items in 1Password.

Then re-run build

```shell
dart run build_runner clean
dart run build_runner build --delete-conflicting-outputs
```

## Running Integration Tests

This project uses the integration_test package for integration testing. There are two ways to run integration tests: using flutter test (recommended) or flutter drive (optional).

### Using flutter test (Recommended)

For most use cases, you can run integration tests using `flutter test`, which does not require a separate test driver:

```shell
flutter test integration_test/app_test.dart
```

### Using Flutter drive (Optional)

If you need to run integration tests on a real device or emulator in a separate process, you can use flutter drive:

```shell
flutter drive --driver=test_driver/integration_test.dart --target=integration_test/app_test.dart
```

Use flutter drive when:

- You need to run tests on a real device or emulator (instead of a simulated test environment).
- You need to profile performance metrics, such as frame rendering times and memory usage.
- You want to test background behavior or deep linking in a separate process.

## Additional Documentation

- [Wiki](https://github.com/8thlight/flutter-starter-kit/wiki)
