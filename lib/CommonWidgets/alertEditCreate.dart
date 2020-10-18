import 'package:flutter/material.dart';

class SelectCreateEdit extends StatelessWidget {
  final String tittle, text;
  const SelectCreateEdit({Key key, this.tittle, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: AlertDialog(
        title: Text(tittle),
        content: Text(text),
        actions: [
          FlatButton(
            child: Text("Crear"),
            onPressed: () {
              Navigator.pop(context, true);
            },
          ),
          FlatButton(
            child: Text("Editar"),
            onPressed: () {
              Navigator.pop(context, false);
            },
          )
        ],
      ),
    );
  }
}
