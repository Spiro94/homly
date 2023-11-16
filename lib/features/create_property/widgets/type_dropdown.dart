import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homly/features/common/domain/enums/enum.dart';
import 'package:homly/features/common/utils/functions.dart';
import 'package:homly/features/create_property/controllers/create_property_screen_controller.dart';

class TypeDropdown extends ConsumerWidget {
  const TypeDropdown({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DropdownButtonFormField<PropertyType>(
      value: ref.watch(createPropertyFormControllerProvider).type,
      decoration: const InputDecoration(
        labelText: 'Tipo',
      ),
      onChanged: (value) {
        ref.read(createPropertyFormControllerProvider.notifier).state = ref
            .read(createPropertyFormControllerProvider.notifier)
            .state
            .copyWith(type: value!);
      },
      items: PropertyType.values.map<DropdownMenuItem<PropertyType>>((value) {
        return DropdownMenuItem<PropertyType>(
          value: value,
          child: Text(typeToString(context, value)),
        );
      }).toList(),
    );
  }
}
