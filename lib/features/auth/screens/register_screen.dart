import 'package:flutter/material.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:homly/features/auth/controllers/auth_controller.dart';
import 'package:homly/features/auth/domain/entities/user_data.dart';
import 'package:homly/features/auth/screens/email_verification_screen.dart';
import 'package:homly/features/auth/screens/login_screen.dart';
import 'package:homly/features/common/utils/functions.dart';
import 'package:homly/features/common/utils/validator_string.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:transparent_image/transparent_image.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({
    super.key,
  });

  static const routePath = '/$routeName';
  static const routeName = 'register';

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterFormState();
}

class _RegisterFormState extends ConsumerState<RegisterScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final repeatPasswordController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final pwdValidatorKey = GlobalKey();

  bool validPhoneNumber = false;
  bool validPassword = false;

  String countryValue = '';
  String stateValue = '';
  String cityValue = '';

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    ref.listen<AsyncValue<UserData?>>(
      authControllerProvider,
      (_, state) {
        state.when(
          data: (userData) {
            if (userData != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Register successful')),
              );
              context.goNamed(EmailVerificationScreen.routeName);
            }
          },
          error: (_, __) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                width: size.width * 0.4,
                behavior: SnackBarBehavior.floating,
                content: Text(
                  state.error.toString(),
                ),
              ),
            );
          },
          loading: () {},
        );
      },
    );

    return Scaffold(
      body: Row(
        children: [
          ResponsiveVisibility(
            hiddenConditions: [
              Condition.smallerThan(
                name: TABLET,
                value: size.width,
              ),
            ],
            child: Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                child: FadeInImage(
                  placeholder: MemoryImage(kTransparentImage),
                  image: Image.asset(
                    'assets/images/agent_register.jpg',
                  ).image,
                  fit: BoxFit.fitHeight,
                  height: size.height,
                ),
              ),
            ),
          ),
          Flexible(
            child: SingleChildScrollView(
              child: Align(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  width: ResponsiveValue(
                    context,
                    defaultValue: size.width * 0.4,
                    conditionalValues: [
                      Condition.smallerThan(
                        name: TABLET,
                        value: size.width * 0.7,
                      ),
                    ],
                  ).value,
                  child: Form(
                    key: formKey,
                    // autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      children: [
                        const Text(
                          'Registro',
                          style: TextStyle(fontSize: 22),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        ResponsiveRowColumn(
                          rowSpacing: 8,
                          columnSpacing: 16,
                          layout: ResponsiveBreakpoints.of(context)
                                  .smallerThan(DESKTOP)
                              ? ResponsiveRowColumnType.COLUMN
                              : ResponsiveRowColumnType.ROW,
                          children: [
                            ResponsiveRowColumnItem(
                              rowFlex: 1,
                              child: TextFormField(
                                controller: firstNameController,
                                decoration: const InputDecoration(
                                  hintText: 'Nombres',
                                ),
                                validator: (value) {
                                  if (value?.isEmpty ?? false) {
                                    return 'Por favor ingrese un valor';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            ResponsiveRowColumnItem(
                              rowFlex: 1,
                              child: TextFormField(
                                controller: lastNameController,
                                decoration: const InputDecoration(
                                  hintText: 'Apellidos',
                                ),
                                validator: (value) {
                                  if (value?.isEmpty ?? false) {
                                    return 'Por favor ingrese un valor';
                                  }
                                  return null;
                                },
                              ),
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: IntlPhoneField(
                            decoration: const InputDecoration(
                              labelText: 'Número de teléfono',
                              border: OutlineInputBorder(),
                            ),
                            initialCountryCode: 'CO',
                            onChanged: (phone) {
                              phoneController.text = phone.completeNumber;
                            },
                            disableLengthCheck: true,
                            validator: (value) {
                              if ((value?.number.length ?? 0) == 10 &&
                                  (value?.number.startsWith('3') ?? false)) {
                                validPhoneNumber = true;
                                return null;
                              } else {
                                validPhoneNumber = false;
                                return 'Por favor ingrese un número de teléfono válido';
                              }
                            },
                          ),
                        ),
                        TextFormField(
                          controller: emailController,
                          decoration: const InputDecoration(
                            hintText: 'Correo electrónico',
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            return validateEmail(value, context);
                          },
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        ResponsiveRowColumn(
                          rowCrossAxisAlignment: CrossAxisAlignment.start,
                          columnSpacing: 16,
                          rowSpacing: 8,
                          layout: ResponsiveBreakpoints.of(context)
                                  .smallerThan(DESKTOP)
                              ? ResponsiveRowColumnType.COLUMN
                              : ResponsiveRowColumnType.ROW,
                          children: [
                            ResponsiveRowColumnItem(
                              rowFlex: 1,
                              child: Column(
                                children: [
                                  TextFormField(
                                    controller: passwordController,
                                    decoration: const InputDecoration(
                                      hintText: 'Contraseña',
                                    ),
                                    obscureText: true,
                                  ),
                                  FlutterPwValidator(
                                    key: pwdValidatorKey,
                                    controller: passwordController,
                                    minLength: 6,
                                    uppercaseCharCount: 2,
                                    numericCharCount: 3,
                                    specialCharCount: 1,
                                    width: 400,
                                    height: 150,
                                    strings: ValidatorString(),
                                    onSuccess: () {
                                      validPassword = true;
                                    },
                                    onFail: () {
                                      validPassword = false;
                                    },
                                  ),
                                ],
                              ),
                            ),
                            ResponsiveRowColumnItem(
                              rowFlex: 1,
                              child: TextFormField(
                                controller: repeatPasswordController,
                                decoration: const InputDecoration(
                                  hintText: 'Repetir contraseña',
                                ),
                                obscureText: true,
                                validator: (value) {
                                  if (value != passwordController.text) {
                                    return 'Las contraseñas no coinciden';
                                  }
                                  return null;
                                },
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        FilledButton(
                          onPressed: ref.watch(authControllerProvider).isLoading
                              ? null
                              : () {
                                  if ((formKey.currentState?.validate() ??
                                          false) &&
                                      validPhoneNumber &&
                                      validPassword) {
                                    final userData = UserData(
                                      email: emailController.text,
                                      firstName: firstNameController.text,
                                      lastName: lastNameController.text,
                                      phoneNumber: phoneController.text,
                                      isAgent: true,
                                    );

                                    // ref.read(userDataProvider.notifier).state =
                                    //     userData;
                                    ref
                                        .read(authControllerProvider.notifier)
                                        .registerWithEmailAndPassword(
                                          emailController.text,
                                          passwordController.text,
                                          userData,
                                        );
                                  }
                                },
                          child: SizedBox(
                            width: ResponsiveValue(
                              context,
                              defaultValue: size.width * 0.1,
                              conditionalValues: [
                                Condition.smallerThan(
                                  name: DESKTOP,
                                  value: size.width * 0.3,
                                ),
                              ],
                            ).value,
                            child: ref.watch(authControllerProvider).isLoading
                                ? const Column(
                                    children: [
                                      SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(),
                                      ),
                                    ],
                                  )
                                : const Text(
                                    'Registrarse',
                                    style: TextStyle(fontSize: 16),
                                    textAlign: TextAlign.center,
                                  ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Divider(),
                        ),
                        Wrap(
                          alignment: WrapAlignment.center,
                          children: [
                            const Text(
                              '¿Ya tienes una cuenta? ',
                              style: TextStyle(color: Colors.black),
                            ),
                            InkWell(
                              onTap: () {
                                context.goNamed(LoginScreen.routeName);
                              },
                              child: const Text(
                                'Inicia sesión',
                                style: TextStyle(color: Colors.blue),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    passwordController.dispose();
    repeatPasswordController.dispose();

    super.dispose();
  }
}
