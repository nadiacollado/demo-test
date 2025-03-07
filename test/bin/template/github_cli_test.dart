import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../bin/template/github_cli.dart';
import '../../../bin/utils/cli_utils.dart';
import '../../../bin/utils/terminal_utils.dart';

class MockCliUtils extends Mock implements CliUtils {}

class MockTermUtils extends Mock implements TermUtils {}

void main() {
  group('GithubCli', () {
    late GithubCli githubCli;
    late MockCliUtils mockCliUtils;
    late MockTermUtils mockTermUtils;

    setUp(() {
      mockCliUtils = MockCliUtils();
      mockTermUtils = MockTermUtils();
      githubCli = GithubCli(
        cliUtils: mockCliUtils,
        termUtils: mockTermUtils,
      );
    });

    group('getUsername', () {
      test('returns username when gh cli command succeeds', () async {
        when(
          () => mockCliUtils.runCommand(
            'gh',
            arguments: <String>['api', 'user', '--jq', '.login'],
          ),
        ).thenAnswer((_) async => 'testuser');

        final String result = await githubCli.getUsername();
        expect(result, equals('testuser'));
      });

      test('calls exitWithError when gh cli is not installed', () async {
        when(
          () => mockCliUtils.runCommand(
            'gh',
            arguments: <String>['api', 'user', '--jq', '.login'],
          ),
        ).thenThrow(
          CliException(
            command: 'gh',
            arguments: <String>['api', 'user', '--jq', '.login'],
            errorOutput: 'command not found',
            exitCode: 127,
          ),
        );

        when(() => mockTermUtils.exitWithError(any()))
            .thenAnswer((_) => throw Exception('Exit called'));

        expect(
          () async => githubCli.getUsername(),
          throwsException,
        );

        verify(
          () => mockTermUtils.exitWithError(
            'GitHub CLI not found. Please install it from: https://cli.github.com/',
          ),
        ).called(1);
      });

      test('calls exitWithError when user is not logged in', () async {
        when(
          () => mockCliUtils.runCommand(
            'gh',
            arguments: <String>['api', 'user', '--jq', '.login'],
          ),
        ).thenThrow(
          CliException(
            command: 'gh',
            arguments: <String>['api', 'user', '--jq', '.login'],
            errorOutput: 'not logged in',
            exitCode: 1,
          ),
        );

        when(() => mockTermUtils.exitWithError(any()))
            .thenAnswer((_) => throw Exception('Exit called'));

        expect(
          () async => githubCli.getUsername(),
          throwsException,
        );

        verify(
          () => mockTermUtils.exitWithError(
            'Failed to get GitHub username. Please make sure you are logged in by running: gh auth login',
          ),
        ).called(1);
      });
    });

    group('confirmGitHubUser', () {
      test('returns username when user confirms', () async {
        when(
          () => mockCliUtils.runCommand(
            'gh',
            arguments: <String>['api', 'user', '--jq', '.login'],
          ),
        ).thenAnswer((_) async => 'testuser');

        when(() => mockTermUtils.tPrintYesNoQuestion(any())).thenReturn(true);

        final String result = await githubCli.confirmGitHubUser();
        expect(result, equals('testuser'));
      });

      test('calls exitWithError when user does not confirm', () async {
        when(
          () => mockCliUtils.runCommand(
            'gh',
            arguments: <String>['api', 'user', '--jq', '.login'],
          ),
        ).thenAnswer((_) async => 'testuser');

        when(() => mockTermUtils.tPrintYesNoQuestion(any())).thenReturn(false);

        when(() => mockTermUtils.exitWithError(any()))
            .thenAnswer((_) => throw Exception('Exit called'));

        try {
          await githubCli.confirmGitHubUser();
          fail('Should have thrown an exception');
        } catch (_) {
          verify(
            () => mockTermUtils.exitWithError(
              'Please log in to the GitHub CLI with the user you wish to use by running: gh auth login',
            ),
          ).called(1);
        }
      });
    });

    group('getOrganizations', () {
      test('returns list of organizations when command succeeds', () async {
        when(
          () => mockCliUtils.runCommand(
            'gh',
            arguments: <String>['org', 'list'],
          ),
        ).thenAnswer(
          (_) async => '''
Showing 3 of 3 organizations

org1
org2
org3

A new release of gh is available: v2.0.0
To upgrade, run: brew update && brew upgrade gh''',
        );

        final List<String> result = await githubCli.getOrganizations();
        expect(
          result,
          equals(<String>['org1', 'org2', 'org3']),
        );
      });

      test('filters out empty lines and metadata text', () async {
        when(
          () => mockCliUtils.runCommand(
            'gh',
            arguments: <String>['org', 'list'],
          ),
        ).thenAnswer(
          (_) async => '''
Showing 2 of 2 organizations

org1

org2

A new release of gh is available: v2.0.0
To upgrade, run: brew update && brew upgrade gh
https://github.com/cli/cli/releases/tag/v2.0.0''',
        );

        final List<String> result = await githubCli.getOrganizations();
        expect(
          result,
          equals(<String>['org1', 'org2']),
        );
      });

      test('calls exitWithError when command fails', () async {
        final CliException exception = CliException(
          command: 'gh',
          arguments: <String>['org', 'list'],
          errorOutput: 'failed to fetch orgs',
          exitCode: 1,
        );

        when(
          () => mockCliUtils.runCommand(
            'gh',
            arguments: <String>['org', 'list'],
          ),
        ).thenThrow(exception);

        when(() => mockTermUtils.exitWithError(any()))
            .thenAnswer((_) => throw Exception('Exit called'));

        try {
          await githubCli.getOrganizations();
          fail('Should have thrown an exception');
        } catch (_) {
          verify(
            () => mockTermUtils.exitWithError(
              'Failed to fetch organizations. Error: $exception',
            ),
          ).called(1);
        }
      });
    });

    group('confirmOrganization', () {
      test('returns username when personal account is selected', () async {
        when(
          () => mockCliUtils.runCommand(
            'gh',
            arguments: <String>['org', 'list'],
          ),
        ).thenAnswer((_) async => 'org1\norg2');

        when(
          () => mockTermUtils.tPrintInteractiveSelect(
            any(),
            any(),
            extraNote: any(named: 'extraNote'),
          ),
        ).thenReturn('personal account: testuser');

        final String result = await githubCli.confirmOrganization('testuser');
        expect(result, equals('testuser'));
      });

      test('returns organization name when org is selected', () async {
        when(
          () => mockCliUtils.runCommand(
            'gh',
            arguments: <String>['org', 'list'],
          ),
        ).thenAnswer((_) async => 'org1\norg2');

        when(
          () => mockTermUtils.tPrintInteractiveSelect(
            any(),
            any(),
            extraNote: any(named: 'extraNote'),
          ),
        ).thenReturn('org1');

        final String result = await githubCli.confirmOrganization('testuser');
        expect(result, equals('org1'));
      });
    });
  });
}
