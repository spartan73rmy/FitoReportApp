import '../Models/producto.dart';
import '../CommonWidgets/productDialog.dart';
import 'package:flutter/material.dart';

class ReciepReportCard extends StatefulWidget {
  final Producto data;
  final int id;
  const ReciepReportCard(this.data, this.id, {super.key});

  @override
  _ReciepReportCardState createState() => _ReciepReportCardState();
}

class _ReciepReportCardState extends State<ReciepReportCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Card(
            child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
      ListTile(
          leading: const Icon(Icons.archive),
          title: RichText(
              text: TextSpan(
                  text: 'Producto: ',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.black),
                  children: <TextSpan>[
                TextSpan(
                  text: '${widget.data.nombre}',
                  style: const TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 18,
                      color: Colors.black),
                ),
              ])),
          subtitle: RichText(
            text: TextSpan(
              text: 'Cant: ',
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black45),
              children: <TextSpan>[
                TextSpan(
                  text: '${widget.data.cantidad} ${widget.data.unidad}',
                  style: const TextStyle(
                      fontWeight: FontWeight.normal,
                      color: Colors.black),
                ),
                const TextSpan(
                  text: '       Concentracion: ',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black45),
                ),
                TextSpan(
                  text: '${widget.data.concentracion}%',
                  style: const TextStyle(
                      fontWeight: FontWeight.normal,
                      color: Colors.black),
                ),
                const TextSpan(
                  text: '\nIngr. Activo: ',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black45),
                ),
                TextSpan(
                  text: '${widget.data.ingredienteActivo}',
                  style: const TextStyle(
                      fontWeight: FontWeight.normal,
                      color: Colors.black),
                ),
                const TextSpan(
                  text: '\nIntervalo de seguridad: ',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black45),
                ),
                TextSpan(
                  text: '${widget.data.intervaloSeguridad} Dias\n',
                  style: const TextStyle(
                      fontWeight: FontWeight.normal,
                      color: Colors.black),
                ),
              ],
            ),
          )),
      OverflowBar(children: <Widget>[
        TextButton(
          child: const Text('Editar'),
          onPressed: () {
            addEditProductDialog(context).then((value) {
              if (value == null) return;
            });
          },
        ),
        TextButton(
          child: const Text('Eliminar'),
          onPressed: () {},
        )
      ])
    ])));
  }
}
