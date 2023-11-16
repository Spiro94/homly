import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homly/features/common/infrastructure/repositories/property_repository.dart';
import 'package:homly/features/create_property/domain/property_form_data.dart';

import 'dart:developer';

class PropertyCreateControllerNotifier extends StateNotifier<AsyncValue<void>> {
  PropertyCreateControllerNotifier(this._repository, this._formData)
      : super(const AsyncValue.data(null));

  final PropertyRepository _repository;
  final PropertyFormData _formData;

  Future<void> createProperty() async {
    try {
      state = const AsyncValue.loading();
      final savedImageUrls = <String>[];

      final property = _formData.toDomain();

      if (_formData.selectedImages.isNotEmpty) {
        for (final image in _formData.selectedImages) {
          final result = await _repository.saveImageToFirebaseStorage(
            property.id,
            image!,
          );
          savedImageUrls.add(result);
        }
      }
      log(savedImageUrls.toString());

      final newProperty = property.copyWith(imageUrls: savedImageUrls);

      await _repository.createProperty(newProperty);
      state = const AsyncValue.data(null);
    } catch (e) {
      state = AsyncValue.error(e.toString(), StackTrace.current);
    }
  }
}

final propertyCreateControllerProvider =
    StateNotifierProvider<PropertyCreateControllerNotifier, AsyncValue<void>>(
        (ref) {
  return PropertyCreateControllerNotifier(
    ref.watch(propertyRepositoryProvider),
    ref.watch(createPropertyFormControllerProvider),
  );
});

final createPropertyFormControllerProvider =
    StateProvider<PropertyFormData>((ref) {
  return PropertyFormData();
});
