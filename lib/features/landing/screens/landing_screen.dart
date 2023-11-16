import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:homly/features/landing/widgets/footer_container.dart';
import 'package:homly/features/landing/widgets/homly_drawer.dart';
import 'package:homly/features/landing/widgets/main_container.dart';
import 'package:homly/features/landing/widgets/vision_container.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  static const routePath = '/';
  static const routeName = 'landing';

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  final dataKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      backgroundColor: const Color(0xFF1D1D1D),
      key: scaffoldKey,
      endDrawer: const HomlyDrawer(),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1D1D1D),
        automaticallyImplyLeading: false,
        elevation: 0,
        centerTitle: true,
        actions: [Container()],
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            MainContainer(
              onButtonPressed: () {
                scaffoldKey.currentState?.openEndDrawer();
              },
            ),
            VisionContainer(key: dataKey),
            const FooterContainer()
          ],
        ),
      ),
    );
  }
}
