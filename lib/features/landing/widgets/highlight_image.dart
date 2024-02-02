import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:homly/features/common/domain/entities/property.dart';
import 'package:homly/features/property/property_page.dart';

class HighlightImage extends StatefulWidget {
  const HighlightImage({
    super.key,
    required this.property,
  });

  final Property property;

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
      child: InkWell(
        onTap: () {
          context.pushNamed(
            PropertyPage.routeName,
            pathParameters: {'id': widget.property.id},
          );
        },
        child: Transform.scale(
          scale: scaleFactor,
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.network(
                  widget.property.imageUrls.first,
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
                            widget.property.name,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(color: Colors.white),
                          ),
                          Text(
                            widget.property.address,
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
      ),
    );
  }
}
