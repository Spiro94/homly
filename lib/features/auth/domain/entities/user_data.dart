import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_data.freezed.dart';
part 'user_data.g.dart';

@freezed
class UserData with _$UserData {
  @JsonSerializable(fieldRename: FieldRename.snake)
  factory UserData({
    required String email,
    required String firstName,
    required String lastName,
    required String phoneNumber,
    required bool isAgent,
    @JsonKey(includeIfNull: false) String? propertyManagerName,
    @JsonKey(includeIfNull: false) String? propertyManagerPhoneNumber,
    @JsonKey(includeIfNull: false) String? propertyManagerEmail,
    @JsonKey(includeIfNull: false) String? propertyManagerAddress,
    @JsonKey(includeIfNull: false) String? propertyManagerAddressOptional,
    @JsonKey(includeIfNull: false) String? country,
    @JsonKey(includeIfNull: false) String? state,
    @JsonKey(includeIfNull: false) String? city,
  }) = _UserData;

  factory UserData.fromJson(Map<String, dynamic> json) =>
      _$UserDataFromJson(json);
}
