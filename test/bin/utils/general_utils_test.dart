import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:path/path.dart' as p;

import '../../../bin/utils/general_utils.dart';
import '../../../bin/utils/io_utils.dart';
import '../../../bin/utils/path_utils.dart';

// Mock classes for IoUtils and PathUtils
class MockIoUtils extends Mock implements IoUtils {}

class MockPathUtils extends Mock implements PathUtils {}

void main() {
  group('toSnakeCase', () {
    const String validHelloWorld = 'hello_world';

    test('converts a sentence to snake case', () {
      expect(toSnakeCase('Hello World'), validHelloWorld);
    });

    test('converts a single word to lowercase', () {
      expect(toSnakeCase('Hello'), 'hello');
    });

    test('handles multiple spaces between words', () {
      expect(toSnakeCase('Hello   World'), validHelloWorld);
    });

    test('handles leading and trailing spaces', () {
      expect(toSnakeCase('   Hello World   '), validHelloWorld);
    });

    test('handles empty string', () {
      expect(toSnakeCase(''), '');
    });
  });

  group('toKebabCase', () {
    const String validHelloWorld = 'hello-world';

    test('converts a sentence to snake case', () {
      expect(toKebabCase('Hello World'), validHelloWorld);
    });

    test('converts a single word to lowercase', () {
      expect(toKebabCase('Hello'), 'hello');
    });

    test('handles multiple spaces between words', () {
      expect(toKebabCase('Hello   World'), validHelloWorld);
    });

    test('handles leading and trailing spaces', () {
      expect(toKebabCase('   Hello World   '), validHelloWorld);
    });

    test('handles empty string', () {
      expect(toKebabCase(''), '');
    });
  });

  group('splitByWhiteSpaceAndClean', () {
    const List<String> validHelloWorld = <String>['hello', 'world'];
    test('splits and cleans a sentence', () {
      expect(splitByWhiteSpaceAndClean('Hello World'), validHelloWorld);
    });

    test('handles multiple spaces', () {
      expect(splitByWhiteSpaceAndClean('Hello   World'), validHelloWorld);
    });

    test('handles leading and trailing spaces', () {
      expect(splitByWhiteSpaceAndClean('   Hello World   '), validHelloWorld);
    });

    test('handles empty string', () {
      expect(splitByWhiteSpaceAndClean(''), <String>['']);
    });

    test('handles single word', () {
      expect(splitByWhiteSpaceAndClean('Hello'), <String>['hello']);
    });
  });

  group('getRepositoryRoot', () {
    late IoUtils io;
    late PathUtils path;
    late Directory tempDir;

    setUp(() {
      io = MockIoUtils();
      path = MockPathUtils();
      tempDir = Directory.systemTemp.createTempSync();
    });

    String runGetRepositoryRoot() {
      return getRepositoryRoot(
        ioUtils: io,
        pathUtils: path,
      );
    }

    test('getRepositoryRoot finds the git repository root', () {
      final Directory gitDir = Directory(p.join(tempDir.path, '.git'));
      gitDir.createSync();

      when(() => path.current).thenReturn(tempDir.path);
      when(() => io.directory(tempDir.path)).thenReturn(tempDir);
      when(() => path.separator).thenReturn('/');
      when(() => path.join(tempDir.path, '.git')).thenReturn(gitDir.path);
      when(() => io.directory(gitDir.path)).thenReturn(gitDir);

      final String root = runGetRepositoryRoot();
      expect(root, tempDir.path);
    });

    test(
        'getRepositoryRoot throws exception if git repository root is not found',
        () {
      const String dirStr = '/';

      when(() => path.current).thenReturn(dirStr);
      when(() => io.directory(any())).thenReturn(Directory(dirStr));
      when(() => path.separator).thenReturn(dirStr);

      expect(() => runGetRepositoryRoot(), throwsA(isA<Exception>()));
    });
  });
}
