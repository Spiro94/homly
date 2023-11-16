import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:homly/features/common/domain/enums/enum.dart';
import 'package:homly/features/common/utils/functions.dart';

part 'property.freezed.dart';
part 'property.g.dart';

@freezed
class Property with _$Property {
  @JsonSerializable(fieldRename: FieldRename.snake)
  factory Property({
    required String id,
    required String name,
    required String address,
    @JsonKey(includeIfNull: false) String? addressOptional,
    required String neighborhood,
    required String zipCode,
    required String latitude,
    required String longitude,
    required String matterportLink,
    required String modelLink,
    required int bathrooms,
    required int rooms,
    required double area,
    required String city,
    required String state,
    required String country,
    @Default(true) bool isM2,
    @JsonKey(fromJson: stringToType, toJson: enumToString)
    required PropertyType type,
    @JsonKey(fromJson: stringToCategory, toJson: enumToString)
    required PropertyCategory category,
    required double price,
    @Default([]) List<String> imageUrls,
    @Default(0) int selectedImage,
    required String addedBy,
  }) = _Property;

  Property._();

  factory Property.fromJson(Map<String, dynamic> json) =>
      _$PropertyFromJson(json);
}
