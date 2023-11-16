import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homly/features/property_visualizer/controllers/property_visualizer_screen_controller.dart';
import 'package:transparent_image/transparent_image.dart';

class CarouselGallery extends ConsumerWidget {
  const CarouselGallery({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    return Stack(
      children: [
        ImageContainer(
          assetName: ref.watch(selectedImageProvider),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 40, right: 40, left: 40),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              height: size.height * 0.12,
              child: Row(
                children: [
                  IconButton(
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
                      if (ref.read(selectedIndexProvider.notifier).state == 0) {
                        return;
                      }
                      ref.read(selectedIndexProvider.notifier).state =
                          ref.read(selectedIndexProvider) - 1;
                      ref.read(selectedImageProvider.notifier).state =
                          ref.read(galleryImagesProvider)[
                              ref.read(selectedIndexProvider)];
                    },
                    icon: const Icon(Icons.arrow_back_ios_new),
                  ),
                  Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: ref.watch(galleryImagesProvider).length,
                      itemBuilder: (context, index) {
                        return ThumbnailContainer(
                          assetName: ref.watch(galleryImagesProvider)[index],
                        );
                      },
                    ),
                  ),
                  IconButton(
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
                      if (ref.read(selectedIndexProvider.notifier).state ==
                          ref.read(galleryImagesProvider).length - 1) return;
                      ref.read(selectedIndexProvider.notifier).state =
                          ref.read(selectedIndexProvider) + 1;
                      ref.read(selectedImageProvider.notifier).state =
                          ref.read(galleryImagesProvider)[
                              ref.read(selectedIndexProvider)];
                    },
                    icon: const Icon(Icons.arrow_forward_ios),
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}

class ImageContainer extends ConsumerWidget {
  const ImageContainer({
    super.key,
    this.assetName,
  });

  final String? assetName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      width: size.width * (ref.watch(showSideNavigationProvider) ? 0.8 : 1),
      height: size.height,
      child: assetName != null
          ? Image.asset(
              assetName!,
              fit: BoxFit.cover,
            )
          : Image.memory(kTransparentImage),
    );
  }
}

class ThumbnailContainer extends ConsumerStatefulWidget {
  const ThumbnailContainer({super.key, required this.assetName});

  final String assetName;

  @override
  ConsumerState<ThumbnailContainer> createState() => _ThumbnailContainerState();
}

class _ThumbnailContainerState extends ConsumerState<ThumbnailContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation _animation;
  late Animation padding;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 10),
      vsync: this,
    );
    _animation = Tween(begin: 1.0, end: 1.08).animate(CurvedAnimation(
        parent: _controller, curve: Curves.ease, reverseCurve: Curves.easeIn));
    // padding = Tween(begin: 0.0, end: -8.0).animate(CurvedAnimation(
    //     parent: _controller, curve: Curves.ease, reverseCurve: Curves.easeIn));
    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return MouseRegion(
      onEnter: (value) {
        setState(() {
          _controller.forward();
        });
      },
      onExit: (value) {
        setState(() {
          _controller.reverse();
        });
      },
      child: InkWell(
        onTap: () {
          ref.read(selectedImageProvider.notifier).state = widget.assetName;
          ref.read(selectedIndexProvider.notifier).state =
              ref.read(galleryImagesProvider).indexOf(widget.assetName);
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: size.height * 0.08,
              width: size.width * 0.1,
              margin: const EdgeInsets.symmetric(horizontal: 8),
              transform: Matrix4(_animation.value, 0, 0, 0, 0, _animation.value,
                  0, 0, 0, 0, 1, 0, 0, 0, 0, 1),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white,
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Image.asset(
                widget.assetName,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
