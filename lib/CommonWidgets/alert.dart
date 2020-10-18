import 'package:flutter/material.dart';

alertDiag(BuildContext context, String tittle, String text) {
  // set up the button
  Widget okButton = FlatButton(
    child: Text("Aceptar"),
    onPressed: () {
      Navigator.of(context).pop(true); // dismiss dialog
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text(tittle),
    content: Text(text),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
