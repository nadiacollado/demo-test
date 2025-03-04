import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_starter_kit/features/authentication/data/firebase_auth_repository.dart';
import 'package:flutter_starter_kit/features/authentication/domain/auth_status.dart';
import 'package:flutter_starter_kit/features/authentication/presentation/email_verification/email_verification_screen_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late ProviderContainer container;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    container = ProviderContainer(
      overrides: <Override>[
        authRepositoryProvider.overrideWithValue(mockAuthRepository),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  test('sendVerificationEmailAddress returns success status', () async {
    when(() => mockAuthRepository.sendVerificationEmail())
        .thenAnswer((_) async => AuthStatus.successful);

    final EmailVerificationScreenController controller =
        container.read(emailVerificationScreenControllerProvider.notifier);
    final AsyncValue<AuthStatus> result =
        await controller.sendVerificationEmailAddress();

    expect(result, const AsyncValue<AuthStatus>.data(AuthStatus.successful));
    verify(() => mockAuthRepository.sendVerificationEmail()).called(1);
  });

  test(
      'sendVerificationEmailAddress returns error message when given too many requests',
      () async {
    when(() => mockAuthRepository.sendVerificationEmail())
        .thenAnswer((_) async => AuthStatus.tooManyRequests);

    final EmailVerificationScreenController controller =
        container.read(emailVerificationScreenControllerProvider.notifier);
    final AsyncValue<AuthStatus> result =
        await controller.sendVerificationEmailAddress();

    expect(
      result,
      const AsyncValue<AuthStatus>.data(
        AuthStatus.tooManyRequests,
      ),
    );
    verify(() => mockAuthRepository.sendVerificationEmail()).called(1);
  });

  test('sendVerificationEmailAddress returns unknown status on error',
      () async {
    when(() => mockAuthRepository.sendVerificationEmail())
        .thenThrow(Exception('Failed to send email'));

    final EmailVerificationScreenController controller =
        container.read(emailVerificationScreenControllerProvider.notifier);
    final AsyncValue<AuthStatus> result =
        await controller.sendVerificationEmailAddress();

    expect(result, const AsyncValue<AuthStatus>.data(AuthStatus.unknown));
    verify(() => mockAuthRepository.sendVerificationEmail()).called(1);
  });
}
