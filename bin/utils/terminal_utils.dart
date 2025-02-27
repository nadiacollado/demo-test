import 'dart:io' as io;

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
  })  : _stdout = stdout ?? io.stdout,
        _stdin = stdin ?? io.stdin;

  final io.Stdout _stdout;
  final io.Stdin _stdin;

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
}
