import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homly/features/common/domain/entities/property.dart';
import 'package:homly/features/common/infrastructure/repositories/property_repository.dart';

final propertyProvider =
    FutureProvider.family<Property, String>((ref, id) async {
  return ref.watch(propertyRepositoryProvider).getProperty(id);
});
