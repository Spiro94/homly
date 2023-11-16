import 'dart:async';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homly/features/auth/domain/entities/user_data.dart';
import 'package:homly/features/auth/infrastructure/repositories/auth_repository.dart';
import 'package:homly/features/auth/infrastructure/repositories/user_repository.dart';

class AuthController extends StateNotifier<AsyncValue<UserData?>> {
  final AuthRepository _authRepository;
  final UserRepository _userRepository;
  final Ref _ref;

  late StreamSubscription subscription;

  AuthController(
    this._authRepository,
    this._userRepository,
    this._ref,
  ) : super(const AsyncValue.data(null)) {
    subscription = _authRepository.authStateChanges.listen((user) {
      log('Auth state changed: $user');
      state = const AsyncValue.loading();
      if (user == null) {
        _ref.read(isUserVerifiedProvider.notifier).state = false;
        state = const AsyncValue.data(null);
      } else {
        if (user.emailVerified) {
          _userRepository.getUserData(user.email!).then((value) {
            state = value.fold(
              (l) => AsyncValue.error(l, StackTrace.current),
              (r) {
                _ref.read(isUserVerifiedProvider.notifier).state = true;
                return AsyncValue.data(r);
              },
            );
          });
        } else {
          _ref.read(isUserVerifiedProvider.notifier).state = false;
          state = const AsyncValue.data(null);
        }
      }
    });
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    state = const AsyncValue.loading();
    final result = await _authRepository.loginWithEmail(email, password);

    state = result.fold(
      (l) => AsyncValue.error(l, StackTrace.current),
      (r) => AsyncValue.data(r),
    );
  }

  Future<void> registerWithEmailAndPassword(
      String email, String password, UserData userData) async {
    state = const AsyncValue.loading();
    final result =
        await _authRepository.registerUser(email, password, userData);

    state = result.fold(
      (l) => AsyncValue.error(l, StackTrace.current),
      (r) => AsyncValue.data(r),
    );
  }

  Future<void> logOut() async {
    await _authRepository.logOut();
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }
}

final authControllerProvider =
    StateNotifierProvider<AuthController, AsyncValue<UserData?>>(
  (ref) => AuthController(
    ref.watch(authRepositoryProvider),
    ref.watch(userRepositoryProvider),
    ref,
  ),
);

/// Provides a [ValueNotifier] to the app router to redirect on auth state change
final authStateListenable = ValueNotifier<bool>(false);

final isUserVerifiedProvider = StateProvider<bool>((ref) {
  return false;
});

final userChangesProvider = StreamProvider<User?>((ref) async* {
  yield* ref.watch(authRepositoryProvider).userChanges;
});
