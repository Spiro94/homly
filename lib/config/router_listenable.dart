import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:homly/features/auth/controllers/auth_controller.dart';
import 'package:homly/features/auth/screens/login_screen.dart';
import 'package:homly/features/home/screens/home_screen.dart';

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
  @override
  FutureOr<void> build() {
    // One could watch more providers and write logic accordingly

    _isAuth = ref.watch(authControllerProvider).maybeWhen(data: (value) {
      return value != null ? true : false;
    }, orElse: () {
      return false;
    });

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
      // if (userVerified) {
      return state.namedLocation(HomeScreen.routeName);
      // }
      // return state.namedLocation(EmailVerificationScreen.routeName);
    }

    return null;
  }

  @override
  void addListener(VoidCallback listener) {
    _routerListener = listener;
  }

  @override
  void removeListener(VoidCallback listener) {
    _routerListener = null;
  }
}
