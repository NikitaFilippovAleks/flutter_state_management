import 'package:flutter/material.dart';
import 'package:vanillacontacts_course/bloc/notes/strings.dart';

class PasswordTextField extends StatelessWidget {
  final TextEditingController passwordController;

  const PasswordTextField({super.key, required this.passwordController});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: passwordController,
      obscureText: true,
      decoration: const InputDecoration(
        hintText: enterYourEmailHere,
      ),
    );
  }
}
