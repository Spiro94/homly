import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homly/features/landing/widgets/highlight_image.dart';
import 'package:homly/features/search/controllers/property_list_controller.dart';

class HighlightsContainer extends ConsumerWidget {
  const HighlightsContainer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final propertyState = ref.watch(propertiesProvider);

    return Container(
      height: size.height,
      width: size.width * 0.9,
      padding: const EdgeInsets.symmetric(
        vertical: 40,
      ),
      child: propertyState.maybeWhen(
        data: (properties) {
          return Column(
            children: [
              Text(
                'Destacados',
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                        child: HighlightImage(
                      property: properties[0],
                    )),
                    const SizedBox(
                      width: 16,
                    ),
                    Expanded(
                        child: HighlightImage(
                      property: properties[1],
                    )),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Flexible(
                child: HighlightImage(
                  property: properties[2],
                ),
              ),
            ],
          );
        },
        orElse: () {
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
