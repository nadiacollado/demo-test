import 'dart:io' as io;

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import '../../../bin/utils/cli_utils.dart';

class MockProcessManager extends Mock implements ProcessManager {}

class MockProcess extends Mock implements io.Process {}

void main() {
  group('CliUtils', () {
    late MockProcessManager processManager;
    late CliUtils cliUtils;

    setUp(() {
      processManager = MockProcessManager();
      cliUtils = CliUtils(
        processManager: processManager,
      );
    });

    group('runCommand', () {
      test('returns stdout when command succeeds', () async {
        when(
          () => processManager.run(
            any(),
            any(),
            workingDirectory: any(named: 'workingDirectory'),
          ),
        ).thenAnswer(
          (_) async => io.ProcessResult(1, 0, 'success output', ''),
        );

        final String result = await cliUtils.runCommand(
          'test',
          arguments: <String>['arg1', 'arg2'],
          workingDirectory: '/test/dir',
        );

        expect(result, equals('success output'));
        verify(
          () => processManager.run(
            'test',
            <String>['arg1', 'arg2'],
            workingDirectory: '/test/dir',
          ),
        ).called(1);
      });

      test('throws CliException when command fails', () async {
        when(
          () => processManager.run(
            any(),
            any(),
            workingDirectory: any(named: 'workingDirectory'),
          ),
        ).thenAnswer(
          (_) async => io.ProcessResult(1, 1, '', 'error message'),
        );

        expect(
          () => cliUtils.runCommand('test'),
          throwsA(
            isA<CliException>()
                .having(
                  (CliException e) => e.command,
                  'command',
                  equals('test'),
                )
                .having(
                  (CliException e) => e.arguments,
                  'arguments',
                  equals(<String>[]),
                )
                .having(
                  (CliException e) => e.errorOutput,
                  'errorOutput',
                  equals('error message'),
                )
                .having((CliException e) => e.exitCode, 'exitCode', equals(1)),
          ),
        );
      });
    });

    group('startCommand', () {
      test('starts process with correct parameters', () async {
        final MockProcess mockProcess = MockProcess();
        when(
          () => processManager.start(
            any(),
            any(),
            workingDirectory: any(named: 'workingDirectory'),
          ),
        ).thenAnswer((_) async => mockProcess);

        final io.Process result = await cliUtils.startCommand(
          'test',
          arguments: <String>['arg1', 'arg2'],
          workingDirectory: '/test/dir',
        );

        expect(result, equals(mockProcess));
        verify(
          () => processManager.start(
            'test',
            <String>['arg1', 'arg2'],
            workingDirectory: '/test/dir',
          ),
        ).called(1);
      });
    });
  });

  group('CliException', () {
    test('formats toString message correctly', () {
      final CliException exception = CliException(
        command: 'test',
        arguments: <String>['arg1', 'arg2'],
        errorOutput: 'error occurred',
        exitCode: 1,
      );

      expect(
        exception.toString(),
        equals(
          'Command "test arg1 arg2" failed with exit code 1:\nerror occurred',
        ),
      );
    });
  });
}
