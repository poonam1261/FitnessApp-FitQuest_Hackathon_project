import 'package:fitness/services/auth/auth_service.dart';
import 'package:fitness/view/home/home_view.dart';
import 'package:fitness/view/login/login_view.dart';
import 'package:fitness/view/login/signup_view.dart';
import 'package:fitness/view/login/verify_email_view.dart';
import 'package:fitness/view/on_boarding/started_view.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "Fit Quest",
    home: const MyApp(),
    routes: {
      '/login/': (context) => const LoginView(),
      '/register/': (context) => const SignUpView(),
      '/home/': (context) => const HomeView(),
      '/verify-email/': (context) => const VerifyEmailView(),
    },
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.firebase().initialize(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = AuthService.firebase().currentUser;
            if (user != null) {
              if (user.isEmailVerified) {
                return const LoginView();
              } else {
                return const VerifyEmailView();
              }
            } else {
              return const StartedView();
            }
          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}
