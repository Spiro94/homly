import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homly/features/common/domain/enums/enum.dart';
import 'package:homly/features/common/utils/functions.dart';
import 'package:homly/features/create_property/controllers/create_property_screen_controller.dart';

class CategoryDropdown extends ConsumerWidget {
  const CategoryDropdown({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: DropdownButtonFormField<PropertyCategory>(
        value: ref.watch(createPropertyFormControllerProvider).category,
        decoration: const InputDecoration(
          labelText: 'Categoría',
        ),
        onChanged: (value) {
          ref.read(createPropertyFormControllerProvider.notifier).state = ref
              .read(createPropertyFormControllerProvider.notifier)
              .state
              .copyWith(category: value!);
        },
        items: PropertyCategory.values
            .map<DropdownMenuItem<PropertyCategory>>((value) {
          return DropdownMenuItem<PropertyCategory>(
            value: value,
            child: Text(categoryToString(context, value)),
          );
        }).toList(),
      ),
    );
  }
}
