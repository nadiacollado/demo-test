// ignore_for_file: prefer_mixin

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_starter_kit/features/authentication/application/auth_state_notifier.dart';
import 'package:flutter_starter_kit/features/authentication/domain/auth_state.dart';
import 'package:flutter_starter_kit/features/authentication/domain/auth_status.dart';
import 'package:flutter_starter_kit/features/navigation/app_router.dart';
import 'package:flutter_starter_kit/features/navigation/presentation/nav_drawer.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

import '../../../utils/localized_pump.dart';

class MockAuthNotifier extends AsyncNotifier<AuthState>
    with Mock
    implements AuthStateNotifier {}

class MockGoRouter extends Mock implements GoRouter {}

void main() {
  group('NavDrawer Widget Tests', () {
    late MockAuthNotifier mockAuthNotifier;
    late MockGoRouter mockGoRouter;

    setUpAll(() async {
      TestWidgetsFlutterBinding.ensureInitialized();
    });

    setUp(() {
      mockAuthNotifier = MockAuthNotifier();
      mockGoRouter = MockGoRouter();
    });

    testWidgets('renders navigation drawer with expected items',
        (WidgetTester tester) async {
      await tester.localizedPump(
        const NavDrawer(),
        useRouter: true,
      );

      // Open the drawer first
      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();

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
      // Add state mock
      when(() => mockAuthNotifier.state).thenReturn(
        const AsyncData(AuthState(status: AuthStatus.authenticated)),
      );
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

    testWidgets('taps home and navigates to home screen',
        (WidgetTester tester) async {
      // ignore: invalid_use_of_visible_for_overriding_member
      // when(() => mockAuthNotifier.build()).thenAnswer(
      //   (_) async => const AuthState(status: AuthStatus.authenticated),
      // );
      // when(() => mockGoRouter.goNamed(AppRoute.profile.name)).thenReturn(null);

      // await tester.localizedPump(
      //   const Scaffold(
      //     drawer: NavDrawer(),
      //   ),
      //   overrides: <Override>[
      //     authStateNotifierProvider.overrideWith(() => mockAuthNotifier),
      //     goRouterProvider.overrideWith((Ref<GoRouter> ref) => mockGoRouter),
      //   ],
      // );

      await tester.localizedPump(
        const NavDrawer(),
        overrides: <Override>[
          authStateNotifierProvider.overrideWith(() => mockAuthNotifier),
          // goRouterProvider.overrideWith((Ref<GoRouter> ref) => mockGoRouter),
        ],
        useRouter: true,
      );

      // await tester.tap(
      //   find.byIcon(Icons.menu),
      // );

      // await tester.tap(
      //   find.byType(NavDrawer),
      // );

      // await tester.tap(
      //   find.byType(Drawer),
      // );
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.home));
      await tester.pumpAndSettle();

      final BuildContext context = tester.element(find.byType(NavDrawer));
      expect(
        GoRouter.of(context).routerDelegate.currentConfiguration.uri.path,
        equals(AppRoute.profile.path),
      );
    });
  });
}
