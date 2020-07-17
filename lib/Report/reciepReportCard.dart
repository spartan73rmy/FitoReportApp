import 'package:LikeApp/Models/product.dart';
import 'package:flutter/material.dart';

class ReciepReportCard extends StatefulWidget {
  final Product data;
  ReciepReportCard(this.data, {Key key}) : super(key: key);

  @override
  _ReciepReportCardState createState() => _ReciepReportCardState(data);
}

class _ReciepReportCardState extends State<ReciepReportCard> {
  final Product data;

  _ReciepReportCardState(this.data);

  // Widget get reciepCard {}

  @override
  Widget build(BuildContext context) {
    return Container(
        child: new Card(
            child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
      ListTile(
          leading: const Icon(Icons.archive),
          title: RichText(
              text: TextSpan(
                  text: 'Producto: ',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Color(Colors.black.value)),
                  children: <TextSpan>[
                TextSpan(
                  text: '${data.name}',
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 18,
                      color: Color(Colors.black.value)),
                ),
              ])),
          subtitle: RichText(
            text: TextSpan(
              text: 'Cant: ',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(Colors.black45.value)),
              children: <TextSpan>[
                TextSpan(
                  text: '${data.cantity}',
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      color: Color(Colors.black.value)),
                ),
                TextSpan(
                  text: '     Concentracion: ',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(Colors.black45.value)),
                ),
                TextSpan(
                  text: '${data.concentration}%',
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      color: Color(Colors.black.value)),
                ),
                TextSpan(
                  text: '\nIngr. Activo: ',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(Colors.black45.value)),
                ),
                TextSpan(
                  text: '${data.iActive}',
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      color: Color(Colors.black.value)),
                ),
                TextSpan(
                  text: '\nIntervalo de seguridad: ',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(Colors.black45.value)),
                ),
                TextSpan(
                  text: '${data.securityInterval} Dias\n',
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      color: Color(Colors.black.value)),
                ),
              ],
            ),
          )),
      new ButtonBarTheme(
          data: ButtonBarThemeData(),
          // make buttons use the appropriate styles for cards
          child: new ButtonBar(children: <Widget>[
            new FlatButton(
              child: const Text('Editar'),
              onPressed: () {/* ... */},
            ),
            new FlatButton(
              child: const Text('Eliminar'),
              onPressed: () {/* ... */},
            )
          ]))
    ])));
  }
}
