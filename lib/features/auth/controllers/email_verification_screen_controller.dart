import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homly/features/auth/infrastructure/repositories/auth_repository.dart';

final sendEmailVerificationProvider = FutureProvider<void>((ref) async {
  return ref.read(authRepositoryProvider).sendEmailVerification();
});
