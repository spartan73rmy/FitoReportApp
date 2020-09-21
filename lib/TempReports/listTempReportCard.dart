import 'package:LikeApp/Models/producto.dart';
import 'package:flutter/material.dart';

class ListTempReportCard extends StatefulWidget {
  final Producto data;
  ListTempReportCard(this.data, {Key key}) : super(key: key);

  @override
  _ListTempReportCardState createState() => _ListTempReportCardState(data);
}

class _ListTempReportCardState extends State<ListTempReportCard> {
  final Producto data;

  _ListTempReportCardState(this.data);

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
                  text: '${data.nombre}',
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
                  text: '${data.cantidad}',
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
                  text: '${data.concentracion}%',
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
                  text: '${data.ingredienteActivo}',
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
                  text: '${data.intervaloSeguridad} Dias\n',
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      color: Color(Colors.black.value)),
                ),
              ],
            ),
          )),
    ])));
  }
}
