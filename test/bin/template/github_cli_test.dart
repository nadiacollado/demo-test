import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../bin/template/github_cli.dart';
import '../../../bin/utils/cli_utils.dart';
import '../../../bin/utils/terminal_utils.dart';

class MockCliUtils extends Mock implements CliUtils {}

class MockTermUtils extends Mock implements TermUtils {}

class MockDirectory extends Mock implements Directory {}

void main() {
  group('GithubCli', () {
    late GithubCli githubCli;
    late MockCliUtils mockCliUtils;
    late MockTermUtils mockTermUtils;

    const String testOrg = 'test-org';
    const String testRepo = 'test-repo';
    const String testFullName = '$testOrg/$testRepo';
    const String testPath = '/test/path';

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

        githubCli.username = 'testuser';

        final String result = await githubCli.confirmOrganization();
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

        githubCli.username = 'testuser';

        final String result = await githubCli.confirmOrganization();
        expect(result, equals('org1'));
      });
    });

    group('createRepository', () {
      setUp(() {
        githubCli.repoName = 'test-repo';
        githubCli.organization = 'test-org';
      });

      group('validateCreateRepository', () {
        test('calls exitWithError when repoName is empty', () {
          githubCli.repoName = '';
          when(() => mockTermUtils.exitWithError(any()))
              .thenAnswer((_) => throw Exception('Exit called'));

          expect(
            () => githubCli.validateCreateRepository(Repo.frontEnd),
            throwsException,
          );

          verify(
            () => mockTermUtils.exitWithError(
              'repoName is empty. Ensure the app name is set properly',
            ),
          ).called(1);
        });

        test('calls exitWithError when organization is empty', () {
          githubCli.organization = '';
          when(() => mockTermUtils.exitWithError(any()))
              .thenAnswer((_) => throw Exception('Exit called'));

          expect(
            () => githubCli.validateCreateRepository(Repo.frontEnd),
            throwsException,
          );

          verify(
            () => mockTermUtils.exitWithError(
              'organization is empty. Ensure the organization is set properly',
            ),
          ).called(1);
        });

        test('does not call exitWithError when repoName and organization are not empty', () {
          expect(
            () => githubCli.validateCreateRepository(Repo.frontEnd),
            returnsNormally,
          );

          verifyNever(() => mockTermUtils.exitWithError(any()));
        });
      });
      group('doesRepositoryExist', () {
        test('returns true if repository exists', () async {
          when(
            () => mockCliUtils.runCommand(
              'gh',
              arguments: <String>['repo', 'view', testFullName],
            ),
          ).thenAnswer((_) async => '');

          final bool result = await githubCli.doesRepositoryExist(Repo.frontEnd);
          expect(result, isTrue);
        });

        test('returns false if repository does not exist', () async {
          when(
            () => mockCliUtils.runCommand(
              'gh',
              arguments: <String>['repo', 'view', testFullName],
            ),
          ).thenThrow(
            CliException(
              command: 'gh',
              arguments: <String>['repo', 'view', testFullName],
              errorOutput: 'repository not found',
              exitCode: 1,
            ),
          );

          when(() => mockTermUtils.tPrint(FontCodes.red, any())).thenReturn(null);

          final bool result = await githubCli.doesRepositoryExist(Repo.frontEnd);
          expect(result, isFalse);
          verify(
            () => mockTermUtils.tPrint(
              FontCodes.green,
              'Repository "$testFullName" does not exist.',
            ),
          ).called(1);
        });
      });

      group('runCreateRepo', () {
        test('calls runCommand with correct arguments', () async {
          when(
            () => mockCliUtils.runCommand(
              'gh',
              arguments: <String>['repo', 'create', testFullName, '--private'],
            ),
          ).thenAnswer((_) async => '');

          when(() => mockTermUtils.tPrint(FontCodes.green, any())).thenReturn(null);

          await githubCli.runCreateRepo(testFullName);

          verify(
            () => mockCliUtils.runCommand(
              'gh',
              arguments: <String>['repo', 'create', testFullName, '--private'],
            ),
          ).called(1);

          verify(
            () => mockTermUtils.tPrint(
              FontCodes.green,
              'Repository "$testFullName" created.',
            ),
          ).called(1);
        });

        test('throws CliException when runCommand fails', () async {
          final CliException exception = CliException(
            command: 'gh',
            arguments: <String>['repo', 'create', testFullName, '--private'],
            errorOutput: 'failed to create repo',
            exitCode: 1,
          );

          when(
            () => mockCliUtils.runCommand(
              'gh',
              arguments: <String>['repo', 'create', testFullName, '--private'],
            ),
          ).thenThrow(exception);

          when(() => mockTermUtils.exitWithError(any()))
              .thenAnswer((_) => throw Exception('Exit called'));

          expect(
            () async => githubCli.runCreateRepo(testFullName),
            throwsException,
          );
        });
      });

      group('changeLocalOrigin', () {
        test('calls runCommand with correct arguments', () async {
          when(
            () => mockCliUtils.runCommand(
              'git',
              arguments: <String>['remote', 'rm', 'origin'],
              workingDirectory: testPath,
            ),
          ).thenAnswer((_) async => '');

          when(
            () => mockCliUtils.runCommand(
              'git',
              arguments: <String>[
                'remote',
                'add',
                'origin',
                'https://github.com/$testFullName.git',
              ],
              workingDirectory: testPath,
            ),
          ).thenAnswer((_) async => '');

          when(() => mockTermUtils.tPrint(FontCodes.green, any())).thenReturn(null);

          await githubCli.changeLocalOrigin(testFullName, rootDir: testPath);

          verify(
            () => mockCliUtils.runCommand(
              'git',
              arguments: <String>['remote', 'rm', 'origin'],
              workingDirectory: testPath,
            ),
          ).called(1);

          verify(
            () => mockCliUtils.runCommand(
              'git',
              arguments: <String>[
                'remote',
                'add',
                'origin',
                'https://github.com/$testFullName.git',
              ],
              workingDirectory: testPath,
            ),
          ).called(1);

          verify(
            () => mockTermUtils.tPrint(
              FontCodes.green,
              'Remote origin added to repository "$testFullName".',
            ),
          ).called(1);
        });
      });

      group('createNewRepo', () {
        test('calls runCreateRepo, changeLocalOrigin, and pushChanges on success', () async {
          when(() => mockCliUtils.pushChanges(rootDir: testPath)).thenAnswer((_) async {});
          when(() => mockTermUtils.tPrint(FontCodes.green, any())).thenReturn(null);
          when(
            () => mockCliUtils.runCommand(
              'gh',
              arguments: any(named: 'arguments'),
              workingDirectory: any(named: 'workingDirectory'),
            ),
          ).thenAnswer((_) async => '');
          when(
            () => mockCliUtils.runCommand(
              'git',
              arguments: any(named: 'arguments'),
              workingDirectory: any(named: 'workingDirectory'),
            ),
          ).thenAnswer((_) async => '');

          await githubCli.createNewRepo(Repo.frontEnd, testFullName, rootDir: testPath);

          verify(
            () => mockTermUtils.tPrint(
              FontCodes.green,
              'Repository "$testFullName" created successfully.',
            ),
          ).called(1);
          verify(
            () => mockCliUtils.runCommand(
              'gh',
              arguments: <String>[
                'repo',
                'create',
                testFullName,
                '--private',
              ],
            ),
          ).called(1);
          verify(
            () => mockCliUtils.runCommand(
              'git',
              arguments: <String>['remote', 'rm', 'origin'],
              workingDirectory: testPath,
            ),
          ).called(1);
          verify(
            () => mockCliUtils.runCommand(
              'git',
              arguments: <String>[
                'remote',
                'add',
                'origin',
                'https://github.com/$testFullName.git',
              ],
              workingDirectory: testPath,
            ),
          ).called(1);
        });
      });

      group('cloneBackendRepo', () {
        test('successfully clones backend repo', () async {
          when(
            () => mockCliUtils.runCommand(
              'git',
              arguments: <String>[
                'clone',
                'https://github.com/8thlight/flutter-starter-kit-backend',
              ],
              workingDirectory: any(named: 'workingDirectory'),
            ),
          ).thenAnswer((_) async => '');

          final MockDirectory mockBackendRepoDir = MockDirectory();
          when(() => mockBackendRepoDir.existsSync()).thenReturn(true);

          final String result =
              await githubCli.cloneBackendRepo(backendRepoDir: mockBackendRepoDir);
          expect(result, contains('flutter-starter-kit-backend'));

          verify(
            () => mockCliUtils.runCommand(
              'git',
              arguments: <String>[
                'clone',
                'https://github.com/8thlight/flutter-starter-kit-backend',
              ],
              workingDirectory: any(named: 'workingDirectory'),
            ),
          ).called(1);
        });

        test('throws exception when cloning fails', () async {
          when(
            () => mockCliUtils.runCommand(
              'git',
              arguments: <String>[
                'clone',
                'https://github.com/8thlight/flutter-starter-kit-backend',
              ],
              workingDirectory: any(named: 'workingDirectory'),
            ),
          ).thenThrow(Exception('Git clone failed'));

          expect(
            () async => githubCli.cloneBackendRepo(),
            throwsException,
          );
        });
      });
    });
  });
}
