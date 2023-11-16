import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homly/features/common/domain/entities/property.dart';
import 'package:homly/features/common/infrastructure/repositories/property_repository.dart';

final propertiesProvider = FutureProvider<List<Property>>((ref) async {
  return ref.watch(propertyRepositoryProvider).getProperties();
});
