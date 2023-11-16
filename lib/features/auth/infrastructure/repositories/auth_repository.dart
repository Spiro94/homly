import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homly/config/providers.dart';
import 'package:homly/features/auth/domain/entities/user_data.dart';
import 'package:homly/features/auth/infrastructure/repositories/user_repository.dart';
import 'package:homly/features/common/domain/failures/failure.dart';

class AuthRepository {
  AuthRepository(
    this._firebaseAuth,
    this._userRepository,
  );

  final FirebaseAuth _firebaseAuth;
  final UserRepository _userRepository;

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();
  Stream<User?> get userChanges => _firebaseAuth.userChanges();

  Future<Either<Failure, UserData>> loginWithEmail(
    String email,
    String password,
  ) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      final userResult = await _userRepository.getUserData(email);

      return await userResult.fold(
        (l) => left(l),
        (r) {
          if (r != null) {
            return right(r);
          } else {
            return left(const Failure.server(message: 'User not found'));
          }
        },
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return left(
          const Failure.server(message: 'No user found for that email.'),
        );
      } else if (e.code == 'wrong-password') {
        return left(
          const Failure.server(
              message: 'Wrong password provided for that user.'),
        );
      } else {
        return left(
          Failure.server(message: e.code),
        );
      }
    } catch (e) {
      return left(Failure.server(message: e.toString()));
    }
  }

  Future<Either<Failure, UserData>> registerUser(
    String email,
    String password,
    UserData userData,
  ) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      final userResult = await _userRepository.createUserData(userData);
      return await userResult.fold(
        (l) => left(l),
        (r) => right(r),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return left(
          const Failure.server(message: 'The password provided is too weak.'),
        );
      } else if (e.code == 'email-already-in-use') {
        return left(
          const Failure.server(
              message: 'The account already exists for that email.'),
        );
      } else {
        return left(
          Failure.server(message: e.code),
        );
      }
    } catch (e) {
      return left(Failure.server(message: e.toString()));
    }
  }

  Future<void> sendEmailVerification() async {
    await _firebaseAuth.currentUser!.sendEmailVerification();
  }

  bool isUserVerified() {
    return _firebaseAuth.currentUser!.emailVerified;
  }

  Future<Either<Failure, bool>> logOut() async {
    try {
      await _firebaseAuth.signOut();
      return right(true);
    } catch (e) {
      return left(const Failure.badRequest());
    }
  }
}

//Provider definition
final authRepositoryProvider = Provider<AuthRepository>(
  (ref) {
    return AuthRepository(
      ref.watch(firebaseAuthProvider),
      ref.watch(userRepositoryProvider),
    );
  },
);
