import 'package:flutter/material.dart';

class AproveUser extends StatefulWidget {
  const AproveUser({super.key});

  @override
  _AproveUserState createState() => _AproveUserState();
}

class _AproveUserState extends State<AproveUser> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Advertencia'),
      content: const Text('Desea aprobar a este usuario?'),
      actions: <Widget>[
        TextButton(
          child: const Text('Si'),
          onPressed: () {
            Navigator.of(context).pop(true);
          },
        ),
        TextButton(
          child: const Text('No'),
          onPressed: () {
            Navigator.of(context).pop(false);
          },
        ),
      ],
    );
  }
}
