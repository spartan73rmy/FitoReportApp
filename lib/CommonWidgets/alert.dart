import 'package:flutter/material.dart';

alertDiag(BuildContext context, String tittle, String text) {
  Widget okButton = TextButton(
    child: const Text("Aceptar"),
    onPressed: () {
      Navigator.of(context).pop(true);
    },
  );

  AlertDialog alert = AlertDialog(
    title: Text(tittle),
    content: Text(text),
    actions: [
      okButton,
    ],
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
