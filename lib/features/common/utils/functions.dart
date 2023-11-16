import 'package:flutter/material.dart';
import 'package:homly/features/common/domain/enums/enum.dart';

String enumToString<Enum>(Enum enumValue) {
  return enumValue.toString().split('.').last;
}

PropertyCategory stringToCategory(String value) {
  return PropertyCategory.values.firstWhere((element) => element.name == value);
}

PropertyType stringToType(String value) {
  return PropertyType.values.firstWhere((element) => element.name == value);
}

String? validateEmail(String? value, BuildContext context) {
  const pattern = r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
      r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
      r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
      r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
      r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
      r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
      r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';
  final regex = RegExp(pattern);
  if (value?.isEmpty ?? false) {
    return 'Ingrese un correo electrónico';
  }
  if (!regex.hasMatch(value ?? '')) {
    return 'Ingrese un correo electrónico válido';
  }
  return null;
}

String areaToString(BuildContext context, AreaUnits units) {
  switch (units) {
    case AreaUnits.meters:
      return 'Metros cuadrados';

    case AreaUnits.feet:
      return 'Pies cuadrados';
  }
}

String typeToString(BuildContext context, PropertyType type) {
  switch (type) {
    case PropertyType.buy:
      return 'Compra';
    case PropertyType.rent:
      return 'Arriendo';
    case PropertyType.vacation:
      return 'Vacacional';
  }
}

String categoryToString(BuildContext context, PropertyCategory category) {
  switch (category) {
    case PropertyCategory.residential:
      return 'Residencial';
    case PropertyCategory.commercial:
      return 'Comercial';
    case PropertyCategory.vacational:
      return 'Vacacional';
    case PropertyCategory.industrial:
      return 'Industrial';
  }
}

// Future<Uint8List> compressFile(Uint8List fileData) =>
//     FlutterImageCompress.compressWithList(
//       fileData,
//       quality: 50,
//     );

(String? lat, String? long) getLatLongFromUrl(String url) {
  final regex = RegExp(r'(?<=@)(-?\d+\.\d+),(-?\d+\.\d+)');
  final match = regex.firstMatch(url);

  if (match != null) {
    final latitude = double.parse(match.group(1) ?? '0');
    final longitude = double.parse(match.group(2) ?? '0');
    print('Latitude: $latitude');
    print('Longitude: $longitude');
    return (latitude.toString(), longitude.toString());
  } else {
    print('No coordinates found in URL.');
    return (null, null);
  }
}
