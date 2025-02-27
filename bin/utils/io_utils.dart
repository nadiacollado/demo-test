import 'dart:io';
export 'dart:io' show Directory, File, FileSystemEntity;

class IoUtils {
  File file(String path) => File(path);

  Directory directory(String path) => Directory(path);

  Future<String> readAsString(File file) async => file.readAsString();

  Future<void> writeAsString(File file, String contents) async =>
      file.writeAsString(contents);

  void renameSync(File file, String newPath) => file.renameSync(newPath);

  bool existsSync(FileSystemEntity entity) => entity.existsSync();

  Stream<FileSystemEntity> listSync(
    Directory directory, {
    bool recursive = false,
  }) =>
      directory.list(recursive: recursive, followLinks: false);

  Future<void> createSync(
    Directory directory, {
    bool recursive = false,
  }) async =>
      directory.create(recursive: recursive);

  Future<void> deleteSync(FileSystemEntity entity) async => entity.delete();

  Future<void> renameDirSync(Directory directory, String newPath) async =>
      directory.renameSync(newPath);
}
