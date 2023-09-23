import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flash_chat/screens/registration_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static const id = 'login_screen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? email;
  String? password;
  final _auth = FirebaseAuth.instance;

  Future<bool> userLogin() async {
    try {
      await _auth.signInWithEmailAndPassword(
          email: email!, password: password!);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ProgressHUD(
        child: Container(
          decoration: const BoxDecoration(
            gradient: kGradientContainerStyle,
          ),
          child: Builder(
            builder: (context) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Column(
                    children: [
                      Image(
                        image: AssetImage('images/login2.png'),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextField(
                        keyboardType: TextInputType.emailAddress,
                        textAlign: TextAlign.center,
                        onChanged: (value) {
                          email = value.trim();
                        },
                        style: kTextFieldTextStyle,
                        decoration: kTextFieldDecoration,
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      TextField(
                          obscureText: true,
                          textAlign: TextAlign.center,
                          onChanged: (value) {
                            password = value.trim();
                          },
                          style: kTextFieldTextStyle,
                          decoration: kTextFieldDecoration.copyWith(
                            hintText: 'Enter your password',
                          )),
                      const SizedBox(
                        height: 24.0,
                      ),
                      ElevatedButton(
                        style: kButtonDesign,
                        // color: Colors.lightBlueAccent,
                        onPressed: () async {
                          final progress = ProgressHUD.of(context);
                          progress?.show();
                          if (await userLogin() == true) {
                            Navigator.pushNamed(context, ChatScreen.id);
                          } else {
                            showMessage(
                                context, 'An error has occur unable to login');
                          }
                          progress?.dismiss();
                        },
                        child: const Text('Log in', style: kButtonTextDesign),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Don't have an account yet?",
                            style: TextStyle(color: Colors.white),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                  context, RegistrationScreen.id);
                            },
                            child: const Text('Sign up'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
