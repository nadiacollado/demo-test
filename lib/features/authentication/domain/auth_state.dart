import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'auth_status.dart';

class AuthState extends Equatable {
  const AuthState({required this.status, this.user});

  final AuthStatus status;
  final User? user;

  AuthState copyWith({required AuthStatus status, User? user}) {
    return AuthState(status: status, user: user);
  }

  @override
  List<Object?> get props => <Object?>[status, user];
}
