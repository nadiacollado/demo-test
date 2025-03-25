import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:path/path.dart' as p;

import '../../../bin/template/string_replacer.dart';
import '../../../bin/utils/cli_utils.dart';
import '../../../bin/utils/io_utils.dart';
import '../../../bin/utils/path_utils.dart';
import '../../../bin/utils/terminal_utils.dart';

class MockTermUtils extends Mock implements TermUtils {}

class MockFileUtils extends Mock implements IoUtils {}

class MockPathUtils extends Mock implements PathUtils {}

class MockCliUtils extends Mock implements CliUtils {}

class MockFile extends Mock implements File {}

void main() {
  group('StringReplacer', () {
    late StringReplacer replacer;
    late MockTermUtils term;
    late MockFileUtils io;
    late MockPathUtils path;
    late MockCliUtils cli;
    late Directory tempDir;

    const String oldStr = 'old';
    const String newStr = 'new';
    const String strToFix = 'test old test';
    const String fixedStr = 'test new test';
    const String modifiedStr = 'Modified:';
    const String file1Name = 'file1.txt';
    const String file2Name = 'file2.dart';
    const String subDirName = 'subDir';

    final String file1Ext = p.extension(file1Name);
    final String file2Ext = p.extension(file2Name);

    setUp(() {
      term = MockTermUtils();
      io = MockFileUtils();
      path = MockPathUtils();
      cli = MockCliUtils();
      replacer = StringReplacer(
        termUtils: term,
        ioUtils: io,
        pathUtils: path,
        cliUtils: cli,
      );
      tempDir = Directory.systemTemp.createTempSync();

      registerFallbackValue(FontCodes.normal);
      registerFallbackValue(File(''));
      registerFallbackValue(Directory(''));
    });

    tearDown(() {
      if (tempDir.existsSync()) {
        tempDir.deleteSync(recursive: true);
      }
    });

    test('internalName prompts for app name and validates', () {
      const String testAppName = 'test_app';

      when(() => term.tPrintInputUntilNotEmpty(any())).thenReturn(testAppName);
      when(() => term.tPrintInputWithDefault(any(), any()))
          .thenReturn(testAppName);

      final String name = replacer.internalName(null);
      expect(name, testAppName);

      final String name2 = replacer.internalName('Default App');
      expect(name2, testAppName);
    });

    test('validateInternalName checks for empty or space containing names', () {
      expect(replacer.validateInternalName(''), false);
      expect(replacer.validateInternalName('Name With Spaces'), false);
      expect(replacer.validateInternalName('Name_Without_Spaces'), true);
    });

    test(
        'replaceAllOccurrencesInFolder throws exception if folder does not exist',
        () async {
      const String missingDirStr = 'nonexistent';
      when(() => io.directory(any())).thenReturn(Directory(missingDirStr));
      await expectLater(
        replacer.replaceAllOccurrencesInFolder(missingDirStr, oldStr, newStr),
        throwsA(isA<Exception>()),
      );
    });

    test(
        'replaceAllOccurrencesInFolder replaces strings in files, including subfolders',
        () async {
      final File file1 = File(p.join(tempDir.path, file1Name));
      file1.createSync(recursive: true);
      file1.writeAsStringSync(strToFix);

      final Directory subDir = Directory(p.join(tempDir.path, subDirName));
      subDir.createSync(recursive: true);
      final File file2 = File(p.join(subDir.path, file2Name));
      file2.createSync(recursive: true);
      file2.writeAsStringSync(strToFix);

      when(() => io.directory(tempDir.path)).thenReturn(tempDir);
      when(() => path.basename(subDir.path)).thenReturn(subDirName);
      when(() => path.fileExtension(file1.path)).thenReturn(file1Ext);
      when(() => io.file(file1.path)).thenReturn(file1);
      when(() => path.fileExtension(file2.path)).thenReturn(file2Ext);
      when(() => io.file(file2.path)).thenReturn(file2);

      await replacer.replaceAllOccurrencesInFolder(
        tempDir.path,
        oldStr,
        newStr,
      );

      expect(file1.readAsStringSync(), fixedStr);
      expect(file2.readAsStringSync(), fixedStr);
    });

    test('replaceStringInFile handles file processing errors', () async {
      const String fileName = 'test_file.dart';
      const String errorMessage = 'Read error';
      final File testFile = MockFile();

      when(() => testFile.path).thenReturn(fileName);
      when(() => path.fileExtension(fileName))
          .thenReturn(p.extension(fileName));
      when(() => testFile.readAsStringSync())
          .thenThrow(Exception(errorMessage));
      when(() => testFile.path).thenReturn(fileName);
      when(() => term.tPrint(any(), any())).thenReturn(null);

      replacer.replaceStringInFile(testFile, oldStr, newStr);

      verify(
        () => term.tPrint(
          FontCodes.red,
          'Error processing file $fileName: Exception: $errorMessage',
        ),
      ).called(1);
    });

    test('replaceStringInFile skips files that do not contain the string',
        () async {
      final File file1 = File(p.join(tempDir.path, file1Name));
      file1.createSync(recursive: true);
      file1.writeAsStringSync(strToFix);

      final File file2 = File(p.join(tempDir.path, file2Name));
      file2.createSync(recursive: true);
      file2.writeAsStringSync('does not contain string');

      when(() => path.fileExtension(file1.path)).thenReturn(file1Ext);
      when(() => io.file(file1.path)).thenReturn(file1);
      when(() => path.fileExtension(file2.path)).thenReturn(file2Ext);
      when(() => io.file(file2.path)).thenReturn(file2);

      void runTest(File file) =>
          replacer.replaceStringInFile(file, oldStr, newStr);
      runTest(file1);
      runTest(file2);

      expect(file1.readAsStringSync(), fixedStr);
      expect(file2.readAsStringSync(), 'does not contain string');

      verify(() => term.tPrint(FontCodes.normal, '$modifiedStr ${file1.path}'))
          .called(1);
      verifyNever(
        () => term.tPrint(FontCodes.normal, '$modifiedStr ${file2.path}'),
      );
    });

    test(
        'replaceAllOccurrencesInFolder skips subdirectories if recursive is false',
        () async {
      final File file1 = File(p.join(tempDir.path, file1Name));
      file1.createSync(recursive: true);
      file1.writeAsStringSync(strToFix);

      final Directory subDir = Directory(p.join(tempDir.path, subDirName));
      subDir.createSync(recursive: true);
      final File file2 = File(p.join(subDir.path, file2Name));
      file2.createSync(recursive: true);
      file2.writeAsStringSync(strToFix);

      when(() => io.directory(tempDir.path)).thenReturn(tempDir);
      when(() => path.basename(subDir.path)).thenReturn(subDirName);
      when(() => path.fileExtension(file1.path)).thenReturn(file1Ext);
      when(() => io.file(file1.path)).thenReturn(file1);
      when(() => path.fileExtension(file2.path)).thenReturn(file2Ext);
      when(() => io.file(file2.path)).thenReturn(file2);

      await replacer.replaceAllOccurrencesInFolder(
        tempDir.path,
        oldStr,
        newStr,
        recursive: false,
      );

      expect(file1.readAsStringSync(), fixedStr);
      expect(file2.readAsStringSync(), strToFix);

      verify(() => term.tPrint(FontCodes.normal, '$modifiedStr ${file1.path}'))
          .called(1);
      verifyNever(
        () => term.tPrint(FontCodes.normal, '$modifiedStr ${file2.path}'),
      );
    });

    test('replaceStringInFile skips files with an ignored file extension',
        () async {
      final File file1 = File(p.join(tempDir.path, 'file1.png'));
      file1.createSync(recursive: true);
      file1.writeAsStringSync(strToFix);

      final File file2 = File(p.join(tempDir.path, 'file2.ico'));
      file2.createSync(recursive: true);
      file2.writeAsStringSync(strToFix);

      when(() => io.file(file1.path)).thenReturn(file1);
      when(() => path.fileExtension(file1.path)).thenReturn('.png');
      when(() => io.file(file2.path)).thenReturn(file2);
      when(() => path.fileExtension(file2.path)).thenReturn('.ico');

      replacer.replaceStringInFile(file1, oldStr, newStr);
      replacer.replaceStringInFile(file2, oldStr, newStr);

      expect(file1.readAsStringSync(), strToFix);
      expect(file2.readAsStringSync(), strToFix);
    });

    group('replaceFolderName', () {
      late StringReplacer workingIoReplacer;

      const String newDirName = 'NewDir';
      const String oldDirName = 'OldDir';

      setUp(() {
        workingIoReplacer = StringReplacer(
          termUtils: term,
          pathUtils: path,
        );
      });

      test('renames folder with matching name', () async {
        final Directory folderToRename =
            await Directory('${tempDir.path}/$oldDirName').create();
        final String parentPath = p.dirname(folderToRename.path);

        when(() => path.basename(folderToRename.path)).thenReturn(oldDirName);
        when(() => path.dirname(folderToRename.path)).thenReturn(parentPath);
        when(() => path.join(parentPath, newDirName))
            .thenReturn(p.join(parentPath, newDirName));

        workingIoReplacer.replaceFolderName(
          folderToRename,
          oldDirName,
          newDirName,
        );

        expect(folderToRename.existsSync(), isFalse);
        expect(Directory('${tempDir.path}/$newDirName').existsSync(), isTrue);
      });

      test('does not rename folder with non-matching name', () async {
        final Directory folderToRename =
            await Directory('${tempDir.path}/$oldDirName').create();

        when(() => path.basename(folderToRename.path)).thenReturn(oldDirName);

        replacer.replaceFolderName(folderToRename, 'non_matching', newStr);

        expect(folderToRename.existsSync(), isTrue);
        expect(Directory('${tempDir.path}/$newDirName').existsSync(), isFalse);
      });

      test('handles folder rename failure', () async {
        const String errorMessage = 'Mocked rename error';

        final Directory folderToRename =
            await Directory('${tempDir.path}/$oldDirName').create();
        final String parentPath = p.dirname(folderToRename.path);

        when(() => path.basename(folderToRename.path)).thenReturn(oldDirName);
        when(() => path.dirname(folderToRename.path)).thenReturn(parentPath);
        when(() => path.join(parentPath, newDirName))
            .thenReturn(p.join(parentPath, newDirName));
        when(() => io.renameDirSync(folderToRename, any()))
            .thenThrow(Exception(errorMessage));

        replacer.replaceFolderName(folderToRename, oldDirName, newDirName);

        verify(
          () => term.tPrint(
            FontCodes.red,
            'Error renaming folder ${folderToRename.path}: Exception: $errorMessage',
          ),
        );
      });

      test('handles non-existent folder', () async {
        const String nonExistent = 'nonExistent';
        const String nonExistentOldDirName = '$nonExistent $oldDirName';
        const String nonExistentNewDirName = '$nonExistent $newDirName';

        final Directory nonExistentDir =
            Directory(p.join(tempDir.path, nonExistentOldDirName));

        when(() => path.basename(nonExistentDir.path))
            .thenReturn(nonExistentOldDirName);
        when(() => path.dirname(nonExistentDir.path)).thenReturn(tempDir.path);
        when(() => path.join(tempDir.path, nonExistentNewDirName))
            .thenReturn(p.join(tempDir.path, nonExistentNewDirName));

        workingIoReplacer.replaceFolderName(
          nonExistentDir,
          oldDirName,
          newDirName,
        );

        verify(
          () => term.tPrint(
            FontCodes.red,
            'Error renaming folder ${nonExistentDir.path}: Exception: Folder not found',
          ),
        ).called(1);
      });
    });
  });
}
