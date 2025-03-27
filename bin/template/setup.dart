import 'dart:io';

import 'package:args/args.dart';

import '../utils/general_utils.dart';
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
  await githubCli.confirmGitHubUser();
  await githubCli.confirmOrganization();

  String appName = argResults['app-name'] as String? ?? '';
  if (appName == '') {
    appName = term.tPrintInputUntilNotEmpty(
      'Enter your new app name in title case (e.g. Flutter Starter Kit): ',
    );
  }
  githubCli.repoName = toKebabCase(appName);

  if (await githubCli.doesRepositoryExist(Repo.frontEnd)) {
    term.exitWithError('Frontend repository name already exists.');
  }

  if (await githubCli.doesRepositoryExist(Repo.backEnd)) {
    term.exitWithError('Backend repository name already exists.');
  }

  final StringReplacer replacer = StringReplacer();
  await replacer.updateAppName(appName);

  final FolderMover folderMover = FolderMover();
  await folderMover.move('workflows', '../../.github/workflows');

  await githubCli.createRepository(Repo.frontEnd);

  String rootDir;

  try {
    rootDir = await githubCli.cloneBackendRepo();
  } catch (e) {
    term.exitWithError('Failed to clone backend repository.');
  }

  await githubCli.createRepository(Repo.backEnd, rootDir: rootDir);
}

void _setupIntroduction(TermUtils term) {
  term.tNewLine();

  term.tPrint(FontCodes.green, 'Welcome to the Flutter Starter Kit setup script!');

  term.tPrint(
    FontCodes.normal,
    'This script will help you setup your new Flutter project with the Flutter Starter Kit template.',
  );

  term.tPrint(FontCodes.normal, 'You must have the Github CLI installed to use this script.');

  term.tNewLine();
}
