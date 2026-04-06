import 'package:flutter/material.dart';

class PasswordField extends StatelessWidget {
  final TextEditingController? passwordController;
  final bool? obscureText;
  final String? passwordError;
  final VoidCallback? togglePassword;
  const PasswordField(
      {super.key,
      this.passwordController,
      this.obscureText,
      this.passwordError,
      this.togglePassword});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(bottom: 16.0),
        child: TextField(
            controller: passwordController,
            obscureText: obscureText ?? false,
            decoration: InputDecoration(
                errorText: passwordError,
                contentPadding: const EdgeInsets.symmetric(vertical: 4.0),
                labelText: 'Contraseña',
                suffixIcon: GestureDetector(
                  onTap: togglePassword,
                  child: const Icon(Icons.remove_red_eye),
                ))));
  }
}
