import 'package:flutter/services.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:homly/features/common/domain/entities/property.dart';
import 'package:homly/features/common/domain/enums/enum.dart';
import 'package:homly/features/common/utils/functions.dart';
import 'package:uuid/uuid.dart';

part 'property_form_data.freezed.dart';

@freezed
class PropertyFormData with _$PropertyFormData {
  factory PropertyFormData({
    String? id,
    String? name,
    String? address,
    String? addressOptional,
    String? neighborhood,
    String? zipCode,
    String? googleMapsLink,
    String? matterportLink,
    String? modelLink,
    int? bathrooms,
    int? rooms,
    double? area,
    String? city,
    String? state,
    String? country,
    double? price,
    String? addedBy,
    @Default(true) bool isM2,
    @Default(PropertyType.rent) PropertyType type,
    @Default(PropertyCategory.residential) PropertyCategory category,
    @Default([]) List<Uint8List?> selectedImages,
    @Default(0) int selectedImage,
  }) = _PropertyFormData;

  PropertyFormData._();

  Property toDomain() {
    var (lat, lon) = getLatLongFromUrl(googleMapsLink!);
    return Property(
      id: const Uuid().v4(),
      address: address!,
      name: name!,
      addressOptional: addressOptional,
      neighborhood: neighborhood!,
      zipCode: zipCode!,
      latitude: lat!,
      longitude: lon!,
      matterportLink: matterportLink!,
      modelLink: modelLink!,
      bathrooms: bathrooms!,
      rooms: rooms!,
      area: area!,
      city: city!,
      state: state!,
      country: country!,
      price: price!,
      addedBy: addedBy!,
      isM2: isM2,
      type: type,
      category: category,
      imageUrls: [],
    );
  }

  bool get isComplete =>
      address != null &&
      name != null &&
      neighborhood != null &&
      zipCode != null &&
      googleMapsLink != null &&
      matterportLink != null &&
      modelLink != null &&
      bathrooms != null &&
      rooms != null &&
      area != null &&
      city != null &&
      state != null &&
      country != null &&
      price != null &&
      selectedImages.isNotEmpty;
}
