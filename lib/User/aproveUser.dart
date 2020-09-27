import 'package:flutter/material.dart';

class AproveUser extends StatefulWidget {
  AproveUser({Key key}) : super(key: key);

  @override
  _AproveUserState createState() => _AproveUserState();
}

class _AproveUserState extends State<AproveUser> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Advertencia'),
      content: Text('Desea aprobar a este usuario?'),
      actions: <Widget>[
        FlatButton(
          child: Text('Si'),
          onPressed: () {
            Navigator.of(context).pop(true);
          },
        ),
        FlatButton(
          child: Text('No'),
          onPressed: () {
            Navigator.of(context).pop(false);
          },
        ),
      ],
    );
  }
}
