import 'dart:io' as io;
import 'package:dart_console/dart_console.dart';

enum FontCodes {
  normal(modifier: '0m'),
  green(modifier: '32m'),
  yellow(modifier: '33m'),
  red(modifier: '31m'),
  grey(modifier: '90m');

  const FontCodes({
    required this.modifier,
  });

  final String modifier;
  final String escape = '\u001b[';
  final String bold = '1m';

  String get code => '$escape$modifier';
  String get boldCode => '$escape$bold$escape$modifier';
}

class TermUtils {
  TermUtils({
    final io.Stdout? stdout,
    final io.Stdin? stdin,
    final Console? console,
    Never Function(int)? exit,
  })  : _stdout = stdout ?? io.stdout,
        _stdin = stdin ?? io.stdin,
        _console = console ?? Console(),
        _exit = exit ?? io.exit;

  final io.Stdout _stdout;
  final io.Stdin _stdin;
  final Console _console;
  final Never Function(int) _exit;

  Never exitWithError(String message) {
    tPrint(FontCodes.red, message);
    _exit(1);
  }

  void tNewLine() {
    _stdout.write('\n');
  }

  void tPrint(FontCodes color, String text, {bool bold = false}) {
    final String fontCode = bold ? color.boldCode : color.code;
    final String reset = FontCodes.normal.code;
    _stdout.write('$fontCode$text$reset\n');
  }

  String tPrintInputWithDefault(String question, String defaultAnswer) {
    final String grey = FontCodes.grey.code;
    final String reset = FontCodes.normal.code;

    _stdout.write(question);
    _stdout.write('$grey ($defaultAnswer)$reset: ');

    final String? input = _stdin.readLineSync();

    if (input != null && input.isEmpty) return defaultAnswer;

    return input ?? defaultAnswer;
  }

  String tPrintInputUntilNotEmpty(String question) {
    while (true) {
      _stdout.write(question);
      final String result = _stdin.readLineSync() ?? '';

      if (result.isNotEmpty) {
        return result;
      }
    }
  }

  bool tPrintYesNoQuestion(String question) {
    while (true) {
      tPrint(FontCodes.normal, '$question (y/n)');
      final String result = (_stdin.readLineSync() ?? '').toLowerCase().trim();

      if (result == 'y') {
        return true;
      }
      if (result == 'n') {
        return false;
      }

      tPrint(FontCodes.red, 'Please answer with "y" or "n"');
    }
  }

  String tPrintInteractiveSelect(
    List<String> options,
    String prompt, {
    String? extraNote,
  }) {
    if (options.isEmpty) {
      throw ArgumentError('Options list cannot be empty');
    }

    int selectedIndex = 0;
    bool choosing = true;

    while (choosing) {
      // Clear the screen from the cursor position
      _console.clearScreen();
      _console.resetCursorPosition();

      // Print prompt
      tPrint(FontCodes.normal, prompt);
      if (extraNote != null) {
        tPrint(FontCodes.normal, extraNote);
      }

      // Print all options
      for (int i = 0; i < options.length; i++) {
        if (i == selectedIndex) {
          tPrint(FontCodes.green, '> ${options[i]}', bold: true);
        } else {
          tPrint(FontCodes.normal, '  ${options[i]}');
        }
      }

      // Read key input
      final Key key = _console.readKey();

      if (_isExitCommand(key)) {
        exitWithError('Exiting...');
      }

      // Handle navigation controls
      if (_isUpCommand(key)) {
        if (selectedIndex > 0) selectedIndex--;
      } else if (_isDownCommand(key)) {
        if (selectedIndex < options.length - 1) selectedIndex++;
      } else if (key.controlChar == ControlCharacter.enter) {
        choosing = false;
      }
    }

    _console.write('\n');
    return options[selectedIndex];
  }

  bool _isExitCommand(Key key) {
    if (key.controlChar == ControlCharacter.escape) {
      return true;
    }

    if (key.char == 'q' || key.char == 'Q') {
      return true;
    }

    if (key.controlChar == ControlCharacter.ctrlC) {
      return true;
    }

    return false;
  }

  bool _isUpCommand(Key key) {
    // Arrow keys
    if (key.controlChar == ControlCharacter.arrowUp ||
        key.controlChar == ControlCharacter.arrowLeft) {
      return true;
    }

    // WASD
    if (key.char == 'w' ||
        key.char == 'W' ||
        key.char == 'a' ||
        key.char == 'A') {
      return true;
    }

    // Vim controls
    if (key.char == 'k' ||
        key.char == 'K' ||
        key.char == 'h' ||
        key.char == 'H') {
      return true;
    }

    return false;
  }

  bool _isDownCommand(Key key) {
    // Arrow keys
    if (key.controlChar == ControlCharacter.arrowDown ||
        key.controlChar == ControlCharacter.arrowRight) {
      return true;
    }

    // WASD
    if (key.char == 's' ||
        key.char == 'S' ||
        key.char == 'd' ||
        key.char == 'D') {
      return true;
    }

    // Vim controls
    if (key.char == 'j' ||
        key.char == 'J' ||
        key.char == 'l' ||
        key.char == 'L') {
      return true;
    }

    return false;
  }
}
