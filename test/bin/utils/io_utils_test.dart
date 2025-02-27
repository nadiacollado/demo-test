import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

import '../../../bin/utils/io_utils.dart';

void main() {
  group('IoUtils', () {
    late IoUtils ioUtils;
    late Directory tempDir;

    const String helloWorld = 'Hello, world!';
    const String txtFileName = 'test.txt';
    const String dirToRenameStr = '/dir_to_rename';
    const String renamedDirStr = '/renamed_dir';

    setUp(() {
      ioUtils = IoUtils();
      tempDir = Directory.systemTemp.createTempSync();
    });

    tearDown(() {
      if (tempDir.existsSync()) {
        tempDir.deleteSync(recursive: true);
      }
    });

    test('file returns a File object', () {
      const String path = 'path/to/file.txt';
      final File file = ioUtils.file(path);
      expect(file.path, path);
    });

    test('directory returns a Directory object', () {
      const String path = 'path/to/directory';
      final Directory directory = ioUtils.directory(path);
      expect(directory.path, path);
    });

    test('readAsString reads the contents of a file', () async {
      final File file = File(p.join(tempDir.path, txtFileName));
      await file.create(recursive: true);
      await file.writeAsString(helloWorld);
      final String contents = await ioUtils.readAsString(file);
      expect(contents, helloWorld);
    });

    test('writeAsString writes to a file', () async {
      final File file = File(p.join(tempDir.path, txtFileName));
      await file.create(recursive: true);
      await ioUtils.writeAsString(file, helloWorld);
      final String contents = await file.readAsString();
      expect(contents, helloWorld);
    });

    test('renameSync renames a file', () {
      final File file = File(p.join(tempDir.path, txtFileName));
      file.createSync();

      expect(file.existsSync(), true);

      final File newFile = File(p.join(tempDir.path, 'new_test.txt'));
      ioUtils.renameSync(file, newFile.path);

      expect(file.existsSync(), false);
      expect(newFile.existsSync(), true);
    });

    test('existsSync checks if a file exists', () {
      final File file = File(p.join(tempDir.path, txtFileName));
      expect(ioUtils.existsSync(file), false);
      file.createSync();
      expect(ioUtils.existsSync(file), true);
    });

    test('listSync lists the contents of a directory', () async {
      final Directory directory = Directory(p.join(tempDir.path, 'test'));
      await directory.create(recursive: true);
      final File file1 = File(p.join(directory.path, 'test1.txt'));
      await file1.create(recursive: true);
      final File file2 = File(p.join(directory.path, 'test2.txt'));
      await file2.create(recursive: true);
      final Stream<FileSystemEntity> contentsStream =
          ioUtils.listSync(directory);

      await for (final FileSystemEntity entity in contentsStream) {
        expect(entity.path, p.join(directory.path, p.basename(entity.path)));
      }
    });

    test('createSync creates a directory', () async {
      final Directory directory = Directory(p.join(tempDir.path, 'test'));
      await ioUtils.createSync(directory);
      expect(directory.existsSync(), true);
    });

    test('deleteSync deletes a file', () async {
      final File file = File(p.join(tempDir.path, txtFileName));
      await file.create(recursive: true);
      expect(file.existsSync(), true);
      await ioUtils.deleteSync(file);
      expect(file.existsSync(), false);
    });

    test('renameDirSync renames a directory', () async {
      final Directory dirToRename = Directory('${tempDir.path}$dirToRenameStr');
      dirToRename.createSync(recursive: true);

      await ioUtils.renameDirSync(dirToRename, '${tempDir.path}$renamedDirStr');

      expect(Directory('${tempDir.path}$renamedDirStr').existsSync(), isTrue);
      expect(dirToRename.existsSync(), isFalse);
    });

    test('renameDirSync renames a directory without disrupting its contents',
        () async {
      const String fileName = 'test.txt';
      const String subFolderName = 'subfolder';

      final Directory dirToRename = Directory('${tempDir.path}$dirToRenameStr');
      dirToRename.createSync(recursive: true);
      final Directory subFolderInDirToRename =
          Directory(p.join(dirToRename.path, subFolderName));
      subFolderInDirToRename.createSync(recursive: true);
      final File fileInRenamedDirSubFolder =
          File(p.join(subFolderInDirToRename.path, fileName));
      await fileInRenamedDirSubFolder.create(recursive: true);

      expect(fileInRenamedDirSubFolder.existsSync(), isTrue);

      await ioUtils.renameDirSync(dirToRename, '${tempDir.path}$renamedDirStr');

      final Directory renamedDirectory =
          Directory('${tempDir.path}$renamedDirStr');
      expect(renamedDirectory.existsSync(), isTrue);
      expect(dirToRename.existsSync(), isFalse);

      final Directory subFolderAfterRename =
          Directory(p.join(renamedDirectory.path, subFolderName));
      expect(subFolderAfterRename.existsSync(), isTrue);

      final File fileAfterRename =
          File(p.join(subFolderAfterRename.path, fileName));
      expect(fileAfterRename.existsSync(), isTrue);
    });
  });
}
