import '../CommonWidgets/deleteDialog.dart';
import '../Models/producto.dart';
import '../CommonWidgets/productDialog.dart';
import 'package:flutter/material.dart';

class ReciepReportBody extends StatefulWidget {
  final List<Producto> allProducts;

  const ReciepReportBody(this.allProducts, {super.key});

  @override
  _ReciepReportBodyState createState() => _ReciepReportBodyState();
}

class _ReciepReportBodyState extends State<ReciepReportBody> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            child: ListView.builder(
                itemCount: widget.allProducts.length,
                padding: const EdgeInsets.only(top: 10.0),
                itemBuilder: (context, i) {
                  return Container(
                      child: Dismissible(
                          key: ValueKey(widget.allProducts[i]),
                          direction: DismissDirection.startToEnd,
                          onDismissed: (direction) {
                            setState(() {
                              widget.allProducts.removeAt(i);
                            });
                          },
                          confirmDismiss: (direction) async {
                            final result = await showDialog(
                                    context: context,
                                    builder: (_) => const DeleteDialog()) ??
                                false;
                            return result;
                          },
                          background: Container(
                              color: Colors.blue,
                              padding: const EdgeInsets.only(left: 16),
                              child: const Align(
                                child: Icon(Icons.delete, color: Colors.white),
                                alignment: Alignment.centerLeft,
                              )),
                          child: Card(
                              child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
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
                                              text:
                                                  '${widget.allProducts[i].nombre}',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 18,
                                                  color: Colors.black))
                                        ])),
                                    subtitle: RichText(
                                        text: TextSpan(
                                            text: 'Cant: ',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black45),
                                            children: <TextSpan>[
                                          TextSpan(
                                              text:
                                                  '${widget.allProducts[i].cantidad} ${widget.allProducts[i].unidad}',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                  color: Colors.black)),
                                          const TextSpan(
                                              text: '       Concentracion: ',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black45)),
                                          TextSpan(
                                              text:
                                                  '${widget.allProducts[i].concentracion}%',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                  color: Colors.black)),
                                          const TextSpan(
                                              text: '\nIngr. Activo: ',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black45)),
                                          TextSpan(
                                              text:
                                                  '${widget.allProducts[i].ingredienteActivo}',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                  color: Colors.black)),
                                          const TextSpan(
                                              text:
                                                  '\nIntervalo de seguridad: ',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black45)),
                                          TextSpan(
                                            text:
                                                '${widget.allProducts[i].intervaloSeguridad} Dias\n',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.normal,
                                                color: Colors.black),
                                          )
                                        ]))),
                                OverflowBar(children: <Widget>[
                                  TextButton(
                                      child: const Text('Editar'),
                                      onPressed: () {
                                        addEditProductDialog(context,
                                                producto:
                                                    widget.allProducts[i])
                                            .then((value) {
                                          if (value == null) return;
                                          bool isValidProduct = value
                                                      .nombre
                                                      .isNotEmpty &&
                                              value.cantidad > 0 &&
                                              value.unidad.isNotEmpty;
                                          if (isValidProduct)
                                            setState(() {
                                              widget.allProducts[i] = value;
                                            });
                                        });
                                      })
                                ])
                              ]))));
                })));
  }
}
