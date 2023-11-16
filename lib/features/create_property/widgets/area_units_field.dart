import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homly/features/common/domain/enums/enum.dart';
import 'package:homly/features/common/utils/functions.dart';
import 'package:homly/features/create_property/controllers/create_property_screen_controller.dart';

class AreaUnitsField extends ConsumerStatefulWidget {
  const AreaUnitsField({super.key});

  @override
  ConsumerState<AreaUnitsField> createState() => _AreaUnitsFieldState();
}

class _AreaUnitsFieldState extends ConsumerState<AreaUnitsField> {
  AreaUnits selectedUnits = AreaUnits.meters;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Row(
          children: AreaUnits.values
              .map(
                (e) => Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: ChoiceChip(
                    selected: selectedUnits == e,
                    onSelected: (value) {
                      if (value) {
                        setState(() {
                          selectedUnits = e;
                          ref
                                  .read(createPropertyFormControllerProvider
                                      .notifier)
                                  .state =
                              ref
                                  .read(createPropertyFormControllerProvider
                                      .notifier)
                                  .state
                                  .copyWith(isM2: e == AreaUnits.meters);
                        });
                      }
                    },
                    label: FittedBox(
                      child: Text(
                        areaToString(context, e),
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        Flexible(
          child: TextFormField(
            // controller: _area,
            decoration: InputDecoration(
              labelText: 'Área en ${areaToString(context, selectedUnits)}',
            ),
            keyboardType: const TextInputType.numberWithOptions(
              decimal: true,
            ),
            inputFormatters: [
              FilteringTextInputFormatter.allow(
                RegExp(r'^\d+\.?\d{0,2}'),
              )
            ],
            validator: (value) {
              if (value?.isEmpty ?? false) {
                return 'Por favor ingrese un valor';
              }
              return null;
            },
            onChanged: (value) {
              ref.read(createPropertyFormControllerProvider.notifier).state =
                  ref
                      .read(createPropertyFormControllerProvider.notifier)
                      .state
                      .copyWith(area: double.parse(value));
            },
          ),
        ),
      ],
    );
  }
}
