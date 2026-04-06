import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {
  final String? text;
  final VoidCallback? onPressed;
  const LoginButton({super.key, this.text, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 12.0),
        child: Material(
            elevation: 5.0,
            child: MaterialButton(
                color: Theme.of(context).primaryColor,
                height: 42.0,
                child: Text('${this.text ?? "Button"}',
                    style: const TextStyle(color: Colors.white)),
                onPressed: onPressed)));
  }
}
