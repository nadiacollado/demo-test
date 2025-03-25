import '../utils/cli_utils.dart';
import '../utils/general_utils.dart';
import '../utils/io_utils.dart';
import '../utils/path_utils.dart';
import '../utils/terminal_utils.dart';

class StringReplacer {
  StringReplacer({
    final TermUtils? termUtils,
    final IoUtils? ioUtils,
    final PathUtils? pathUtils,
    final CliUtils? cliUtils,
  })  : term = termUtils ?? TermUtils(),
        io = ioUtils ?? IoUtils(),
        path = pathUtils ?? PathUtils(),
        cli = cliUtils ?? CliUtils();

  final TermUtils term;
  final IoUtils io;
  final PathUtils path;
  final CliUtils cli;

  Future<void> updateAppName(String newAppName) async {
    final String newInternalName = internalName(newAppName);
    term.tPrint(FontCodes.green, 'Updating app name to: $newInternalName...');

    final Map<String, String> namesMap = <String, String>{
      'Flutter Starter Kit': newAppName,
      'flutter_starter_kit': newInternalName,
    };

    const List<String> foldersToReplaceName = <String>[
      'lib',
      'test',
      'android',
      'ios',
      'macos',
      'windows',
      'linux',
      'web',
      'integration_test',
      'widgetbook',
    ];

    try {
      final String repositoryRoot = getRepositoryRoot();

      await Future.forEach(
        namesMap.entries,
        (MapEntry<String, String> entry) async {
          final String oldName = entry.key;
          final String newName = entry.value;

          await replaceAllOccurrencesInFolder(
            repositoryRoot,
            oldName,
            newName,
            recursive: false,
          );

          for (final String folder in foldersToReplaceName) {
            final String folderPath = path.join(repositoryRoot, folder);
            await replaceAllOccurrencesInFolder(
              folderPath,
              oldName,
              newName,
            );
          }
        },
      );
      final String commitMessage =
          'Changed app name from Flutter Starter Kit to $newAppName';
      await cli.commitChanges(commitMessage);

      term.tPrint(
        FontCodes.green,
        'App name updated and committed successfully',
      );
    } catch (error) {
      term.tPrint(FontCodes.red, '❌ An error occurred:', bold: true);
      term.tPrint(FontCodes.normal, '$error');
    }
  }

  String internalName(String? initName) {
    String newName = promptForAppName(initName);
    newName = newName.trim().toLowerCase();

    final bool validName = validateInternalName(newName);
    if (!validName) {
      return internalName(null);
    }

    return newName;
  }

  String promptForAppName(String? defaultName) {
    const String appNameRequest = 'Enter your new app name in snake case';

    if (defaultName != null && defaultName.isNotEmpty) {
      final String appNameSnakeCase = toSnakeCase(defaultName);
      return term.tPrintInputWithDefault(appNameRequest, appNameSnakeCase);
    }

    const String exampleAppName = '(e.g. flutter_starter_kit)';
    return term.tPrintInputUntilNotEmpty('$appNameRequest $exampleAppName: ');
  }

  bool validateInternalName(String name) {
    if (name.isEmpty) return false;
    if (name.contains(' ')) return false;
    return true;
  }

  Future<void> replaceAllOccurrencesInFolder(
    String folderPath,
    String oldString,
    String newString, {
    bool recursive = true,
  }) async {
    final Directory folderDirectory = io.directory(folderPath);

    if (!folderDirectory.existsSync()) {
      throw Exception('Folder not found: $folderPath');
    }

    final Stream<FileSystemEntity> entityStream =
        folderDirectory.list(recursive: recursive, followLinks: false);

    final List<FileSystemEntity> entities = await entityStream.toList();

    for (final FileSystemEntity entity in entities) {
      if (entity is Directory) {
        final bool folderRenamed =
            replaceFolderName(entity, oldString, newString);

        if (folderRenamed) {
          await replaceAllOccurrencesInFolder(
            folderPath,
            oldString,
            newString,
            recursive: recursive,
          );
          return;
        }
      }
    }

    for (final FileSystemEntity entity in entities) {
      if (entity is File) {
        replaceStringInFile(entity, oldString, newString);
      }
    }
  }

  List<String> ignoredExtensions = <String>[
    '.png',
    '.ico',
    '.jar',
    '.probe',
    '.bin',
    '.lock',
    '.ds_store',
    '',
    '.swiftsourceinfo',
    '.swiftdoc',
    '.xcuserstate',
    '.md',
  ];

  void replaceStringInFile(File entity, String oldString, String newString) {
    try {
      final String filePath = entity.path;
      final String fileExtension = path.fileExtension(filePath).toLowerCase();

      if (ignoredExtensions.contains(fileExtension)) return;

      final String fileContent = entity.readAsStringSync();

      if (!fileContent.contains(oldString)) return;

      final String newFileContent =
          fileContent.replaceAll(oldString, newString);
      entity.writeAsStringSync(newFileContent);

      term.tPrint(FontCodes.normal, 'Modified: $filePath');
    } catch (e) {
      term.tPrint(
        FontCodes.red,
        'Error processing file ${entity.path}: $e',
      );
    }
  }

  bool replaceFolderName(
    Directory directory,
    String oldString,
    String newString,
  ) {
    final String currentName = path.basename(directory.path);
    if (!currentName.contains(oldString)) return false;
    try {
      if (!directory.existsSync()) {
        throw Exception('Folder not found');
      }

      final String newName = currentName.replaceAll(oldString, newString);
      final String parentPath = path.dirname(directory.path);
      final String newPath = path.join(parentPath, newName);

      io.renameDirSync(directory, newPath);
      term.tPrint(
        FontCodes.normal,
        'Renamed folder: ${directory.path} to $newPath',
      );
      return true;
    } catch (e) {
      term.tPrint(
        FontCodes.red,
        'Error renaming folder ${directory.path}: $e',
      );
      return false;
    }
  }
}
