import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../bin/utils/terminal_utils.dart';

class MockStdout extends Mock implements Stdout {}

class MockStdin extends Mock implements Stdin {}

void main() {
  const String userInputStr = 'User Input';
  const String questionStr = 'Question';
  const String defaultStr = 'Default';

  setUpAll(() {
    registerFallbackValue(FontCodes.normal);
  });

  group('FontCodes', () {
    final List<FontCodes> fontCodeTests = <FontCodes>[
      FontCodes.normal,
      FontCodes.green,
      FontCodes.yellow,
      FontCodes.red,
      FontCodes.grey,
    ];

    String expectedCode(FontCodes fontCode) {
      switch (fontCode) {
        case FontCodes.normal:
          return '\u001b[0m';
        case FontCodes.green:
          return '\u001b[32m';
        case FontCodes.yellow:
          return '\u001b[33m';
        case FontCodes.red:
          return '\u001b[31m';
        case FontCodes.grey:
          return '\u001b[90m';
      }
    }

    for (final FontCodes fontCode in fontCodeTests) {
      test('font code is correct', () {
        expect(fontCode.code, expectedCode(fontCode));
      });
    }
  });

  group('TermUtils', () {
    late TermUtils term;
    late MockStdout mockStdout;
    late MockStdin mockStdin;

    setUp(() {
      mockStdout = MockStdout();
      mockStdin = MockStdin();

      term = TermUtils(stdout: mockStdout, stdin: mockStdin);
    });

    tearDown(() {
      reset(mockStdout);
      reset(mockStdin);
    });

    group('tPrint', () {
      test('prints text with correct color', () {
        term.tPrint(FontCodes.green, 'Hello');

        const String expected = '\u001b[32mHello\u001b[0m\n';
        verify(() => mockStdout.write(expected)).called(1);
      });

      test('prints text with correct bold color', () {
        term.tPrint(FontCodes.green, 'Hello', bold: true);

        const String expected = '\u001b[1m\u001b[32mHello\u001b[0m\n';
        verify(() => mockStdout.write(expected)).called(1);
      });
    });

    group('tPrintInputWithDefault', () {
      test('returns default answer when no input', () {
        when(() => mockStdin.readLineSync()).thenReturn(null);
        expect(
          term.tPrintInputWithDefault(questionStr, defaultStr),
          defaultStr,
        );
      });

      test('returns user input when provided', () {
        when(() => mockStdin.readLineSync()).thenReturn(userInputStr);
        expect(
          term.tPrintInputWithDefault(questionStr, defaultStr),
          userInputStr,
        );
      });
    });

    group('tPrintInputUntilNotEmpty', () {
      test('returns user input when provided', () {
        when(() => mockStdin.readLineSync()).thenReturn(userInputStr);
        expect(term.tPrintInputUntilNotEmpty(questionStr), userInputStr);
      });

      test('keeps asking for input until not empty', () {
        const int attempts = 3;

        int callCount = 0;
        when(() => mockStdin.readLineSync()).thenAnswer((_) {
          callCount++;
          return callCount == attempts ? userInputStr : '';
        });

        when(() => mockStdout.write(questionStr)).thenReturn(null);

        final String result = term.tPrintInputUntilNotEmpty(questionStr);

        expect(result, userInputStr);
        verify(() => mockStdout.write(questionStr)).called(attempts);
      });
    });
  });
}
