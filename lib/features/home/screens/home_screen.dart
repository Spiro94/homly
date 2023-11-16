import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homly/features/auth/controllers/auth_controller.dart';
import 'package:homly/features/home/widgets/side_view.dart';
import 'package:homly/features/home/widgets/tab_view.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  static const routePath = '/$routeName';
  static const routeName = 'home';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);

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
      body: const Row(
        children: [
          SideView(),
          TabView(),
        ],
      ),
    );
  }
}
