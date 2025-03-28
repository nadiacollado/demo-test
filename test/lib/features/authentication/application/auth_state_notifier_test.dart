import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:demo_test/features/authentication/application/auth_state_notifier.dart';
import 'package:demo_test/features/authentication/data/firebase_auth_repository.dart';
import 'package:demo_test/features/authentication/domain/auth_state.dart';
import 'package:demo_test/features/authentication/domain/auth_status.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockUser extends Mock implements User {}

void main() {
  late AuthStateNotifier authStateNotifier;
  late MockAuthRepository mockAuthRepository;
  late ProviderContainer container;
  late MockUser mockUser;

  ProviderContainer createContainer(MockAuthRepository authRepository) {
    return ProviderContainer(
      overrides: <Override>[
        authRepositoryProvider.overrideWithValue(authRepository),
      ],
    );
  }

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    container = createContainer(mockAuthRepository);
    when(() => mockAuthRepository.authStateChanges())
        .thenAnswer((_) => const Stream<User?>.empty());

    authStateNotifier = container.read(authStateNotifierProvider.notifier);
  });

  tearDown(() {
    container.dispose();
  });

  test('initial state is loading', () async {
    expect(
      authStateNotifier.state,
      const AsyncData<AuthState>(AuthState(status: AuthStatus.isLoading)),
    );
  });

  test('signInWithEmailPassword sets state to authenticated on success',
      () async {
    when(() => mockAuthRepository.signInWithEmailPassword(any(), any()))
        .thenAnswer((_) async => AuthStatus.authenticated);

    await authStateNotifier.signInWithEmailPassword(
      'test@example.com',
      'password',
    );

    expect(
      authStateNotifier.state,
      equals(
        const AsyncData<AuthState>(
          AuthState(status: AuthStatus.authenticated),
        ),
      ),
    );
  });

  test('signInWithEmailPassword sets state to error on failure', () async {
    final Exception exception = Exception('Sign in failed');
    when(() => mockAuthRepository.signInWithEmailPassword(any(), any()))
        .thenThrow(exception);

    await authStateNotifier.signInWithEmailPassword(
      'test@example.com',
      'password',
    );

    expect(authStateNotifier.state, isA<AsyncError<AuthState>>());
  });

  test('signOut sets state to unauthenticated', () async {
    when(() => mockAuthRepository.signOut()).thenAnswer((_) async {});

    await authStateNotifier.signOut();

    expect(
      authStateNotifier.state,
      equals(
        const AsyncValue<AuthState>.data(
          AuthState(status: AuthStatus.unauthenticated),
        ),
      ),
    );
  });
  test('sendVerificationEmail sends email if user is not verified', () async {
    mockAuthRepository = MockAuthRepository();
    mockUser = MockUser();
    container = createContainer(mockAuthRepository);

    when(() => mockAuthRepository.authStateChanges())
        .thenAnswer((_) => const Stream<User?>.empty());
    when(() => mockAuthRepository.currentUser).thenReturn(mockUser);
    when(() => mockUser.emailVerified).thenReturn(false);
    when(() => mockUser.sendEmailVerification()).thenAnswer((_) async {});

    authStateNotifier = container.read(authStateNotifierProvider.notifier);
    await container.read(authStateNotifierProvider.future);

    await authStateNotifier.sendVerificationEmail();

    verify(() => mockUser.sendEmailVerification()).called(1);
    container.dispose();
  });

  test('sendVerificationEmail does nothing if user is verified', () async {
    mockAuthRepository = MockAuthRepository();
    mockUser = MockUser();
    container = createContainer(mockAuthRepository);

    when(() => mockAuthRepository.authStateChanges())
        .thenAnswer((_) => const Stream<User?>.empty());
    when(() => mockAuthRepository.currentUser).thenReturn(mockUser);
    when(() => mockUser.emailVerified).thenReturn(true);

    authStateNotifier = container.read(authStateNotifierProvider.notifier);

    await authStateNotifier.sendVerificationEmail();

    verifyNever(() => mockUser.sendEmailVerification());
    container.dispose();
  });
}
