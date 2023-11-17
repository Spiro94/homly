import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homly/bootstrap.dart';
import 'package:homly/config/router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_framework/responsive_framework.dart';

void main() async {
  runApp(
    UncontrolledProviderScope(
      container: await bootstrap(),
      child: const Homly(),
    ),
  );
}

class Homly extends ConsumerWidget {
  const Homly({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: {
          PointerDeviceKind.mouse,
          PointerDeviceKind.touch,
          PointerDeviceKind.stylus,
          PointerDeviceKind.unknown,
        },
      ),
      builder: (context, child) => ResponsiveBreakpoints.builder(
        child: child!,
        breakpoints: [
          const Breakpoint(start: 0, end: 450, name: MOBILE),
          const Breakpoint(start: 451, end: 800, name: TABLET),
          const Breakpoint(start: 801, end: 1920, name: DESKTOP),
          const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
        ],
      ),
      routerConfig: ref.watch(routerProvider),
      title: 'Homly',
      theme: FlexThemeData.light(
        colors: const FlexSchemeColor(
          primary: Colors.white,
          primaryContainer: Color(0xFFA0C2ED),
          secondary: Color(0xFFD26900),
          secondaryContainer: Color(0xFFFFD270),
          tertiary: Color(0xFF5C5C95),
          tertiaryContainer: Color(0xFFC8DBF8),
        ),
        useMaterial3: true,
        fontFamily: GoogleFonts.tienne().fontFamily,
      ),
      darkTheme: FlexThemeData.dark(
        scheme: FlexScheme.green,
        surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
        blendLevel: 13,
        subThemesData: const FlexSubThemesData(
          blendOnLevel: 20,
          useM2StyleDividerInM3: true,
        ),
        visualDensity: FlexColorScheme.comfortablePlatformDensity,
        useMaterial3: true,
        swapLegacyOnMaterial3: true,
        fontFamily: GoogleFonts.raleway().fontFamily,
      ),
      themeMode: ThemeMode.light,
    );
  }
}
