// ignore_for_file: avoid_public_notifier_properties

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:homly/features/auth/controllers/auth_controller.dart';
import 'package:homly/features/auth/screens/email_verification_screen.dart';
import 'package:homly/features/auth/screens/login_screen.dart';
import 'package:homly/features/auth/screens/register_screen.dart';
import 'package:homly/features/common/domain/enums/enum.dart';
import 'package:homly/features/common/screens/error_screen.dart';
import 'package:homly/features/create_property/screens/create_property_screen.dart';
import 'package:homly/features/home/screens/home_screen.dart';
import 'package:homly/features/landing/screens/landing_screen.dart';
import 'package:homly/features/property/property_page.dart';
import 'package:homly/features/property_visualizer/screens/property_visualizer_screen.dart';
import 'package:homly/features/search/screens/search_screen.dart';

import 'dart:async';

/// Route observer to use with RouteAware
final RouteObserver<ModalRoute<void>> routeObserver =
    RouteObserver<ModalRoute<void>>();

/// A [Listenable] implemented via an [AsyncNotifier].
/// [GoRouter] accepts a [Listenable] to refresh its internal state, so this is kinda mandatory.
///
/// An alternative would be to register a dependency via an Inherited Widget, but that's kinda a no-go for Riverpod.
///
/// To sync Riverpod' state with this Listener, we simply accept and call a single callback on authentication change.
/// Obviously, more logic could be implemented here, this is meant to be a simple example.
///
/// I kinda like this example, as this allows to centralize global redirecting logic in one class.
///
/// SIDE NOTES.
/// This might look overcomplicated at a first glance;
/// Instead, this method aims to follow some good some good practices:
///   1. It doesn't require us to pass [Ref](s) around
///   2. It works as a complete replacement for [ChangeNotifier], as it still implements [Listenable]
///   3. It allows for listening to multiple providers, or add more logic if needed

class RouterListenableNotifier extends AsyncNotifier<void>
    implements Listenable {
  VoidCallback? _routerListener;
  bool _isAuth = false; // Useful for our global redirect function
  bool _isVerified = false;
  @override
  FutureOr<void> build() {
    // One could watch more providers and write logic accordingly

    _isAuth = ref.watch(authControllerProvider).maybeWhen(data: (value) {
      return value != null ? true : false;
    }, orElse: () {
      return false;
    });

    _isVerified = ref.watch(isUserVerifiedProvider);

    ref.listenSelf((_, __) {
      // One could write more conditional logic for when to call redirection
      if (state.isLoading) return;
      _routerListener?.call();
    });
  }

  /// Redirects the user when our authentication changes
  String? redirect(BuildContext context, GoRouterState state) {
    if (this.state.isLoading || this.state.hasError) return null;

    final goingToLogin = state.name?.contains(LoginScreen.routePath) ?? false;
    final goingToHome = state.name == HomeScreen.routePath;
    final goingToHomeOrBeyond =
        state.name?.startsWith(HomeScreen.routePath) ?? false;

    if (!_isAuth && goingToHomeOrBeyond) {
      return state.namedLocation(LoginScreen.routeName);
    }

    if (_isAuth && (goingToLogin || goingToHome)) {
      if (_isVerified) {
        return state.namedLocation(HomeScreen.routeName);
      }
      return state.namedLocation(EmailVerificationScreen.routeName);
    }

    return null;
  }

  List<GoRoute> get routes => [
        GoRoute(
          path: LandingScreen.routePath,
          name: LandingScreen.routeName,
          builder: (context, state) => const LandingScreen(),
          routes: [
            GoRoute(
              path: SearchScreen.routePath,
              name: SearchScreen.routeName,
              builder: (context, state) => SearchScreen(
                  propertyType: PropertyType.values.firstWhere((element) =>
                      element.name.toString() ==
                      state.pathParameters['propertyType'])),
            ),
            GoRoute(
              path: PropertyPage.routePath,
              name: PropertyPage.routeName,
              builder: (context, state) => PropertyPage(
                propertyId: state.pathParameters['id'] as String,
              ),
            ),
          ],
        ),
        GoRoute(
          path: LoginScreen.routePath,
          name: LoginScreen.routeName,
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: RegisterScreen.routePath,
          name: RegisterScreen.routeName,
          builder: (context, state) => const RegisterScreen(),
          routes: [
            GoRoute(
              path: EmailVerificationScreen.routePath,
              name: EmailVerificationScreen.routeName,
              builder: (context, state) => const EmailVerificationScreen(),
            ),
          ],
        ),
        GoRoute(
          path: HomeScreen.routePath,
          name: HomeScreen.routeName,
          builder: (context, state) => const HomeScreen(),
          routes: [
            GoRoute(
              path: CreatePropertyScreen.routePath,
              name: CreatePropertyScreen.routeName,
              builder: (context, state) => const CreatePropertyScreen(),
            ),
          ],
        ),
        GoRoute(
          path: PropertyVisualizerScreen.routePath,
          name: PropertyVisualizerScreen.routeName,
          builder: (context, state) => PropertyVisualizerScreen(
            name: state.pathParameters['name'] as String,
          ),
        ),
      ];

  @override
  void addListener(VoidCallback listener) {
    _routerListener = listener;
  }

  @override
  void removeListener(VoidCallback listener) {
    _routerListener = null;
  }
}

final routerNotifier = AsyncNotifierProvider<RouterListenableNotifier, void>(
    RouterListenableNotifier.new);

final key = GlobalKey<NavigatorState>(debugLabel: 'debug-router-key');

final routerProvider = Provider.autoDispose<GoRouter>((ref) {
  // router notifier
  final notifier = ref.watch(routerNotifier.notifier);

  return GoRouter(
    navigatorKey: key,
    refreshListenable: notifier,
    debugLogDiagnostics: true,
    // initialLocation: '/property_visualizer/property1',
    routes: notifier.routes,
    redirect: notifier.redirect,
    errorBuilder: (context, state) =>
        ErrorScreen(message: state.error.toString()),
  );
});
