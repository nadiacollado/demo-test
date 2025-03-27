import 'dart:io';

import '../utils/cli_utils.dart';
import '../utils/general_utils.dart';
import '../utils/terminal_utils.dart';

enum Repo {
  frontEnd(label: 'Front End'),
  backEnd(label: 'Back End');

  const Repo({
    required this.label,
  });

  final String label;
}

class GithubCli {
  GithubCli({
    CliUtils? cliUtils,
    TermUtils? termUtils,
  })  : _cliUtils = cliUtils ?? CliUtils(),
        _termUtils = termUtils ?? TermUtils();

  final CliUtils _cliUtils;
  final TermUtils _termUtils;

  String username = '';
  String organization = '';
  String validatedFrontEndRepoFullName = '';
  String validatedBackEndRepoFullName = '';
  String repoName = '';

  Future<String> confirmGitHubUser() async {
    final String username = await getUsername();
    final bool isConfirmed = _termUtils.tPrintYesNoQuestion(
      'Is "$username" the GitHub account you want to use?',
    );
    if (!isConfirmed) {
      _termUtils.exitWithError(
        'Please log in to the GitHub CLI with the user you wish to use by running: gh auth login',
      );
    }

    this.username = username;

    return username;
  }

  Future<String> getUsername() async {
    try {
      final String result = await _cliUtils.runCommand(
        'gh',
        arguments: <String>['api', 'user', '--jq', '.login'],
      );
      return result;
    } on CliException catch (e) {
      if (e.exitCode == 127) {
        _termUtils.exitWithError(
          'GitHub CLI not found. Please install it from: https://cli.github.com/',
        );
      } else {
        _termUtils.exitWithError(
          'Failed to get GitHub username. Please make sure you are logged in by running: gh auth login',
        );
      }
    }
  }

  Future<List<String>> getOrganizations() async {
    try {
      final String result = await _cliUtils.runCommand(
        'gh',
        arguments: <String>['org', 'list'],
      );

      final List<String> lines =
          result.split('\n').where((String line) => line.trim().isNotEmpty).toList();

      final List<String> orgNames = lines
          .where(
            (String line) =>
                !line.startsWith('Showing') &&
                !line.startsWith('A new release') &&
                !line.startsWith('To upgrade') &&
                !line.startsWith('http') &&
                !line.startsWith('There are no'),
          )
          .map((String line) => line.trim())
          .where((String line) => line.isNotEmpty)
          .toList();

      return orgNames;
    } on CliException catch (e) {
      _termUtils.exitWithError(
        'Failed to fetch organizations. Error: $e',
      );
    }
  }

  Future<String> confirmOrganization() async {
    final List<String> orgNames = await getOrganizations();

    final String personalAccount = 'personal account: $username';

    final List<String> options = <String>[personalAccount, ...orgNames];

    const String prompt = 'Select where to create the repository';
    const String note =
        'Note: You must have permissions to create repositories in the selected organization.';
    final String organization = _termUtils.tPrintInteractiveSelect(
      options,
      prompt,
      extraNote: note,
    );

    final String accountToUse = (organization == personalAccount) ? username : organization;

    this.organization = accountToUse;

    return accountToUse;
  }

  Future<void> createRepository(Repo repo, {String? rootDir}) async {
    late final String newRepoName;

    switch (repo) {
      case Repo.frontEnd:
        newRepoName = repoName;
      case Repo.backEnd:
        newRepoName = '$repoName-backend';
    }

    final String repoFullName = '$organization/$newRepoName';

    await createNewRepo(repo, repoFullName, rootDir: rootDir);
  }

  void validateCreateRepository(Repo repo) {
    if (repoName.isEmpty) {
      _termUtils.exitWithError(
        'repoName is empty. Ensure the app name is set properly',
      );
    }
    if (organization.isEmpty) {
      _termUtils.exitWithError(
        'organization is empty. Ensure the organization is set properly',
      );
    }
  }

  Future<bool> doesRepositoryExist(Repo repo) async {
    validateCreateRepository(repo);
    late final String newRepoName;

    switch (repo) {
      case Repo.frontEnd:
        newRepoName = repoName;
      case Repo.backEnd:
        newRepoName = '$repoName-backend';
    }

    final String repoFullName = '$organization/$newRepoName';

    try {
      await _cliUtils.runCommand('gh', arguments: <String>['repo', 'view', repoFullName]);
    } on CliException catch (e) {
      if (e.exitCode != 0) {
        _termUtils.tPrint(
          FontCodes.green,
          'Repository "$repoFullName" does not exist.',
        );
        return false;
      }
    }
    return true;
  }

  Future<void> createNewRepo(Repo repo, String newRepoName, {String? rootDir}) async {
    _termUtils.tPrint(FontCodes.green, 'Creating repository with name "$newRepoName"');

    try {
      await runCreateRepo(newRepoName);
      await changeLocalOrigin(newRepoName, rootDir: rootDir);
      await _cliUtils.pushChanges(rootDir: rootDir);

      _termUtils.tPrint(FontCodes.green, 'Repository "$newRepoName" created successfully.');
      switch (repo) {
        case Repo.frontEnd:
          validatedFrontEndRepoFullName = newRepoName;
        case Repo.backEnd:
          validatedBackEndRepoFullName = newRepoName;
      }
    } on CliException catch (e) {
      _termUtils.exitWithError('Failed to create repository "$newRepoName". Error: $e');
    }
  }

  Future<void> runCreateRepo(String newRepoName) async {
    await _cliUtils.runCommand(
      'gh',
      arguments: <String>['repo', 'create', newRepoName, '--private'],
    );

    _termUtils.tPrint(FontCodes.green, 'Repository "$newRepoName" created.');
  }

  Future<void> changeLocalOrigin(String newRepoName, {String? rootDir}) async {
    final String repoRoot = rootDir ?? getRepositoryRoot();

    await _cliUtils.runCommand(
      'git',
      arguments: <String>[
        'remote',
        'rm',
        'origin',
      ],
      workingDirectory: repoRoot,
    );

    await _cliUtils.runCommand(
      'git',
      arguments: <String>[
        'remote',
        'add',
        'origin',
        'https://github.com/$newRepoName.git',
      ],
      workingDirectory: repoRoot,
    );

    _termUtils.tPrint(
      FontCodes.green,
      'Remote origin added to repository "$newRepoName".',
    );
  }

  Future<String> cloneBackendRepo({Directory? backendRepoDir}) async {
    try {
      final String frontendRepoRoot = getRepositoryRoot();
      final Directory frontendRepoDir = Directory(frontendRepoRoot);
      final Directory mainDir = frontendRepoDir.parent;

      final String backendRepoPath = '${mainDir.path}/flutter-starter-kit-backend';

      _termUtils.tPrint(
        FontCodes.green,
        'Cloning backend repo into: ${mainDir.path}',
      );

      await _cliUtils.runCommand(
        'git',
        arguments: <String>['clone', 'https://github.com/8thlight/flutter-starter-kit-backend'],
        workingDirectory: mainDir.path,
      );

      backendRepoDir ??= Directory(backendRepoPath);
      if (!backendRepoDir.existsSync()) {
        throw Exception('Failed to clone backend repository into $backendRepoPath.');
      }

      _termUtils.tPrint(
        FontCodes.green,
        'Backend repository cloned successfully.',
      );

      return backendRepoPath;
    } catch (e) {
      _termUtils.tPrint(
        FontCodes.red,
        'Error cloning backend repo: $e',
      );
      rethrow;
    }
  }
}
