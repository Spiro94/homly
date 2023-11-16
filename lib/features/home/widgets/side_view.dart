import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:homly/features/create_property/screens/create_property_screen.dart';
import 'package:homly/features/home/controllers/home_controller.dart';
import 'package:homly/features/home/controllers/property_list_controller.dart';
import 'package:shimmer/shimmer.dart';

class SideView extends StatelessWidget {
  const SideView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Flexible(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        height: size.height,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(16),
        ),
        width: size.width * 0.2,
        child: Column(
          children: [
            const TextField(
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 8),
                prefixIcon: Icon(Icons.search),
                hintText: 'Búsqueda por nombre',
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Consumer(
                builder: (context, ref, child) {
                  final properties =
                      ref.watch(userPropertyListControllerProvider);
                  final selectedIndex = ref.watch(selectedIndexProvider);
                  return properties.when(
                    skipLoadingOnRefresh: false,
                    error: (error, stackTrace) => Text(error.toString()),
                    loading: () => ListView(
                      shrinkWrap: true,
                      children: List.generate(
                        3,
                        (index) => Card(
                          child: ListTile(
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 16),
                            title: Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: Container(
                                height: 15,
                                width: 200,
                                color: Colors.white,
                              ),
                            ),
                            subtitle: Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: Container(
                                height: 15,
                                width: 50,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    data: (properties) {
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: properties.length,
                        itemBuilder: (context, index) {
                          final property = properties[index];

                          return Card(
                            clipBehavior: Clip.antiAlias,
                            elevation: 10,
                            color: selectedIndex == index
                                ? Theme.of(context)
                                    .colorScheme
                                    .secondaryContainer
                                : null,
                            child: ListTile(
                              onTap: () {
                                ref.read(selectedIndexProvider.notifier).state =
                                    index;

                                Scaffold.of(context).closeDrawer();
                              },
                              selected: selectedIndex == index,
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              title: Text(
                                property.name,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                      overflow: TextOverflow.ellipsis,
                                      fontWeight: FontWeight.bold,
                                    ),
                                maxLines: 2,
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 0),
                                child: Text(
                                  property.address,
                                  style: Theme.of(context).textTheme.bodySmall,
                                  maxLines: 1,
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            FloatingActionButton(
              onPressed: () {
                context.pushNamed(CreatePropertyScreen.routeName);
              },
              child: const Icon(
                Icons.add,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
