import 'dart:io';

import 'package:dart_console/dart_console.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../bin/utils/terminal_utils.dart';

class MockStdout extends Mock implements Stdout {}

class MockStdin extends Mock implements Stdin {}

class MockConsole extends Mock implements Console {}

class MockKey extends Mock implements Key {}

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
    late MockConsole mockConsole;

    setUp(() {
      mockStdout = MockStdout();
      mockStdin = MockStdin();
      mockConsole = MockConsole();

      term = TermUtils(
        stdout: mockStdout,
        stdin: mockStdin,
        console: mockConsole,
      );
    });

    tearDown(() {
      reset(mockStdout);
      reset(mockStdin);
      reset(mockConsole);
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

    group('tPrintYesNoQuestion', () {
      test('returns true when user inputs y', () {
        when(() => mockStdin.readLineSync()).thenReturn('y');
        expect(term.tPrintYesNoQuestion('Question?'), true);
      });

      test('returns true when user inputs Y', () {
        when(() => mockStdin.readLineSync()).thenReturn('Y');
        expect(term.tPrintYesNoQuestion('Question?'), true);
      });

      test('returns false when user inputs n', () {
        when(() => mockStdin.readLineSync()).thenReturn('n');
        expect(term.tPrintYesNoQuestion('Question?'), false);
      });

      test('returns false when user inputs N', () {
        when(() => mockStdin.readLineSync()).thenReturn('N');
        expect(term.tPrintYesNoQuestion('Question?'), false);
      });

      test('keeps asking until valid input is received', () {
        final List<String> answers = <String>['invalid', '', 'y'];
        int count = 0;
        when(() => mockStdin.readLineSync())
            .thenAnswer((_) => answers[count++]);

        expect(term.tPrintYesNoQuestion('Question?'), true);
        verify(() => mockStdin.readLineSync()).called(3);
      });
    });

    group('tPrintInteractiveSelect', () {
      const List<String> options = <String>['Option 1', 'Option 2', 'Option 3'];
      const String prompt = 'Select an option:';

      setUp(() {
        when(() => mockConsole.clearScreen()).thenReturn(null);
        when(() => mockConsole.resetCursorPosition()).thenReturn(null);
        when(() => mockConsole.write(any())).thenReturn(null);
      });

      test('selects option with enter key', () {
        final MockKey enterKey = MockKey();
        when(() => enterKey.controlChar).thenReturn(ControlCharacter.enter);
        when(() => enterKey.char).thenReturn('');
        when(() => mockConsole.readKey()).thenReturn(enterKey);

        final String result = term.tPrintInteractiveSelect(options, prompt);
        expect(result, options[0]);
      });

      test('moves selection down and selects', () {
        final MockKey downKey = MockKey();
        when(() => downKey.controlChar).thenReturn(ControlCharacter.arrowDown);
        when(() => downKey.char).thenReturn('');

        final MockKey enterKey = MockKey();
        when(() => enterKey.controlChar).thenReturn(ControlCharacter.enter);
        when(() => enterKey.char).thenReturn('');

        int callCount = 0;
        when(() => mockConsole.readKey()).thenAnswer((_) {
          callCount++;
          return callCount == 1 ? downKey : enterKey;
        });

        final String result = term.tPrintInteractiveSelect(options, prompt);
        expect(result, options[1]);
      });

      test('moves selection up and selects', () {
        final MockKey downKey = MockKey();
        when(() => downKey.controlChar).thenReturn(ControlCharacter.arrowDown);
        when(() => downKey.char).thenReturn('');

        final MockKey upKey = MockKey();
        when(() => upKey.controlChar).thenReturn(ControlCharacter.arrowUp);
        when(() => upKey.char).thenReturn('');

        final MockKey enterKey = MockKey();
        when(() => enterKey.controlChar).thenReturn(ControlCharacter.enter);
        when(() => enterKey.char).thenReturn('');

        int callCount = 0;
        when(() => mockConsole.readKey()).thenAnswer((_) {
          callCount++;
          if (callCount == 1) return downKey;
          if (callCount == 2) return upKey;
          return enterKey;
        });

        final String result = term.tPrintInteractiveSelect(options, prompt);
        expect(result, options[0]);
      });

      test('supports WASD controls', () {
        final MockKey sKey = MockKey();
        when(() => sKey.controlChar).thenReturn(ControlCharacter.unknown);
        when(() => sKey.char).thenReturn('s');

        final MockKey wKey = MockKey();
        when(() => wKey.controlChar).thenReturn(ControlCharacter.unknown);
        when(() => wKey.char).thenReturn('w');

        final MockKey enterKey = MockKey();
        when(() => enterKey.controlChar).thenReturn(ControlCharacter.enter);
        when(() => enterKey.char).thenReturn('');

        int callCount = 0;
        when(() => mockConsole.readKey()).thenAnswer((_) {
          callCount++;
          if (callCount == 1) return sKey;
          if (callCount == 2) return wKey;
          return enterKey;
        });

        final String result = term.tPrintInteractiveSelect(options, prompt);
        expect(result, options[0]);
      });

      test('supports vim controls', () {
        final MockKey jKey = MockKey();
        when(() => jKey.controlChar).thenReturn(ControlCharacter.unknown);
        when(() => jKey.char).thenReturn('j');

        final MockKey kKey = MockKey();
        when(() => kKey.controlChar).thenReturn(ControlCharacter.unknown);
        when(() => kKey.char).thenReturn('k');

        final MockKey enterKey = MockKey();
        when(() => enterKey.controlChar).thenReturn(ControlCharacter.enter);
        when(() => enterKey.char).thenReturn('');

        int callCount = 0;
        when(() => mockConsole.readKey()).thenAnswer((_) {
          callCount++;
          if (callCount == 1) return jKey;
          if (callCount == 2) return kKey;
          return enterKey;
        });

        final String result = term.tPrintInteractiveSelect(options, prompt);
        expect(result, options[0]);
      });

      test('cannot move selection above first option', () {
        final MockKey upKey = MockKey();
        when(() => upKey.controlChar).thenReturn(ControlCharacter.arrowUp);
        when(() => upKey.char).thenReturn('');

        final MockKey enterKey = MockKey();
        when(() => enterKey.controlChar).thenReturn(ControlCharacter.enter);
        when(() => enterKey.char).thenReturn('');

        int callCount = 0;
        when(() => mockConsole.readKey()).thenAnswer((_) {
          callCount++;
          return callCount == 1 ? upKey : enterKey;
        });

        final String result = term.tPrintInteractiveSelect(options, prompt);
        expect(result, options[0]);

        verify(() => mockConsole.clearScreen()).called(2);
        verify(() => mockConsole.resetCursorPosition()).called(2);
      });

      test('cannot move selection below last option', () {
        final MockKey downKey = MockKey();
        when(() => downKey.controlChar).thenReturn(ControlCharacter.arrowDown);
        when(() => downKey.char).thenReturn('');

        final MockKey enterKey = MockKey();
        when(() => enterKey.controlChar).thenReturn(ControlCharacter.enter);
        when(() => enterKey.char).thenReturn('');

        int callCount = 0;
        when(() => mockConsole.readKey()).thenAnswer((_) {
          callCount++;
          return callCount <= 4 ? downKey : enterKey;
        });

        final String result = term.tPrintInteractiveSelect(options, prompt);
        expect(result, options[2]);

        verify(() => mockConsole.clearScreen()).called(5);
        verify(() => mockConsole.resetCursorPosition()).called(5);
      });

      test('displays extra note when provided', () {
        const String extraNote = 'Press arrow keys to navigate';
        final MockKey enterKey = MockKey();
        when(() => enterKey.controlChar).thenReturn(ControlCharacter.enter);
        when(() => enterKey.char).thenReturn('');
        when(() => mockConsole.readKey()).thenReturn(enterKey);

        term.tPrintInteractiveSelect(
          options,
          prompt,
          extraNote: extraNote,
        );

        verify(() => mockStdout.write(contains(prompt))).called(1);
        verify(() => mockStdout.write(contains(extraNote))).called(1);

        for (final String option in options) {
          verify(() => mockStdout.write(contains(option))).called(1);
        }

        verify(() => mockConsole.clearScreen()).called(1);
        verify(() => mockConsole.resetCursorPosition()).called(1);
      });

      test('redraws screen on each key press', () {
        final MockKey downKey = MockKey();
        when(() => downKey.controlChar).thenReturn(ControlCharacter.arrowDown);
        when(() => downKey.char).thenReturn('');

        final MockKey upKey = MockKey();
        when(() => upKey.controlChar).thenReturn(ControlCharacter.arrowUp);
        when(() => upKey.char).thenReturn('');

        final MockKey enterKey = MockKey();
        when(() => enterKey.controlChar).thenReturn(ControlCharacter.enter);
        when(() => enterKey.char).thenReturn('');

        int callCount = 0;
        when(() => mockConsole.readKey()).thenAnswer((_) {
          callCount++;
          if (callCount == 1) return downKey;
          if (callCount == 2) return upKey;
          return enterKey;
        });

        term.tPrintInteractiveSelect(options, prompt);

        verify(() => mockConsole.clearScreen()).called(3);
        verify(() => mockConsole.resetCursorPosition()).called(3);

        for (final String option in options) {
          verify(() => mockStdout.write(contains(option))).called(3);
        }
      });
    });

    group('exitWithError', () {
      late int? exitCode;

      setUp(() {
        exitCode = null;
        term = TermUtils(
          stdout: mockStdout,
          stdin: mockStdin,
          console: mockConsole,
          exit: (int code) {
            exitCode = code;
            throw TestFailure('Exited');
          },
        );
      });

      test('prints error message and exits with code 1', () {
        const String errorMessage = 'error message';

        when(() => mockStdout.write(any())).thenReturn(null);

        expect(
          () => term.exitWithError(errorMessage),
          throwsA(isA<TestFailure>()),
        );

        const String expected = '\u001b[31merror message\u001b[0m\n';
        verify(() => mockStdout.write(expected)).called(1);
        expect(exitCode, equals(1));
      });
    });
  });
}
