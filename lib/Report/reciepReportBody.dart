import 'package:LikeApp/Models/producto.dart';
import 'package:LikeApp/CommonWidgets/productDialog.dart';
import 'package:flutter/material.dart';

class ReciepReportBody extends StatefulWidget {
  final List<Producto> allProducts;

  ReciepReportBody(this.allProducts, {Key key}) : super(key: key);

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
                    child: new Card(
                        child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
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
                                  text: '${widget.allProducts[i].nombre}',
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
                                  text:
                                      '${widget.allProducts[i].cantidad} ${widget.allProducts[i].unidad}',
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
                                  text:
                                      '${widget.allProducts[i].concentracion}%',
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
                                  text:
                                      '${widget.allProducts[i].ingredienteActivo}',
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
                                  text:
                                      '${widget.allProducts[i].intervaloSeguridad} Dias\n',
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
                                addEditProductDialog(context,
                                        producto: widget.allProducts[i])
                                    .then((value) {
                                  if (value == null) return;
                                  bool isValidProduct = value.nombre != null &&
                                      value.cantidad != null &&
                                      value.unidad != null &&
                                      value.concentracion != null &&
                                      value.ingredienteActivo != null &&
                                      value.intervaloSeguridad != null;
                                  if (isValidProduct)
                                    setState(() {
                                      widget.allProducts[i] = value;
                                    });
                                });
                              },
                            ),
                            new FlatButton(
                              child: const Text('Eliminar'),
                              onPressed: () {
                                setState(() {
                                  widget.allProducts.removeAt(i);
                                });
                              },
                            )
                          ]))
                    ])));
              })),
    );
  }
}
