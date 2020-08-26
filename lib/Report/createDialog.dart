import 'package:LikeApp/Models/product.dart';
import 'package:flutter/material.dart';

Future<Product> createDialog(BuildContext context) {
  List<TextEditingController> _controller = [
    new TextEditingController(),
    new TextEditingController(),
    new TextEditingController(),
    new TextEditingController(),
    new TextEditingController(),
  ];

  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        contentPadding: EdgeInsets.only(left: 25, right: 25),
        title: Center(child: Text("Agregar Producto")),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        content: Container(
          height: 200,
          width: 300,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: _controller[0],
                  keyboardType: TextInputType.number,
                  autocorrect: false,
                  maxLines: 1,
                  decoration: InputDecoration(
                      labelText: 'Cantidad',
                      hintText: 'Cantidad',
                      icon: const Icon(Icons.opacity),
                      labelStyle: TextStyle(
                          decorationStyle: TextDecorationStyle.solid)),
                ),
                TextField(
                  controller: _controller[1],
                  keyboardType: TextInputType.text,
                  autocorrect: false,
                  maxLines: 1,
                  decoration: InputDecoration(
                      labelText: 'Producto',
                      hintText: 'Producto',
                      //filled: true,
                      icon: const Icon(Icons.filter_hdr),
                      labelStyle: TextStyle(
                          decorationStyle: TextDecorationStyle.solid)),
                ),
                TextField(
                  controller: _controller[2],
                  keyboardType: TextInputType.text,
                  autocorrect: false,
                  maxLines: 1,
                  decoration: InputDecoration(
                      labelText: 'Ingrediente Activo',
                      hintText: 'Ingrediente Activo',
                      //filled: true,
                      icon: const Icon(Icons.build),
                      labelStyle: TextStyle(
                          decorationStyle: TextDecorationStyle.solid)),
                ),
                TextField(
                  controller: _controller[3],
                  keyboardType: TextInputType.number,
                  autocorrect: false,
                  maxLines: 1,
                  decoration: InputDecoration(
                      labelText: 'Concentracion (%)',
                      hintText: 'Concentracion',
                      //filled: true,
                      icon: const Icon(Icons.colorize),
                      labelStyle: TextStyle(
                          decorationStyle: TextDecorationStyle.solid)),
                ),
                TextField(
                  controller: _controller[4],
                  keyboardType: TextInputType.number,
                  autocorrect: false,
                  maxLines: 1,
                  decoration: InputDecoration(
                      labelText: 'Intervalo (Dias)',
                      hintText: 'Intervalo de seguridad',
                      //filled: true,
                      icon: const Icon(Icons.av_timer),
                      labelStyle: TextStyle(
                          decorationStyle: TextDecorationStyle.solid)),
                ),
              ],
            ),
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text("Agregar"),
            onPressed: () {
              Product newProduct = new Product(
                  cantidad: int.parse(_controller[0].text.toString()),
                  nombre: _controller[1].text.toString(),
                  ingredienteActivo: _controller[2].text.toString(),
                  concentracion: _controller[3].text.toString(),
                  intervaloSeguridad: _controller[4].text.toString());
              Navigator.pop(context, newProduct);
            },
          )
        ],
      );
    },
  );
}
