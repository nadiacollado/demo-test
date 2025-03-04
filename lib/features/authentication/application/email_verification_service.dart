import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'email_verification_service.g.dart';

class EmailVerificationService {
  Future<bool> isEmailVerified(User? user) async {
    if (user == null) return false;

    await user.reload();
    if (!user.emailVerified) {
      return false;
    }

    return true;
  }
}

@Riverpod(keepAlive: true)
EmailVerificationService emailVerificationService(Ref ref) =>
    EmailVerificationService();
