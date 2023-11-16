import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homly/features/create_property/controllers/create_property_screen_controller.dart';

class ImageSelector extends ConsumerStatefulWidget {
  const ImageSelector({super.key});

  @override
  ConsumerState<ImageSelector> createState() => _ImageSelectorState();
}

class _ImageSelectorState extends ConsumerState<ImageSelector> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final propertyImages =
        ref.watch(createPropertyFormControllerProvider).selectedImages;

    final selectedImage =
        ref.watch(createPropertyFormControllerProvider).selectedImage;
    return Column(
      children: [
        Text(
          'Imágenes de la propiedad',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: () async {
            final result = await FilePicker.platform.pickFiles(
              type: FileType.custom,
              allowedExtensions: ['jpg', 'png', 'jpeg'],
              allowMultiple: true,
            );

            if (result != null && result.files.isNotEmpty) {
              ref.read(createPropertyFormControllerProvider.notifier).state =
                  ref
                      .read(createPropertyFormControllerProvider.notifier)
                      .state
                      .copyWith(
                          selectedImages:
                              result.files.map((e) => e.bytes).toList());
            }
          },
          child: const Text('Seleccionar'),
        ),
        const SizedBox(height: 8),
        if (propertyImages.isNotEmpty)
          Container(
            padding: const EdgeInsets.only(bottom: 8),
            height: 200,
            child: Scrollbar(
              controller: _scrollController,
              child: ListView.builder(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                itemCount: propertyImages.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8),
                    child: Stack(
                      children: [
                        InkWell(
                          onTap: () {
                            ref
                                    .read(createPropertyFormControllerProvider
                                        .notifier)
                                    .state =
                                ref
                                    .read(createPropertyFormControllerProvider
                                        .notifier)
                                    .state
                                    .copyWith(selectedImage: index);
                          },
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                              border: selectedImage == index
                                  ? Border.all(
                                      color: Colors.blue,
                                      width: 3,
                                    )
                                  : null,
                            ),
                            child: Image.memory(
                              propertyImages[index]!,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        if (selectedImage == index)
                          const Positioned(
                            bottom: 2,
                            right: 2,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.check_circle,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        if (propertyImages.isNotEmpty)
          const Column(
            children: [
              Text(
                'Haz clic en la imagen que deseas seleccionar como portada',
              ),
            ],
          ),
      ],
    );
  }
}
