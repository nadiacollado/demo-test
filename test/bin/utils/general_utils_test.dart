import 'package:flutter_test/flutter_test.dart';
import '../../../bin/utils/general_utils.dart';

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
}
