import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:homly/features/auth/controllers/auth_controller.dart';
import 'package:homly/features/auth/screens/register_screen.dart';
import 'package:homly/features/landing/screens/landing_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static const routePath = '/$routeName';
  static const routeName = 'login';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
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
                        'Iniciar sesión en Homly',
                        style: TextStyle(fontSize: 22),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      TextFormField(
                        controller: emailController,
                        decoration: const InputDecoration(
                          hintText: 'Correo electrónico',
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      TextFormField(
                        controller: passwordController,
                        decoration: const InputDecoration(
                          hintText: 'Contraseña',
                        ),
                        obscureText: true,
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Consumer(builder: (context, ref, child) {
                        final authState = ref.watch(authControllerProvider);
                        return FilledButton(
                          onPressed: authState.isLoading
                              ? null
                              : () {
                                  ref
                                      .read(authControllerProvider.notifier)
                                      .signInWithEmailAndPassword(
                                        emailController.text,
                                        passwordController.text,
                                      );
                                },
                          child: SizedBox(
                            width: size.width * 0.1,
                            child: authState.isLoading
                                ? const Center(
                                    child: SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator()),
                                  )
                                : const Text(
                                    'Iniciar sesión',
                                    style: TextStyle(fontSize: 16),
                                    textAlign: TextAlign.center,
                                  ),
                          ),
                        );
                      }),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Divider(),
                      ),
                      Wrap(
                        alignment: WrapAlignment.center,
                        children: [
                          const Text(
                            '¿No tienes una cuenta? ',
                            style: TextStyle(color: Colors.black),
                          ),
                          InkWell(
                            onTap: () {
                              context.pushNamed(RegisterScreen.routeName);
                            },
                            child: const Text(
                              'Regístrate',
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
                        ],
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
