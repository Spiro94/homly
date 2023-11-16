import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homly/config/providers.dart';
import 'package:homly/features/auth/domain/entities/user_data.dart';
import 'package:homly/features/common/domain/failures/failure.dart';

class UserRepository {
  const UserRepository(this._firestore);

  final FirebaseFirestore _firestore;

  Future<Either<Failure, UserData?>> getUserData(String email) async {
    try {
      final snapshot = await _firestore.collection('users').doc(email).get();
      if (snapshot.data() != null) {
        return right(UserData.fromJson(snapshot.data()!));
      } else {
        return left(const Failure.server(message: 'User not found'));
      }
    } catch (e) {
      return left(Failure.server(message: e.toString()));
    }
  }

  Future<Either<Failure, UserData>> createUserData(UserData userData) async {
    try {
      await _firestore
          .collection('users')
          .doc(userData.email)
          .set(userData.toJson());
      return right(userData);
    } catch (e) {
      return left(Failure.server(message: e.toString()));
    }
  }
}

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository(ref.watch(firestoreProvider));
});
