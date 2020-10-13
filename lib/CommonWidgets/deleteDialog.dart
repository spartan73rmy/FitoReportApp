import 'package:flutter/material.dart';

class DeleteDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Advertencia'),
      content: Text('Estas segur@ de desear eliminarlo'),
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
