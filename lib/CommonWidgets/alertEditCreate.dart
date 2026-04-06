import 'package:flutter/material.dart';

class SelectCreateEdit extends StatelessWidget {
  final String? tittle;
  final String? text;
  const SelectCreateEdit({super.key, this.tittle, this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: AlertDialog(
        title: Text(tittle ?? ''),
        content: Text(text ?? ''),
        actions: [
          TextButton(
            child: const Text("Crear"),
            onPressed: () {
              Navigator.pop(context, true);
            },
          ),
          TextButton(
            child: const Text("Editar"),
            onPressed: () {
              Navigator.pop(context, false);
            },
          )
        ],
      ),
    );
  }
}
