import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(child: _loadingScreen());
  }

  Widget _loadingScreen() {
    return new Container(
        margin: const EdgeInsets.only(top: 150.0),
        child: new Center(
            child: new Column(
          children: <Widget>[
            CircularProgressIndicator(strokeWidth: 4.0),
            new Container(
              padding: const EdgeInsets.all(12.0),
              child: new Text(
                'Espere',
                style:
                    new TextStyle(color: Colors.grey.shade500, fontSize: 16.0),
              ),
            )
          ],
        )));
  }
}
