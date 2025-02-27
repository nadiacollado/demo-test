import 'dart:io';

import 'package:args/args.dart';

import '../utils/terminal_utils.dart';
import 'folder_mover.dart';
import 'string_replacer.dart';

void main(List<String> args) {
  exitCode = 0;
  final TermUtils term = TermUtils();
  final ArgParser argParser = ArgParser()..addOption('app-name', abbr: 'n');

  final ArgResults argResults = argParser.parse(args);

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
