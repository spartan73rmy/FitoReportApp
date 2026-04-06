import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final TextEditingController? textController;
  final TextInputType? input;
  final String? error;
  final String? label;
  InputField(this.label, this.textController, this.error, this.input);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(bottom: 16.0),
        child: TextField(
            keyboardType: input,
            controller: textController,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(vertical: 4.0),
              errorText: error,
              labelText: label,
            )));
  }
}
