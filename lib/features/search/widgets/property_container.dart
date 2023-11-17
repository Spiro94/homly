import 'package:flutter/material.dart';
import 'package:homly/features/common/domain/entities/property.dart';

class PropertyContainer extends StatefulWidget {
  const PropertyContainer({
    super.key,
    required this.property,
  });
  final Property property;

  @override
  State<PropertyContainer> createState() => _PropertyContainerState();
}

class _PropertyContainerState extends State<PropertyContainer> {
  double opacity = 0.2;
  double blur = 3;
  Color color = Colors.white;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(opacity),
            spreadRadius: 3,
            blurRadius: blur,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        mouseCursor: SystemMouseCursors.click,
        onHover: (value) {
          if (value) {
            setState(() {
              opacity = 0.5;
              blur = 7;
            });
          } else {
            setState(() {
              opacity = 0.2;
              blur = 3;
            });
          }
        },
        onTap: () {},
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: widget.property.imageUrls.isNotEmpty
                  ? Image.network(
                      widget.property.imageUrls[widget.property.selectedImage],
                      fit: BoxFit.cover,
                    )
                  : Image.asset(
                      'assets/images/apartment_bg.jpg'), //Change to no image available
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(widget.property.address),
                  const SizedBox(
                    height: 8,
                  ),
                  if (widget.property.addressOptional != null)
                    Text(widget.property.addressOptional!)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
