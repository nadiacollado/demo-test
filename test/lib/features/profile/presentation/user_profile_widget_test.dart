import 'package:flutter/material.dart';
import 'package:flutter_starter_kit/features/profile/presentation/user_profile_widget.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../utils/localized_pump.dart';

void main() {
  group('UserProfileWidget', () {
    const String testUser = 'testuser@example.com';
    const String testUsername = 'Test User';

    Future<Widget> createWidgetUnderTest(WidgetTester tester) async {
      await tester.localizedPump(
        const UserProfileWidget(
          username: testUsername,
          email: testUser,
        ),
      );
      return tester.firstWidget(find.byType(UserProfileWidget));
    }

    testWidgets('renders email greeting when no username is provided',
        (WidgetTester tester) async {
      await tester.localizedPump(
        const UserProfileWidget(
          email: testUser,
        ),
      );

      expect(find.textContaining(testUser), findsOneWidget);
    });

    testWidgets('renders username when provided', (WidgetTester tester) async {
      await createWidgetUnderTest(tester);

      expect(find.text(testUsername), findsOneWidget);
    });
  });
}
