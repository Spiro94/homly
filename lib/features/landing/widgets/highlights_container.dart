import 'package:flutter/material.dart';
import 'package:homly/features/landing/widgets/highlight_image.dart';

class HighlightsContainer extends StatelessWidget {
  const HighlightsContainer({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      height: size.height,
      width: size.width * 0.9,
      padding: const EdgeInsets.symmetric(
        vertical: 40,
      ),
      child: Column(
        children: [
          Text(
            'Destacados',
            style: Theme.of(context)
                .textTheme
                .headlineMedium!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          const Expanded(
            child: Row(
              children: [
                Expanded(
                    child: HighlightImage(
                  imagePath: 'assets/images/apartment_bg.jpg',
                )),
                SizedBox(
                  width: 16,
                ),
                Expanded(
                    child: HighlightImage(
                  imagePath: 'assets/images/interior_house.jpg',
                )),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Flexible(
            child: HighlightImage(
              imagePath: 'assets/images/apt_bg.jpg',
            ),
          ),
        ],
      ),
    );
  }
}
