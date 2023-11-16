import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:homly/features/common/widgets/embedded_view.dart';
import 'package:homly/features/home/controllers/home_controller.dart';

class TabView extends StatelessWidget {
  const TabView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 5,
      child: DefaultTabController(
        length: 5,
        child: Column(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(16),
                ),
                margin: const EdgeInsets.only(top: 16, bottom: 16, right: 16),
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Consumer(
                        builder: (context, ref, child) {
                          final selectedProperty =
                              ref.watch(selectedPropertyFutureProvider);
                          return selectedProperty.when(
                            skipLoadingOnRefresh: false,
                            error: (error, stackTrace) =>
                                Text(error.toString()),
                            loading: () => const Center(
                              child: CircularProgressIndicator(),
                            ),
                            data: (property) {
                              if (property == null) {
                                return const SizedBox.shrink();
                              } else {
                                return Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          property.name,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineMedium,
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [Text(property.address)],
                                    ),
                                  ],
                                );
                              }
                            },
                          );
                        },
                      ),
                    ),
                    const VerticalDivider(),
                    const Expanded(
                      flex: 2,
                      child: Row(
                        children: [
                          Expanded(
                            child:
                                TabBar(dividerColor: Colors.transparent, tabs: [
                              Tooltip(
                                message: 'Virtual tour',
                                child: Tab(
                                  icon: FaIcon(FontAwesomeIcons.globe),
                                ),
                              ),
                              Tooltip(
                                message: 'BIM Model',
                                child: Tab(
                                  icon: FaIcon(FontAwesomeIcons.layerGroup),
                                ),
                              ),
                              Tooltip(
                                message: 'Google Map',
                                child: Tab(
                                  icon: FaIcon(FontAwesomeIcons.mapLocationDot),
                                ),
                              ),
                              Tooltip(
                                message: 'Renderings',
                                child: Tab(
                                  icon: FaIcon(FontAwesomeIcons.drawPolygon),
                                ),
                              ),
                              Tooltip(
                                message: 'Site Photos',
                                child:
                                    Tab(icon: FaIcon(FontAwesomeIcons.image)),
                              ),
                            ]),
                          ),
                        ],
                      ),
                    ),
                    const VerticalDivider(),
                    Flexible(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: const FaIcon(FontAwesomeIcons.gear),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const FaIcon(FontAwesomeIcons.download),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const FaIcon(FontAwesomeIcons.shareNodes),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(16),
                ),
                margin: const EdgeInsets.only(bottom: 16, right: 16),
                child: Consumer(
                  builder: (context, ref, child) {
                    final future = ref.watch(selectedPropertyFutureProvider);

                    return future.when(
                      error: (error, stackTrace) => Text(error.toString()),
                      loading: () => const Column(
                        children: [
                          Expanded(
                              child:
                                  Center(child: CircularProgressIndicator())),
                        ],
                      ),
                      data: (property) {
                        if (property == null) {
                          return const SizedBox.shrink();
                        } else {
                          return TabBarView(
                            children: [
                              EmbeddedView(link: property.matterportLink),
                              EmbeddedView(link: property.modelLink),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: GoogleMap(
                                    initialCameraPosition: CameraPosition(
                                        target: LatLng(
                                          double.parse(property.latitude),
                                          double.parse(property.longitude),
                                        ),
                                        zoom: 15),
                                    // onMapCreated: _controller.complete,
                                    markers: {
                                      Marker(
                                        markerId: MarkerId(property.id),
                                        position: LatLng(
                                          double.parse(property.latitude),
                                          double.parse(property.longitude),
                                        ),
                                      )
                                    }),
                              ),
                              const Text('Renderings'),
                              const Text('Site Photos'),
                            ],
                          );
                        }
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
