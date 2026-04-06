import '../Models/reportData.dart';
import 'package:flutter/material.dart';

class ListTempReportCard extends StatefulWidget {
  final ReportData data;
  const ListTempReportCard(this.data, {super.key});

  @override
  _ListTempReportCardState createState() => _ListTempReportCardState(this.data);
}

class _ListTempReportCardState extends State<ListTempReportCard> {
  final ReportData data;

  _ListTempReportCardState(this.data);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Card(
            child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
      ListTile(
          leading: const Icon(Icons.archive),
          title: RichText(
              text: TextSpan(
                  text: 'Productor: ',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.black),
                  children: <TextSpan>[
                TextSpan(
                  text: '${data.productor ?? ''}',
                  style: const TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 18,
                      color: Colors.black),
                ),
              ])),
          subtitle: RichText(
            text: TextSpan(
              text: 'Predio: ',
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black45),
              children: <TextSpan>[
                TextSpan(
                  text: '${data.predio ?? ''}',
                  style: const TextStyle(
                      fontWeight: FontWeight.normal,
                      color: Colors.black),
                ),
                const TextSpan(
                  text: '\nUbicacion: ',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black45),
                ),
                TextSpan(
                  text: '${data.ubicacion ?? ''}',
                  style: const TextStyle(
                      fontWeight: FontWeight.normal,
                      color: Colors.black),
                ),
                const TextSpan(
                  text: '\nLugar: ',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black45),
                ),
                TextSpan(
                  text: '${data.lugar ?? ''}',
                  style: const TextStyle(
                      fontWeight: FontWeight.normal,
                      color: Colors.black),
                ),
                const TextSpan(
                  text: '\nObservaciones: ',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black45),
                ),
                TextSpan(
                  text: '${data.observaciones ?? ''}\n',
                  style: const TextStyle(
                      fontWeight: FontWeight.normal,
                      color: Colors.black),
                ),
              ],
            ),
          )),
      const Divider(
        height: 2.0,
      ),
    ])));
  }
}
