// ignore_for_file: use_build_context_synchronously

import 'package:fitness/common/colo_extension.dart';
import 'package:fitness/services/auth/auth_service.dart';
import 'package:flutter/material.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: TColor.primaryColor1,
          title: const Text(
        'Verify Email',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      )),
      body: Column(
        children: [
          const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "We've sent you an email for verification.",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Text(
                "Click to send again",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          FilledButton(
            onPressed: () async {
              await AuthService.firebase().sendEmailVerification();
            },
            child: const Text('Send Email Verification'),
          ),
          const SizedBox(
            height: 10,
          ),
          FilledButton(
            onPressed: () async {
              await AuthService.firebase().logOut();
              Navigator.of(context).pushNamedAndRemoveUntil(
                '/login/',
                (route) => false,
              );
            },
            child: const Text('If Verified,then Login here'),
          )
        ],
      ),
    );
  }
}
