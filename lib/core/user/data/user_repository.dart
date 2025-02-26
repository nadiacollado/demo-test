import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../logger/logger.dart';
import '../../user/domain/user.dart' as app_user;

part '../../../core/user/data/user_repository.g.dart';

class UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<app_user.User?> getUser() async {
    final String? uid = _auth.currentUser?.uid;
    if (uid == null) return null;

    try {
      final DocumentSnapshot<app_user.User> doc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(uid)
              .withConverter<app_user.User>(
                fromFirestore:
                    (DocumentSnapshot<Map<String, dynamic>> snapshot, _) =>
                        app_user.User.fromJson(snapshot.data()!),
                toFirestore: (app_user.User user, _) => user.toJson(),
              )
              .get();

      return doc.data();
    } catch (e, stackTrace) {
      logger.error(
        message: 'Error retrieving user: $e',
        stack: stackTrace,
      );
    }
    return null;
  }

  Future<void> updateUserProfile(Map<String, dynamic> updates) async {
    final String? uid = _auth.currentUser?.uid;
    if (uid == null || updates.isEmpty) return;

    try {
      await _firestore.collection('users').doc(uid).update(updates);
      logger.info(message: 'User Profile updated successfully');
    } catch (e, stackTrace) {
      logger.error(
        message: 'Error updating user profile: $e',
        stack: stackTrace,
      );
    }
  }
}

@Riverpod(keepAlive: true)
UserRepository userRepository(Ref ref) {
  return UserRepository();
}
