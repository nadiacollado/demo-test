// ignore_for_file: prefer_mixin

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_starter_kit/features/authentication/application/auth_state_notifier.dart';
import 'package:flutter_starter_kit/features/authentication/domain/auth_state.dart';
import 'package:flutter_starter_kit/features/navigation/presentation/nav_drawer.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../utils/localized_pump.dart';

class MockAuthNotifier extends AsyncNotifier<AuthState>
    with Mock
    implements AuthStateNotifier {}

void main() {
  group('NavDrawer Widget Tests', () {
    late MockAuthNotifier mockAuthNotifier;

    setUpAll(() async {
      TestWidgetsFlutterBinding.ensureInitialized();
    });

    setUp(() {
      mockAuthNotifier = MockAuthNotifier();
    });

    testWidgets('renders navigation drawer with expected items',
        (WidgetTester tester) async {
      await tester.localizedPump(
        const NavDrawer(),
        overrides: <Override>[
          authStateNotifierProvider.overrideWith(() => mockAuthNotifier),
        ],
      );

      expect(
        find.textContaining(tester.t.nav_home.toUpperCase()),
        findsOneWidget,
      );
      expect(
        find.textContaining(tester.t.nav_editProfile.toUpperCase()),
        findsOneWidget,
      );
      expect(
        find.textContaining(tester.t.nav_logout.toUpperCase()),
        findsOneWidget,
      );
    });

    testWidgets('taps logout and calls signOut', (WidgetTester tester) async {
      when(() => mockAuthNotifier.signOut()).thenAnswer((_) async {});
      await tester.localizedPump(
        const NavDrawer(),
        overrides: <Override>[
          authStateNotifierProvider.overrideWith(() => mockAuthNotifier),
        ],
      );

      await tester.tap(find.textContaining(tester.t.nav_logout.toUpperCase()));
      await tester.pumpAndSettle();

      verify(() => mockAuthNotifier.signOut()).called(1);
    });
  });
}
