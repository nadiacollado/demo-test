import 'package:flutter_starter_kit/core/user/domain/user.dart';
import 'package:flutter_starter_kit/features/profile/domain/user_profile_form_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('UserProfileFormState', () {
    test('copyWith() should correctly update fields', () {
      const UserProfileFormState originalState = UserProfileFormState(
        email: 'old@example.com',
        username: 'oldUser',
      );

      final UserProfileFormState updatedState =
          originalState.copyWith(username: 'newUser');

      expect(updatedState.email, 'old@example.com');
      expect(updatedState.username, 'newUser');
    });

    test('getChangedFields() should return only modified fields', () {
      const User originalUser =
          User(email: 'user@example.com', username: 'user123');

      const UserProfileFormState formState = UserProfileFormState(
        email: 'new@example.com',
        username: 'user123',
        originalUser: originalUser,
      );

      final Map<String, dynamic> updates = formState.getChangedFields();

      expect(updates.length, 1);
      expect(
        updates['email'],
        'new@example.com',
      );
      expect(updates.containsKey('username'), false);
    });

    test('getChangedFields() should return empty map when no changes are made',
        () {
      const User originalUser =
          User(email: 'same@example.com', username: 'sameUser');

      const UserProfileFormState formState = UserProfileFormState(
        email: 'same@example.com',
        username: 'sameUser',
        originalUser: originalUser,
      );

      final Map<String, dynamic> updates = formState.getChangedFields();

      expect(updates.isEmpty, true);
    });
  });
}
