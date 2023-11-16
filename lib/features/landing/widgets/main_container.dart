import 'package:flutter/material.dart';

class MainContainer extends StatelessWidget {
  const MainContainer({
    super.key,
    required this.onButtonPressed,
  });

  final VoidCallback onButtonPressed;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final appBarHeight = Scaffold.of(context).appBarMaxHeight;
    return SizedBox(
      height: size.height - (appBarHeight ?? 0),
      width: size.width,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: (size.height - (appBarHeight ?? 0)) * 0.8,
            width: size.width * 0.9,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: const DecorationImage(
                image: AssetImage('assets/images/brick_house.jpg'),
                fit: BoxFit.fill,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Explora hogares con un clic!',
                  style: Theme.of(context).textTheme.displayLarge!.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 24,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: onButtonPressed,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    child: Text(
                      'Explorar',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
