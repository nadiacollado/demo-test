import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import '../../../bin/utils/path_utils.dart';

void main() {
  group('PathUtils', () {
    late PathUtils pathUtils;

    setUp(() {
      pathUtils = PathUtils();
    });

    test('join', () {
      expect(pathUtils.join('root', 'path'), p.join('root', 'path'));
      expect(pathUtils.join('root', '/path'), p.join('root', '/path'));
      expect(pathUtils.join('/root', 'path'), p.join('/root', 'path'));
    });

    test('basename', () {
      expect(pathUtils.basename('path/to/file.txt'), 'file.txt');
      expect(pathUtils.basename('file.txt'), 'file.txt');
      expect(pathUtils.basename('/path/to/file.txt'), 'file.txt');
    });

    test('dirname', () {
      expect(pathUtils.dirname('path/to/file.txt'), 'path/to');
      expect(pathUtils.dirname('file.txt'), '.');
      expect(pathUtils.dirname('/path/to/file.txt'), '/path/to');
    });

    test('fileExtension', () {
      expect(pathUtils.fileExtension('path/to/file.txt'), '.txt');
      expect(pathUtils.fileExtension('file.txt'), '.txt');
      expect(pathUtils.fileExtension('/path/to/file.txt'), '.txt');
    });

    test('fileExtension with level', () {
      expect(pathUtils.fileExtension('path/to/file.txt.tmp', 2), '.txt.tmp');
    });

    test('current', () {
      expect(pathUtils.current, p.current);
    });

    test('separator', () {
      expect(pathUtils.separator, p.separator);
    });
  });
}
