import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:homly/features/common/domain/enums/enum.dart';
import 'package:homly/features/landing/screens/landing_screen.dart';
import 'package:homly/features/search/controllers/property_list_controller.dart';
import 'package:homly/features/search/widgets/property_container.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:shimmer/shimmer.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key, required this.propertyType});

  final PropertyType propertyType;

  static const routePath = '$routeName/:propertyType';
  static const routeName = 'listing';

  @override
  ConsumerState<SearchScreen> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchScreen> {
  final Completer<GoogleMapController> _controller = Completer();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(7.117787, -73.115479),
    zoom: 8,
  );

  late final PropertyType selectedType;

  @override
  void initState() {
    selectedType = widget.propertyType;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1D1D1D),
        elevation: 0,
        centerTitle: true,
        title: InkWell(
          onTap: () {
            context.goNamed(LandingScreen.routeName);
          },
          child: const Text(
            'Homly',
            style: TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
        ),
      ),
      body: Row(
        children: [
          ResponsiveVisibility(
            hiddenConditions: [
              Condition.smallerThan(
                name: TABLET,
                value: size.width,
              ),
            ],
            child: SizedBox(
              width: size.width * 0.5,
              child: Consumer(
                builder: (context, ref, child) {
                  final propertiesState = ref.watch(propertiesProvider);
                  return GoogleMap(
                    initialCameraPosition: _kGooglePlex,
                    onMapCreated: _controller.complete,
                    markers: propertiesState.maybeWhen(
                      orElse: () => const {},
                      data: (properties) => properties
                          .where(
                        (element) => element.type == widget.propertyType,
                      )
                          .map((property) {
                        return Marker(
                          markerId: MarkerId(property.id),
                          position: LatLng(
                            double.parse(property.latitude),
                            double.parse(property.longitude),
                          ),
                        );
                      }).toSet(),
                    ),
                  );
                },
              ),
            ),
          ),
          SizedBox(
            width: ResponsiveValue(
              context,
              defaultValue: size.width * 0.5,
              conditionalValues: [
                Condition.smallerThan(
                  name: TABLET,
                  value: size.width,
                ),
              ],
            ).value,
            height: size.height,
            child: Consumer(
              builder: (context, ref, child) {
                final propertiesState = ref.watch(propertiesProvider);
                return propertiesState.when(
                  data: (properties) {
                    final filterProperties = properties
                        .where(
                          (element) => element.type == widget.propertyType,
                        )
                        .toList();
                    return GridView.builder(
                      shrinkWrap: true,
                      itemCount: filterProperties.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 1.5,
                      ),
                      itemBuilder: (context, index) {
                        return PropertyContainer(
                          property: filterProperties[index],
                        );
                      },
                    );
                  },
                  error: (_, __) {
                    return const Center(child: Text('Error'));
                  },
                  loading: () {
                    return GridView.builder(
                      shrinkWrap: true,
                      itemCount: 10,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 1.5,
                      ),
                      itemBuilder: (context, index) {
                        return Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            margin: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
