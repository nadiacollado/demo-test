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
