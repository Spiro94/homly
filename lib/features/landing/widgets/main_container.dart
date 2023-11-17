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
            height: (size.height - (appBarHeight ?? 0)),
            width: size.width,
            decoration: const BoxDecoration(
              image: DecorationImage(
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
          Container(
            margin: const EdgeInsets.only(bottom: 16, left: 16),
            alignment: Alignment.bottomLeft,
            child: Image.asset(
              'assets/logos/homly-08.png',
              height: 80,
            ),
          )
        ],
      ),
    );
  }
}
