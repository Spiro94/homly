import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homly/features/auth/controllers/auth_controller.dart';
import 'package:homly/features/common/domain/entities/property.dart';
import 'package:homly/features/common/infrastructure/repositories/property_repository.dart';

final userPropertyListControllerProvider =
    FutureProvider<List<Property>>((ref) async {
  final user = ref.watch(authControllerProvider).maybeWhen(
        data: (data) => data,
        orElse: () => null,
      );

  return ref.watch(propertyRepositoryProvider).getUserProperties(user?.email);
});
