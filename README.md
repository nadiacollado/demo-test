# Flutter Starter Kit

## Documentation

- [Wiki](https://github.com/8thlight/flutter-starter-kit/wiki)

## Getting Started

Ensure that you have your git hooks set up to help make certain that code you push up meets our code quality standards by running the following command in your terminal:

```shell
git config --local core.hooksPath githooks/
```

Before you can begin to run the app. You must create `.env`. See [Environment Variables](#environment-variables) for further details.

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

#### Settings
If you are using the arb-editor extension, you should add the following to your local vsCode settings to prevent warnings that we are ignoring.
```json
  "arb-editor.suppressedWarnings": [
    "missing_metadata_for_key",
    "metadata_for_missing_key"
  ],
```

### Highlight extension
With long arb files it can become difficult to make out the section titles we are using to separate features, for this reason we recommend installing the [Highlight](https://marketplace.visualstudio.com/items?itemName=fabiospampinato.vscode-highlight) extension

#### Settings
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