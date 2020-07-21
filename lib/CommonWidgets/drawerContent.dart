import 'package:flutter/material.dart';

ListView drawerContent(BuildContext context) {
  return ListView(
    // Important: Remove any padding from the ListView.
    padding: EdgeInsets.zero,
    children: <Widget>[
      DrawerHeader(
        child: Icon(Icons.apps),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.blue,
        ),
      ),
      ListTile(
        leading: Icon(Icons.work),
        title: Text('Enviar reporte'),
        subtitle: Text.rich(
          TextSpan(
              text: "Reportes guardados localmente",
              style:
                  TextStyle(color: Color(Colors.black45.value), fontSize: 15)),
        ),
        onTap: () {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) => AddReport()),
          // );
          Navigator.pop(context);
        },
      ),
    ],
  );
}
