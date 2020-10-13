import 'package:LikeApp/Models/producto.dart';
import 'package:LikeApp/CommonWidgets/productDialog.dart';
import 'package:flutter/material.dart';

class ReciepReportCard extends StatefulWidget {
  final Producto data;
  final int id;
  ReciepReportCard(this.data, this.id, {Key key}) : super(key: key);

  @override
  _ReciepReportCardState createState() => _ReciepReportCardState();
}

class _ReciepReportCardState extends State<ReciepReportCard> {
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
                  text: '${widget.data.nombre}',
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
                  text: '${widget.data.cantidad} ${widget.data.unidad}',
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      color: Color(Colors.black.value)),
                ),
                TextSpan(
                  text: '       Concentracion: ',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(Colors.black45.value)),
                ),
                TextSpan(
                  text: '${widget.data.concentracion}%',
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
                  text: '${widget.data.ingredienteActivo}',
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
                  text: '${widget.data.intervaloSeguridad} Dias\n',
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
              onPressed: () {
                addEditProductDialog(context).then((value) {
                  if (value == null) return;
                  // if (isValidProduct) addProduct(value);
                });
              },
            ),
            new FlatButton(
              child: const Text('Eliminar'),
              onPressed: () {},
            )
          ]))
    ])));
  }
}
