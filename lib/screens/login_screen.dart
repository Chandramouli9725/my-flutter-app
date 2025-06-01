import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:lottie/lottie.dart';
import 'package:my_flutter_app/services/auth_services.dart';

import '../constants.dart';
import '../controllers/simple_ui_controller.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController nameController = TextEditingController();

  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  String currentPage = 'SignUp';

  SimpleUIController simpleUIController = Get.put(SimpleUIController());

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    SimpleUIController simpleUIController = Get.find<SimpleUIController>();

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        body: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth > 600) {
              return Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: RotatedBox(
                      quarterTurns: 3,
                      child: Lottie.asset(
                        'assets/image1.json',
                        height: size.height * 0.3,
                        width: double.infinity,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  SizedBox(width: size.width * 0.06),
                  Expanded(
                    flex: 5,
                    child: _buildMainBody(size, simpleUIController, context),
                  ),
                ],
              );
            } else {
              return Center(
                child: _buildMainBody(size, simpleUIController, context),
              );
            }
          },
        ),
      ),
    );
  }

  /// Main Body
  Widget _buildMainBody(
    Size size,
    SimpleUIController simpleUIController,
    BuildContext context,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment:
          size.width > 600 ? MainAxisAlignment.center : MainAxisAlignment.start,
      children: [
        size.width > 600
            ? Container()
            : Lottie.asset(
              'assets/image2.json',
              height: size.height * 0.2,
              width: size.width,
              fit: BoxFit.fill,
            ),
        SizedBox(height: size.height * 0.03),

        Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Text(
            currentPage == 'SignUp'
                ? 'Sign Up'
                : currentPage == 'Login'
                ? "Login"
                : "Forgot Password",
            style: kLoginTitleStyle(size),
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Text(
            currentPage == 'SignUp'
                ? 'Create Account'
                : currentPage == 'Login'
                ? "Welcome back"
                : "Enter email",
            style: kLoginSubtitleStyle(size),
          ),
        ),
        SizedBox(height: size.height * 0.03),

        Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                if (currentPage == 'SignUp') ...[
                  /// Username
                  TextFormField(
                    style: kTextFormFieldStyle(),
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.person),
                      hintText: 'Username',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                    ),

                    controller: nameController,
                    // The validator receives the text that the user has entered.
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter username';
                      } else if (value.length < 4) {
                        return 'at least enter 4 characters';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: size.height * 0.02),
                ],

                /// Email
                TextFormField(
                  style: kTextFormFieldStyle(),
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.person),
                    hintText: 'Email ID',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                  ),
                  controller: emailController,
                  // The validator receives the text that the user has entered.
                  validator: (value) {
                    bool emailValid = RegExp(
                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                    ).hasMatch(value.toString());

                    if (value == null || value.isEmpty) {
                      return 'Please enter a valid email id';
                    } else if (value.length < 4) {
                      return 'at least enter 4 characters';
                    } else if (!emailValid) {
                      return 'Please enter a valid email id';
                    }
                    return null;
                  },
                ),
                SizedBox(height: size.height * 0.02),

                if (currentPage != 'forgot_password') ...[
                  /// password
                  Obx(
                    () => TextFormField(
                      style: kTextFormFieldStyle(),
                      controller: passwordController,
                      obscureText: simpleUIController.isObscure.value,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.lock_open),
                        suffixIcon: IconButton(
                          icon: Icon(
                            simpleUIController.isObscure.value
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            simpleUIController.isObscureActive();
                          },
                        ),
                        hintText: 'Password',
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                      ),
                      // The validator receives the text that the user has entered.
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        } else if (value.length < 7) {
                          return 'at least enter 6 characters';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: size.height * 0.02),
                ],

                /// Login Button
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        Colors.deepPurpleAccent,
                      ),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                    onPressed: () async {
                      String errorMessage = '';
                      // Validate returns true if the form is valid, or false otherwise.
                      if (_formKey.currentState!.validate()) {
                        if (currentPage == 'SignUp') {
                          String errorMessage = '';
                          debugPrint(
                            'the email and pwd ${emailController.text.trim()} and ${passwordController.text.trim()}',
                          );
                          AuthServices().blockScreen(context);
                          final credential = await AuthServices().signUp(
                            nameController.text.trim(),
                            emailController.text.trim(),
                            passwordController.text.trim(),
                            context,
                          );
                          if (credential != null) {
                            if (credential.runtimeType ==
                                FirebaseAuthException) {
                              errorMessage = credential.code;
                            } else {
                              errorMessage =
                                  'An error has occurred. Please try again later';
                            }
                            showDialog(
                              context: context,
                              builder:
                                  (context) => AlertDialog(
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Ok'),
                                      ),
                                    ],
                                    title: const Text('Login error'),
                                    content: Text(
                                      credential.runtimeType ==
                                              FirebaseAuthException
                                          ? AuthServices()
                                              .getFirebaseAuthExceptionErrorMessages(
                                                errorMessage,
                                              )
                                          : errorMessage,
                                    ),
                                  ),
                            );
                          }
                        } else if (currentPage == 'Login') {
                          debugPrint(
                            'the email and pwd ${emailController.text.trim()} and ${passwordController.text.trim()}',
                          );
                          AuthServices().blockScreen(context);
                          final credential = await AuthServices().login(
                            emailController.text.trim(),
                            passwordController.text.trim(),
                            context,
                          );
                          if (credential != null) {
                            if (credential.runtimeType ==
                                FirebaseAuthException) {
                              errorMessage = credential.code;
                            } else {
                              errorMessage =
                                  'An error has occurred. Please try again later';
                            }
                            Navigator.pop(context);
                            showDialog(
                              context: context,
                              builder:
                                  (context) => AlertDialog(
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Ok'),
                                      ),
                                    ],
                                    title: const Text('Login error'),
                                    content: Text(
                                      credential.runtimeType ==
                                              FirebaseAuthException
                                          ? AuthServices()
                                              .getFirebaseAuthExceptionErrorMessages(
                                                errorMessage,
                                              )
                                          : errorMessage,
                                    ),
                                  ),
                            );
                          }
                        } else {
                          await auth.sendPasswordResetEmail(
                            email: emailController.text.trim(),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Password reset mail sent'),
                            ),
                          );
                        }
                      }
                    },
                    child: Text(
                      currentPage == 'SignUp'
                          ? 'Sign Up'
                          : currentPage == 'Login'
                          ? 'Login'
                          : 'Send email',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.03),

                /// Navigate To Login Screen
                GestureDetector(
                  onTap: () {
                    setState(() {
                      nameController.clear();
                      emailController.clear();
                      passwordController.clear();
                      _formKey.currentState?.reset();
                      currentPage =
                          currentPage == 'SignUp' ? 'Login' : 'SignUp';
                    });
                    simpleUIController.isObscure.value = true;
                  },
                  child: RichText(
                    text: TextSpan(
                      text:
                          currentPage == 'SignUp'
                              ? 'Already have an account?'
                              : 'Don\'t have an account?',
                      style: kHaveAnAccountStyle(size),
                      children: [
                        TextSpan(
                          text: currentPage == 'SignUp' ? " Login" : " Sign up",
                          style: kLoginOrSignUpTextStyle(size),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: size.height * 0.03),

                /// Forgot Password
                GestureDetector(
                  onTap: () async {
                    setState(() {
                      if (currentPage != 'forgot_password') {
                        currentPage = 'forgot_password';
                      } else {
                        currentPage = 'SignUp';
                      }
                    });
                  },
                  child: RichText(
                    text: TextSpan(
                      text: 'Forgot Password?',
                      style: kLoginOrSignUpTextStyle(size),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
