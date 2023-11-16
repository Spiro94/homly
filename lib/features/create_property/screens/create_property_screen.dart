import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:homly/features/auth/controllers/auth_controller.dart';
import 'package:homly/features/create_property/controllers/create_property_screen_controller.dart';
import 'package:homly/features/create_property/widgets/form_widget.dart';
import 'package:homly/features/home/controllers/property_list_controller.dart';
import 'package:homly/features/home/screens/home_screen.dart';
import 'package:transparent_image/transparent_image.dart';

class CreatePropertyScreen extends ConsumerWidget {
  const CreatePropertyScreen({super.key});

  static const String routePath = routeName;
  static const String routeName = 'create_property';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);
    final size = MediaQuery.of(context).size;

    ref.listen(propertyCreateControllerProvider, (previous, next) {
      next.when(
        data: (data) {
          ref.invalidate(userPropertyListControllerProvider);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Propiedad creada exitosamente.'),
            ),
          );
          Future.delayed(
            const Duration(seconds: 1),
            () {
              context.replaceNamed(HomeScreen.routeName);
            },
          );
        },
        error: (error, stackTrace) {
          const SnackBar(
            content:
                Text('Error creando propiedad. Por favor intente de nuevo.'),
          );
        },
        loading: () {},
      );
    });

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          'Homly',
          style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                color: Theme.of(context).colorScheme.secondaryContainer,
                fontWeight: FontWeight.bold,
              ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              log('Tapped');
            },
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: authState.maybeWhen(
                data: (data) {
                  return Text(
                    '${data?.firstName[0].toUpperCase() ?? ''}'
                    '${data?.lastName[0].toUpperCase() ?? ''}',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color:
                              Theme.of(context).colorScheme.secondaryContainer,
                          fontWeight: FontWeight.bold,
                        ),
                  );
                },
                orElse: () => const SizedBox.shrink(),
              ),
            ),
          ),
          const SizedBox(width: 16),
          IconButton(
            onPressed: () {
              ref.read(authControllerProvider.notifier).logOut();
            },
            icon: const Icon(
              Icons.logout,
              size: 20,
            ),
          ),
        ],
      ),
      body: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                child: FadeInImage(
                  placeholder: MemoryImage(kTransparentImage),
                  image: const AssetImage('assets/images/interior_house.jpg'),
                  fit: BoxFit.fitHeight,
                  height: size.height,
                ),
              ),
            ),
          ),
          const Expanded(child: FormWidget()),
        ],
      ),
    );
  }
}
