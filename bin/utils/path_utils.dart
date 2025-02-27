import 'package:path/path.dart' as p;

class PathUtils {
  String join(String root, String path) {
    return p.join(root, path);
  }

  String basename(String path) {
    return p.basename(path);
  }

  String dirname(String path) {
    return p.dirname(path);
  }

  String fileExtension(String path, [int level = 1]) {
    return p.extension(path, level);
  }

  String get current => p.current;
  String get separator => p.separator;
}
