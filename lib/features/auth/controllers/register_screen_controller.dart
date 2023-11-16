import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homly/features/auth/domain/entities/user_data.dart';
import 'package:homly/features/auth/infrastructure/repositories/auth_repository.dart';

class RegisterScreenController extends AsyncNotifier<UserData?> {
  @override
  FutureOr<UserData?> build() {
    return null;
  }

  Future<void> registerWithEmailAndPassword(
      String email, String password, UserData userData) async {
    state = const AsyncValue.loading();
    final result = await ref
        .read(authRepositoryProvider)
        .registerUser(email, password, userData);

    state = result.fold(
      (l) => AsyncValue.error(l, StackTrace.current),
      (r) => AsyncValue.data(r),
    );
  }
}

final registerScreenControllerProvider =
    AsyncNotifierProvider<RegisterScreenController, UserData?>(
        RegisterScreenController.new);
