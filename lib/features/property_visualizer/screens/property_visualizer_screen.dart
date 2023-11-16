import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homly/features/property_visualizer/controllers/property_visualizer_screen_controller.dart';

import 'package:homly/features/property_visualizer/widgets/custom_button.dart';
import 'package:homly/features/property_visualizer/widgets/expanded_section.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

class PropertyVisualizerScreen extends ConsumerStatefulWidget {
  const PropertyVisualizerScreen({super.key, required this.name});

  static const routePath = '/$routeName/:name';
  static const routeName = 'property_visualizer';

  final String name;

  @override
  ConsumerState<PropertyVisualizerScreen> createState() =>
      _PropertyVisualizerScreenState();
}

class _PropertyVisualizerScreenState
    extends ConsumerState<PropertyVisualizerScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(galleryImagesProvider.notifier).state = [
        'assets/images/apartment_bg.jpg',
        'assets/images/apartment_vision.jpg',
        'assets/images/interior_house.jpg',
      ];
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          Row(
            children: [
              Flexible(
                child: ExpandedSection(
                  expand: ref.watch(showSideNavigationProvider),
                  child: Container(
                    padding: const EdgeInsets.only(
                      right: 16,
                      left: 16,
                      top: 56,
                      bottom: 16,
                    ),
                    decoration: const BoxDecoration(color: Colors.grey),
                    child: Column(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              SizedBox(
                                height: size.height * 0.2,
                                child: Center(
                                  child: Image.asset(
                                    'assets/images/logo_casa.jpg',
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              CustomButton(
                                isSelected:
                                    ref.watch(selectedIndexScreenProvider) == 0,
                                onPressed: () {
                                  ref
                                      .read(
                                          selectedIndexScreenProvider.notifier)
                                      .state = 0;
                                },
                                child: const Text(
                                  'Galería',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                              CustomButton(
                                isSelected:
                                    ref.watch(selectedIndexScreenProvider) == 1,
                                onPressed: () {
                                  ref
                                      .read(
                                          selectedIndexScreenProvider.notifier)
                                      .state = 1;
                                },
                                child: const Text(
                                  'Video Tour',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                              CustomButton(
                                isSelected:
                                    ref.watch(selectedIndexScreenProvider) == 2,
                                onPressed: () {
                                  ref
                                      .read(
                                          selectedIndexScreenProvider.notifier)
                                      .state = 2;
                                },
                                child: const Text(
                                  'Tour Virtual 3D',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                              CustomButton(
                                isSelected:
                                    ref.watch(selectedIndexScreenProvider) == 3,
                                onPressed: () {
                                  ref
                                      .read(
                                          selectedIndexScreenProvider.notifier)
                                      .state = 3;
                                },
                                child: const Text(
                                  'Acerca de la propiedad',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            const Divider(),
                            SizedBox(
                              height: size.height * 0.1,
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.person,
                                    size: 30,
                                  ),
                                  Text('Contact info')
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: ref.watch(showSideNavigationProvider)
                    ? size.width * 0.8
                    : size.width,
                child: ref.watch(selectedWidgetProvider),
              )
            ],
          ),
          PointerInterceptor(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(8),
                ),
              ),
              padding: const EdgeInsets.all(8),
              child: IconButton(
                style: ButtonStyle(
                  overlayColor: MaterialStateProperty.resolveWith<Color?>(
                    (Set<MaterialState> states) {
                      if (states.contains(MaterialState.hovered)) {
                        return Colors.grey.shade600;
                      }
                      if (states.contains(MaterialState.pressed)) {
                        return Colors.grey.shade700;
                      }
                      return null;
                    },
                  ),
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.grey),
                ),
                onPressed: () {
                  ref.read(showSideNavigationProvider.notifier).state =
                      !ref.read(showSideNavigationProvider.notifier).state;
                },
                icon: Icon(ref.watch(showSideNavigationProvider)
                    ? Icons.close
                    : Icons.menu),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
