import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:path/path.dart' as p;

import '../../../bin/template/folder_mover.dart';
import '../../../bin/utils/path_utils.dart';
import '../../../bin/utils/terminal_utils.dart';

class MockTermUtils extends Mock implements TermUtils {}

class MockPathUtils extends Mock implements PathUtils {}

void main() {
  group('FolderMover', () {
    late FolderMover folderMover;
    late MockTermUtils term;
    late MockPathUtils pathUtils;
    late Directory sourceDir;
    late Directory destDir;

    const String fileName = 'file.txt';

    setUp(() {
      term = MockTermUtils();
      pathUtils = MockPathUtils();
      folderMover = FolderMover(termUtils: term, pathUtils: pathUtils);

      sourceDir = Directory.systemTemp.createTempSync();
      destDir = Directory.systemTemp.createTempSync();

      registerFallbackValue(FontCodes.normal);
    });

    tearDown(() {
      if (sourceDir.existsSync()) {
        sourceDir.deleteSync(recursive: true);
      }
      if (destDir.existsSync()) {
        destDir.deleteSync(recursive: true);
      }
    });

    test('moveDirectoryContents moves files and directories', () async {
      const String subDirStr = 'subdir';

      final File file = File(p.join(sourceDir.path, fileName));
      final Directory subdir = Directory(p.join(sourceDir.path, subDirStr));

      file.writeAsStringSync('Hello, world!');
      subdir.createSync(recursive: true);

      when(() => pathUtils.basename(file.path)).thenReturn(fileName);
      when(() => pathUtils.basename(subdir.path)).thenReturn(subDirStr);
      when(() => pathUtils.join(destDir.path, fileName))
          .thenReturn(File(p.join(destDir.path, fileName)).path);
      when(() => pathUtils.join(destDir.path, subDirStr))
          .thenReturn(Directory(p.join(destDir.path, subDirStr)).path);

      folderMover.moveDirectoryContents(sourceDir, destDir);

      expect(File(p.join(destDir.path, fileName)).existsSync(), isTrue);
      expect(Directory(p.join(destDir.path, subDirStr)).existsSync(), isTrue);
    });

    test('getDirectory creates directory if it does not exist', () async {
      final String dirPath = p.join(sourceDir.path, 'nonexistent');

      when(() => pathUtils.join(sourceDir.path, dirPath)).thenReturn(dirPath);

      final Directory dir = folderMover.getDirectory(sourceDir, dirPath);

      expect(dir.existsSync(), isTrue);
    });

    test('move moves directory contents and prints success message', () async {
      when(() => pathUtils.join(p.current, sourceDir.path))
          .thenReturn(sourceDir.path);
      when(() => pathUtils.join(p.current, destDir.path))
          .thenReturn(destDir.path);

      when(() => pathUtils.basename(any())).thenReturn(fileName);
      when(() => pathUtils.join(destDir.path, any()))
          .thenReturn(p.join(destDir.path, fileName));

      when(() => term.tPrint(FontCodes.green, any())).thenReturn(null);

      folderMover.move(
        sourceDir.path,
        destDir.path,
        workingDirectory: Directory(p.current),
      );

      verify(() => term.tPrint(FontCodes.green, any())).called(1);
    });

    test('move prints error message if directory move fails', () async {
      const String missingDirPath = '/nonexistent';

      when(() => pathUtils.current).thenReturn(Directory.current.path);
      when(() => pathUtils.join(any(), missingDirPath))
          .thenReturn(missingDirPath);
      when(() => term.tPrint(any(), any())).thenReturn(null);

      folderMover.move(missingDirPath, destDir.path);

      verify(() => term.tPrint(FontCodes.red, any(), bold: true)).called(1);
    });
  });
}
