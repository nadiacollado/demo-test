import '../utils/cli_utils.dart';
import '../utils/terminal_utils.dart';

class GithubCli {
  GithubCli({
    CliUtils? cliUtils,
    TermUtils? termUtils,
  })  : _cliUtils = cliUtils ?? CliUtils(),
        _termUtils = termUtils ?? TermUtils();

  final CliUtils _cliUtils;
  final TermUtils _termUtils;

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

      final List<String> lines = result
          .split('\n')
          .where((String line) => line.trim().isNotEmpty)
          .toList();

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

  Future<String> confirmOrganization(String username) async {
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

    final String accountToUse =
        (organization == personalAccount) ? username : organization;

    return accountToUse;
  }
}
