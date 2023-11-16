import 'dart:developer';

import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homly/features/auth/controllers/auth_controller.dart';
import 'package:homly/features/create_property/controllers/create_property_screen_controller.dart';
import 'package:homly/features/create_property/widgets/area_units_field.dart';
import 'package:homly/features/create_property/widgets/category_dropdown.dart';
import 'package:homly/features/create_property/widgets/csc_picker.dart';
import 'package:homly/features/create_property/widgets/image_selector.dart';
import 'package:homly/features/create_property/widgets/type_dropdown.dart';

class FormWidget extends ConsumerWidget {
  const FormWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Form(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          children: [
            Text(
              'Crear propiedad',
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            TextFormField(
              controller: TextEditingController(),
              decoration: const InputDecoration(
                labelText: 'Nombre',
                hintText: 'Nombre',
              ),
              onChanged: (value) {
                ref.read(createPropertyFormControllerProvider.notifier).state =
                    ref
                        .read(createPropertyFormControllerProvider.notifier)
                        .state
                        .copyWith(name: value);
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: TextEditingController(),
              decoration: const InputDecoration(
                labelText: 'Dirección',
                hintText: 'Calles, número',
              ),
              onChanged: (value) {
                ref.read(createPropertyFormControllerProvider.notifier).state =
                    ref
                        .read(createPropertyFormControllerProvider.notifier)
                        .state
                        .copyWith(address: value);
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: TextEditingController(),
              decoration: const InputDecoration(
                labelText: 'Dirección 2',
                hintText: 'Apartamento, unidad, etc. (opcional)',
              ),
              onChanged: (value) {
                ref.read(createPropertyFormControllerProvider.notifier).state =
                    ref
                        .read(createPropertyFormControllerProvider.notifier)
                        .state
                        .copyWith(addressOptional: value);
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Flexible(
                  child: TextFormField(
                    controller: TextEditingController(),
                    decoration: const InputDecoration(
                      labelText: 'Barrio',
                      hintText: 'Barrio',
                    ),
                    onChanged: (value) {
                      ref
                              .read(createPropertyFormControllerProvider.notifier)
                              .state =
                          ref
                              .read(
                                  createPropertyFormControllerProvider.notifier)
                              .state
                              .copyWith(neighborhood: value);
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Flexible(
                  child: TextFormField(
                    controller: TextEditingController(),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    decoration: const InputDecoration(
                      labelText: 'Código postal',
                      hintText: '123456',
                    ),
                    onChanged: (value) {
                      ref
                              .read(createPropertyFormControllerProvider.notifier)
                              .state =
                          ref
                              .read(
                                  createPropertyFormControllerProvider.notifier)
                              .state
                              .copyWith(zipCode: value);
                    },
                  ),
                ),
              ],
            ),
            const CscPickerWidget(),
            TextFormField(
              controller: TextEditingController(),
              decoration: const InputDecoration(
                labelText: 'Link de Google Maps',
                hintText: 'Link de Google Maps',
              ),
              onChanged: (value) {
                ref.read(createPropertyFormControllerProvider.notifier).state =
                    ref
                        .read(createPropertyFormControllerProvider.notifier)
                        .state
                        .copyWith(googleMapsLink: value);
              },
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            const AreaUnitsField(),
            const SizedBox(height: 16),
            Row(
              children: [
                Flexible(
                  child: TextFormField(
                    controller: TextEditingController(),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    decoration: const InputDecoration(
                      labelText: 'Baños',
                      hintText: 'Baños',
                    ),
                    onChanged: (value) {
                      ref
                              .read(createPropertyFormControllerProvider.notifier)
                              .state =
                          ref
                              .read(
                                  createPropertyFormControllerProvider.notifier)
                              .state
                              .copyWith(bathrooms: int.parse(value));
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Flexible(
                  child: TextFormField(
                    controller: TextEditingController(),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    decoration: const InputDecoration(
                      labelText: 'Dormitorios',
                      hintText: 'Dormitorios',
                    ),
                    onChanged: (value) {
                      ref
                              .read(createPropertyFormControllerProvider.notifier)
                              .state =
                          ref
                              .read(
                                  createPropertyFormControllerProvider.notifier)
                              .state
                              .copyWith(rooms: int.parse(value));
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: TextEditingController(),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                CurrencyTextInputFormatter(
                  decimalDigits: 0,
                  symbol: '\$',
                )
              ],
              decoration: const InputDecoration(
                labelText: 'Precio',
                hintText: '\$ 100.000.000',
              ),
              onChanged: (value) {
                ref.read(createPropertyFormControllerProvider.notifier).state =
                    ref
                        .read(createPropertyFormControllerProvider.notifier)
                        .state
                        .copyWith(
                          price: double.parse(
                            value.replaceAll('\$', '').replaceAll(',', ''),
                          ),
                        );
              },
            ),
            const CategoryDropdown(),
            const TypeDropdown(),
            const SizedBox(height: 16),
            TextFormField(
              controller: TextEditingController(),
              decoration: const InputDecoration(
                labelText: 'Link de Matterport',
                hintText: 'https://my.matterport.com/show/?m=65as4df',
              ),
              onChanged: (value) {
                ref.read(createPropertyFormControllerProvider.notifier).state =
                    ref
                        .read(createPropertyFormControllerProvider.notifier)
                        .state
                        .copyWith(matterportLink: value);
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: TextEditingController(),
              decoration: const InputDecoration(
                labelText: 'Link de Modelo 3D',
                hintText: 'https://a360.co/45s4d5',
              ),
              onChanged: (value) {
                ref.read(createPropertyFormControllerProvider.notifier).state =
                    ref
                        .read(createPropertyFormControllerProvider.notifier)
                        .state
                        .copyWith(modelLink: value);
              },
            ),
            const SizedBox(height: 16),
            const ImageSelector(),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            Column(
              children: [
                Consumer(
                  builder: (context, ref, _) {
                    final state = ref.watch(propertyCreateControllerProvider);
                    final formData =
                        ref.watch(createPropertyFormControllerProvider);

                    log('Is complete: ${formData.isComplete}');
                    return FilledButton(
                      onPressed: (state.isLoading || !formData.isComplete)
                          ? null
                          : () {
                              final authState =
                                  ref.read(authControllerProvider);

                              if (authState.hasValue) {
                                ref
                                        .read(
                                            createPropertyFormControllerProvider
                                                .notifier)
                                        .state =
                                    ref
                                        .read(
                                            createPropertyFormControllerProvider
                                                .notifier)
                                        .state
                                        .copyWith(
                                            addedBy:
                                                authState.asData!.value!.email);
                                ref
                                    .read(propertyCreateControllerProvider
                                        .notifier)
                                    .createProperty();
                              }
                            },
                      child: state.isLoading
                          ? const Column(
                              children: [
                                SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(),
                                ),
                              ],
                            )
                          : const Text(
                              'Crear propiedad',
                              textAlign: TextAlign.center,
                            ),
                    );
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
