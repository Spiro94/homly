import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homly/features/property_visualizer/controllers/property_visualizer_screen_controller.dart';

class CustomButton extends ConsumerWidget {
  const CustomButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.isSelected = false,
  });

  final VoidCallback onPressed;
  final Widget child;
  final bool isSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: TextButton(
        onPressed: isSelected
            ? null
            : () {
                onPressed.call();
                if (ref.read(selectedIndexScreenProvider.notifier).state != 0) {
                  ref.read(selectedIndexProvider.notifier).state = 0;
                  ref.read(selectedImageProvider.notifier).state =
                      ref.read(galleryImagesProvider).firstOrNull;
                }
              },
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
          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
          backgroundColor: MaterialStateProperty.all<Color>(
              isSelected ? Colors.grey.shade700 : Colors.grey),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
        child: child,
      ),
    );
  }
}
