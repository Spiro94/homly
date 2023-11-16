import 'package:flutter/material.dart';

class VisionContainer extends StatelessWidget {
  const VisionContainer({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 48,
        horizontal: 50,
      ),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        color: Colors.white,
      ),
      width: size.width,
      child: Column(
        children: [
          Text(
            'Nuestra visión',
            style: Theme.of(context)
                .textTheme
                .headlineMedium!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                flex: 2,
                child: SizedBox(
                  width: size.height * 0.6,
                  child: Text(
                      'Transformar la experiencia de búsqueda de apartamentos al proporcionar una '
                      'plataforma virtual que potencia el alquiler a distancia, haciendo más '
                      'sencillo para las personas encontrar el hogar ideal, sin importar su '
                      'ubicación geográfica.',
                      style: Theme.of(context).textTheme.headlineSmall),
                ),
              ),
              const SizedBox(
                width: 100,
              ),
              Flexible(
                child: Container(
                  height: size.height * 0.4,
                  width: size.height * 0.4,
                  decoration: const BoxDecoration(boxShadow: [
                    BoxShadow(
                        color: Colors.black,
                        blurRadius: 10,
                        offset: Offset(0, 10))
                  ]),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                    ),
                    child: Image.asset(
                      'assets/images/vision.jpeg',
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
