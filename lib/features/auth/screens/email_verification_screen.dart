import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:homly/features/auth/controllers/auth_controller.dart';
import 'package:homly/features/auth/controllers/email_verification_screen_controller.dart';
import 'package:homly/features/auth/infrastructure/repositories/auth_repository.dart';
import 'package:homly/features/home/screens/home_screen.dart';
import 'package:homly/features/landing/screens/landing_screen.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';

class EmailVerificationScreen extends ConsumerStatefulWidget {
  const EmailVerificationScreen({super.key});

  static const routePath = routeName;
  static const routeName = 'email-verification';

  @override
  ConsumerState<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState
    extends ConsumerState<EmailVerificationScreen> {
  final _stopWatchTimer = StopWatchTimer(mode: StopWatchMode.countDown);
  final CountdownController _controller = CountdownController();

  @override
  void dispose() async {
    super.dispose();
    await _stopWatchTimer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(userChangesProvider, (previous, next) {
      next.when(
          data: (user) {
            if (user?.emailVerified ?? false) {
              ref.read(isUserVerifiedProvider.notifier).state = true;
              context.goNamed(HomeScreen.routeName);
            }
          },
          error: (_, __) {},
          loading: () {});
    });
    final size = MediaQuery.of(context).size;
    bool isEnabled =
        _controller.isCompleted == null || _controller.isCompleted!;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        forceMaterialTransparency: true,
        title: InkWell(
          onTap: () {
            context.goNamed(LandingScreen.routeName);
          },
          child: Text(
            'HOMLY',
            style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                  letterSpacing: 5,
                ),
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Align(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  width: size.width * 0.3,
                  child: Column(
                    children: [
                      const Text(
                        'Verificación de correo',
                        style: TextStyle(fontSize: 22),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      Consumer(builder: (context, ref, child) {
                        return FilledButton(
                          onPressed: !isEnabled
                              ? null
                              : () {
                                  ref.invalidate(sendEmailVerificationProvider);
                                  _controller.restart();
                                  setState(() {});
                                },
                          child: SizedBox(
                            width: size.width * 0.1,
                            child: !isEnabled
                                ? const Center(
                                    child: SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator()),
                                  )
                                : const Text(
                                    'Enviar correo de verificación',
                                    style: TextStyle(fontSize: 16),
                                    textAlign: TextAlign.center,
                                  ),
                          ),
                        );
                      }),
                      Countdown(
                        controller: _controller,
                        seconds: 10,
                        build: (BuildContext context, double time) {
                          if (isEnabled) {
                            return const SizedBox.shrink();
                          }
                          return Text(
                              'Reenviar correo en ${time.toInt().toString()}');
                        },
                        onFinished: () {
                          ref
                              .read(authRepositoryProvider)
                              .currentUser!
                              .reload();
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
