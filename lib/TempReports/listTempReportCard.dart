import '../Models/reportData.dart';
import 'package:flutter/material.dart';

class ListTempReportCard extends StatefulWidget {
  final ReportData data;
  ListTempReportCard(this.data, {Key key}) : super(key: key);

  @override
  _ListTempReportCardState createState() => _ListTempReportCardState(this.data);
}

class _ListTempReportCardState extends State<ListTempReportCard> {
  final ReportData data;

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
                  text: 'Productor: ',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Color(Colors.black.value)),
                  children: <TextSpan>[
                TextSpan(
                  text: '${data.productor}',
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 18,
                      color: Color(Colors.black.value)),
                ),
              ])),
          subtitle: RichText(
            text: TextSpan(
              text: 'Predio: ',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(Colors.black45.value)),
              children: <TextSpan>[
                TextSpan(
                  text: '${data.predio}',
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      color: Color(Colors.black.value)),
                ),
                TextSpan(
                  text: '\nUbicacion: ',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(Colors.black45.value)),
                ),
                TextSpan(
                  text: '${data.ubicacion}',
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      color: Color(Colors.black.value)),
                ),
                TextSpan(
                  text: '\nLugar: ',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(Colors.black45.value)),
                ),
                TextSpan(
                  text: '${data.lugar}',
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      color: Color(Colors.black.value)),
                ),
                TextSpan(
                  text: '\nObservaciones: ',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(Colors.black45.value)),
                ),
                TextSpan(
                  text: '${data.observaciones}\n',
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      color: Color(Colors.black.value)),
                ),
              ],
            ),
          )),
      new Divider(
        height: 2.0,
      ),
    ])));
  }
}
