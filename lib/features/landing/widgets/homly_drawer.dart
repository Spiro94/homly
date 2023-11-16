import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:homly/features/common/domain/enums/enum.dart';
import 'package:homly/features/search/screens/search_screen.dart';

class HomlyDrawer extends StatelessWidget {
  const HomlyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '¿Qué quieres buscar hoy?',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(
              height: 60,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                  onPressed: () {
                    context.pushNamed(
                      SearchScreen.routeName,
                      pathParameters: {
                        'propertyType': PropertyType.buy.name,
                      },
                    );
                    context.pop();
                  },
                  style:
                      OutlinedButton.styleFrom(foregroundColor: Colors.black),
                  child: const Text('Compra'),
                ),
                const SizedBox(
                  width: 16,
                ),
                OutlinedButton(
                  onPressed: () {
                    context.pushNamed(
                      SearchScreen.routeName,
                      pathParameters: {
                        'propertyType': PropertyType.rent.name,
                      },
                    );
                    context.pop();
                  },
                  style:
                      OutlinedButton.styleFrom(foregroundColor: Colors.black),
                  child: const Text('Alquiler'),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
