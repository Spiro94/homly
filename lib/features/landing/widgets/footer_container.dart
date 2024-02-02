import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FooterContainer extends StatelessWidget {
  const FooterContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Container(
                    width: 150,
                    padding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                    color: Colors.grey[700],
                    child: const Text(
                      'COLOMBIA',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Container(
                    width: 150,
                    padding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                    color: Colors.grey[700],
                    child: const Text(
                      'ESPAÑA',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        style: ButtonStyle(
                          foregroundColor: MaterialStateColor.resolveWith(
                              (states) => Colors.white),
                        ),
                        icon: const FaIcon(FontAwesomeIcons.facebook),
                        onPressed: () {},
                      ),
                      IconButton(
                        style: ButtonStyle(
                          foregroundColor: MaterialStateColor.resolveWith(
                              (states) => Colors.white),
                        ),
                        icon: const FaIcon(FontAwesomeIcons.twitter),
                        onPressed: () {},
                      ),
                      IconButton(
                        style: ButtonStyle(
                          foregroundColor: MaterialStateColor.resolveWith(
                              (states) => Colors.white),
                        ),
                        icon: const FaIcon(FontAwesomeIcons.instagram),
                        onPressed: () {},
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    '© ${DateTime.now().year} Homly by KOV solutions',
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Container(
                height: 80,
                width: 100,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  image: DecorationImage(
                    image: AssetImage('assets/logos/homly_new.png'),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              // Column(
              //   children: [
              //     Image.asset(
              //       'assets/logos/homly-08.png',
              //       height: 60,
              //     ),
              //     const SizedBox(
              //       height: 4,
              //     ),
              //     Image.asset(
              //       'assets/logos/homly-name.png',
              //       height: 30,
              //     ),
              //   ],
              // ),
            ],
          ),
        ],
      ),
    );
  }
}
