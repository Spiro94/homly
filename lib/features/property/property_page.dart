import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:homly/features/common/widgets/embedded_view.dart';
import 'package:homly/features/landing/screens/landing_screen.dart';
import 'package:homly/features/property/controllers/property_get_controller.dart';
import 'package:responsive_framework/responsive_framework.dart';

class PropertyPage extends StatefulWidget {
  const PropertyPage({super.key, required this.propertyId});

  final String propertyId;

  static const routePath = '$routeName/:id';
  static const routeName = 'property';

  @override
  State<PropertyPage> createState() => _PropertyPageState();
}

class _PropertyPageState extends State<PropertyPage> {
  bool clicked = false;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        elevation: 0,
        centerTitle: true,
        title: InkWell(
          onTap: () {
            context.goNamed(LandingScreen.routeName);
          },
          child: Image.asset(
            'assets/logos/homly-04-resized.png',
            height: 40,
            filterQuality: FilterQuality.high,
          ),
        ),
      ),
      body: Consumer(
        builder: (context, ref, child) {
          final propertyState = ref.watch(propertyProvider(widget.propertyId));
          return propertyState.maybeWhen(data: (property) {
            return ListView(
              children: [
                SizedBox(
                  height: size.height * 0.9,
                  child: clicked
                      ? EmbeddedView(
                          link:
                              '${property.matterportLink}&nt=0&play=1&qs=1', //Opens in same browser tab - Plays automatically - Does not show the dollhouse view
                          radius: 0,
                        )
                      : Container(
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                            image: AssetImage(
                              'assets/images/background_view.png', //TODO: Save the image in firebase as the background view
                            ),
                            fit: BoxFit.fill,
                          )),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              //Black overlay
                              Positioned.fill(
                                child: Container(
                                  color: Colors.black.withOpacity(0.3),
                                ),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset('assets/images/huspy-logo.png'),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  Text(
                                    property.name,
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayLarge!
                                        .copyWith(color: Colors.white),
                                  ),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        clicked = true;
                                      });
                                    },
                                    icon: const FaIcon(
                                      FontAwesomeIcons.circlePlay,
                                      color: Colors.white,
                                      size: 100,
                                    ),
                                  ),
                                  Text(
                                    'Click to Start Tour',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(color: Colors.white),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                  color: Colors.white,
                  child: ResponsiveRowColumn(
                    layout:
                        ResponsiveBreakpoints.of(context).smallerThan(DESKTOP)
                            ? ResponsiveRowColumnType.COLUMN
                            : ResponsiveRowColumnType.ROW,
                    children: [
                      ResponsiveRowColumnItem(
                        rowFlex: 4,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              children: [
                                Text(
                                  property.address,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  '${property.city}, ${property.state}'
                                  ' - ${property.zipCode}',
                                  style: const TextStyle(
                                      fontSize: 16, color: Colors.grey),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                Wrap(
                                  runSpacing: 16,
                                  spacing: 24,
                                  children: [
                                    Column(
                                      children: [
                                        const Text(
                                          r'$1,585,000',
                                          style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          property.type.name,
                                          style: const TextStyle(
                                            fontSize: 20,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Row(
                                          children: [
                                            const FaIcon(
                                              FontAwesomeIcons.bed,
                                              size: 20,
                                            ),
                                            const SizedBox(
                                              width: 16,
                                            ),
                                            Text(
                                              property.rooms.toString(),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 4,
                                        ),
                                        const Text(
                                          'Bedrooms',
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Row(
                                          children: [
                                            const FaIcon(
                                              FontAwesomeIcons.bath,
                                              size: 20,
                                            ),
                                            const SizedBox(
                                              width: 16,
                                            ),
                                            Text(
                                              property.bathrooms.toString(),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 4,
                                        ),
                                        const Text(
                                          'Full Bathrooms',
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      ResponsiveRowColumnItem(
                        rowFlex: 2,
                        child: Row(
                          mainAxisAlignment: ResponsiveBreakpoints.of(context)
                                  .smallerThan(DESKTOP)
                              ? MainAxisAlignment.center
                              : MainAxisAlignment.start,
                          children: [
                            Column(
                              children: [
                                const Text(
                                  'Listing Agent',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                // Assets.images.agent.image(
                                //   height: size.height * 0.10,
                                // ),
                                const SizedBox(
                                  height: 16,
                                ),
                                ElevatedButton.icon(
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all(Colors.green),
                                  ),
                                  onPressed: () {},
                                  icon: const Icon(Icons.send),
                                  label: const Text('Send message'),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            );
          }, orElse: () {
            return const Center(
              child: CircularProgressIndicator(),
            );
          });
        },
      ),
    );
  }
}
