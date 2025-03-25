import './io_utils.dart';
import './path_utils.dart';

String toSnakeCase(String input) {
  return splitByWhiteSpaceAndClean(input).join('_');
}

String toKebabCase(String input) {
  return splitByWhiteSpaceAndClean(input).join('-');
}

List<String> splitByWhiteSpaceAndClean(String input) {
  return input.toLowerCase().trim().split(RegExp(r'\s+'));
}

String getRepositoryRoot({
  final IoUtils? ioUtils,
  final PathUtils? pathUtils,
}) {
  final IoUtils io = ioUtils ?? IoUtils();
  final PathUtils path = pathUtils ?? PathUtils();

  Directory currentDir = io.directory(path.current);

  while (currentDir.path != path.separator) {
    final Directory gitDir = io.directory(path.join(currentDir.path, '.git'));
    if (gitDir.existsSync()) {
      return currentDir.path;
    }
    currentDir = currentDir.parent;
  }

  throw Exception('Could not find git repository root');
}
