import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homly/features/create_property/controllers/create_property_screen_controller.dart';

class CscPickerWidget extends ConsumerStatefulWidget {
  const CscPickerWidget({super.key});

  @override
  ConsumerState<CscPickerWidget> createState() => _CscPickerWidgetState();
}

class _CscPickerWidgetState extends ConsumerState<CscPickerWidget> {
  final cscPickerKey = GlobalKey<CSCPickerState>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: CSCPicker(
        key: cscPickerKey,
        flagState: CountryFlag.DISABLE,
        dropdownDecoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade300),
        ),
        disabledDropdownDecoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          color: Colors.grey.shade300,
          border: Border.all(color: Colors.grey.shade300),
        ),
        countrySearchPlaceholder: 'Pais',
        stateSearchPlaceholder: 'Departamento',
        citySearchPlaceholder: 'Ciudad',
        countryDropdownLabel: 'Seleccionar pais',
        stateDropdownLabel: 'Seleccionar departamento',
        cityDropdownLabel: 'Seleccionar ciudad',
        defaultCountry: CscCountry.Colombia,
        dropdownHeadingStyle: const TextStyle(
          color: Colors.black,
          fontSize: 17,
          fontWeight: FontWeight.bold,
        ),
        onCountryChanged: (value) {
          ref.read(createPropertyFormControllerProvider.notifier).state = ref
              .read(createPropertyFormControllerProvider.notifier)
              .state
              .copyWith(country: value, state: null, city: null);
        },
        onStateChanged: (value) {
          ref.read(createPropertyFormControllerProvider.notifier).state = ref
              .read(createPropertyFormControllerProvider.notifier)
              .state
              .copyWith(state: value, city: null);
        },
        onCityChanged: (value) {
          ref.read(createPropertyFormControllerProvider.notifier).state = ref
              .read(createPropertyFormControllerProvider.notifier)
              .state
              .copyWith(city: value);
        },
      ),
    );
  }
}
