import 'package:flutter/material.dart';

class HighlightImage extends StatefulWidget {
  const HighlightImage({
    super.key,
    required this.imagePath,
  });

  final String imagePath;

  @override
  State<HighlightImage> createState() => _HighlightImageState();
}

class _HighlightImageState extends State<HighlightImage> {
  double scaleFactor = 1.0;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) {
        setState(() {
          scaleFactor = 1.01; // Increase the scale factor on hover
        });
      },
      onExit: (_) {
        setState(() {
          scaleFactor = 1.0; // Reset the scale factor when not hovered
        });
      },
      child: Transform.scale(
        scale: scaleFactor,
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                widget.imagePath,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                color: Colors.black.withOpacity(0.5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Nombre propiedad',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(color: Colors.white),
                        ),
                        Text(
                          'Dirección',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(color: Colors.white),
                        ),
                      ],
                    ),
                    Image.asset(
                      'assets/logos/homly-08.png',
                      height: 40,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
