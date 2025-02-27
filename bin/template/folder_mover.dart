import 'dart:io';

import '../utils/path_utils.dart';
import '../utils/terminal_utils.dart';

class FolderMover {
  FolderMover({
    final TermUtils? termUtils,
    final PathUtils? pathUtils,
  })  : term = termUtils ?? TermUtils(),
        path = pathUtils ?? PathUtils();

  final TermUtils term;
  final PathUtils path;

  void move(
    String sourceFolder,
    String destinationFolder, {
    Directory? workingDirectory,
  }) {
    try {
      final Directory currentDir = workingDirectory ??
          Directory(path.dirname(Platform.script.toFilePath()));

      if (!currentDir.existsSync()) {
        throw Exception('Directory not found: ${currentDir.path}');
      }

      final Directory sourceDirectory =
          getDirectory(currentDir, sourceFolder, create: false);
      final Directory destinationDirectory =
          getDirectory(currentDir, destinationFolder);

      moveDirectoryContents(sourceDirectory, destinationDirectory);
      term.tPrint(
        FontCodes.green,
        'Moved directory: $sourceFolder to $destinationFolder',
      );
    } catch (e) {
      term.tPrint(FontCodes.red, 'Error moving file:', bold: true);
      term.tPrint(FontCodes.normal, '$e');
    }
  }

  Directory getDirectory(
    Directory workingDir,
    String folder, {
    bool create = true,
  }) {
    final String folderPath = path.join(workingDir.path, folder);
    final Directory directory = Directory(folderPath);

    if (!directory.existsSync() && create) {
      term.tPrint(
        FontCodes.yellow,
        'Directory not found. Creating: $folderPath',
      );
      directory.createSync(recursive: true);
    }

    if (!directory.existsSync()) {
      throw Exception('Directory not found: $folderPath');
    }

    return directory;
  }

  void moveDirectoryContents(Directory source, Directory destination) {
    final List<FileSystemEntity> contents = source.listSync();

    for (final FileSystemEntity entity in contents) {
      final String sourceEntityPath = entity.path;
      final String destinationEntityPath = path.join(
        destination.path,
        path.basename(sourceEntityPath),
      );

      if (entity is File) {
        final File sourceFile = File(sourceEntityPath);
        sourceFile.renameSync(destinationEntityPath);
        term.tPrint(
          FontCodes.normal,
          'Moved file: $sourceEntityPath to $destinationEntityPath',
        );
      } else if (entity is Directory) {
        final Directory sourceSubDirectory = Directory(sourceEntityPath);
        final Directory destinationSubDirectory =
            Directory(destinationEntityPath);

        if (!destinationSubDirectory.existsSync()) {
          destinationSubDirectory.createSync(recursive: true);
        }
        moveDirectoryContents(sourceSubDirectory, destinationSubDirectory);
      }
    }
  }
}
