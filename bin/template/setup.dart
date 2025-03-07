import 'dart:io';

import 'package:args/args.dart';

import '../utils/terminal_utils.dart';
import 'folder_mover.dart';
import 'github_cli.dart';
import 'string_replacer.dart';

void main(List<String> args) async {
  exitCode = 0;
  final TermUtils term = TermUtils();
  final ArgParser argParser = ArgParser()..addOption('app-name', abbr: 'n');

  final ArgResults argResults = argParser.parse(args);

  _setupIntroduction(term);

  final GithubCli githubCli = GithubCli();
  final String username = await githubCli.confirmGitHubUser();

  // ignore: unused_local_variable - This will be used soon
  final String organization = await githubCli.confirmOrganization(username);

  String appName = argResults['app-name'] as String? ?? '';
  if (appName == '') {
    appName = term.tPrintInputUntilNotEmpty(
      'Enter your new app name in title case (e.g. Flutter Starter Kit): ',
    );
  }

  final StringReplacer replacer = StringReplacer();
  replacer.updateAppName(appName);

  final FolderMover folderMover = FolderMover();
  folderMover.move('workflows', '../../.github/workflows');
}

void _setupIntroduction(TermUtils term) {
  term.tNewLine();

  term.tPrint(
    FontCodes.green,
    'Welcome to the Flutter Starter Kit setup script!',
  );

  term.tPrint(
    FontCodes.normal,
    'This script will help you setup your new Flutter project with the Flutter Starter Kit template.',
  );

  term.tPrint(
    FontCodes.normal,
    'You must have the Github CLI installed to use this script.',
  );

  term.tNewLine();
}
