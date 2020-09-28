import 'package:LikeApp/Models/producto.dart';
import 'package:flutter/material.dart';

Future<Producto> addProductDialog(BuildContext context) {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Producto newProduct = new Producto();
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
          height: 320,
          width: 300,
          child: SingleChildScrollView(
              child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _controller[0],
                  keyboardType: TextInputType.number,
                  autocorrect: false,
                  maxLines: 1,
                  onSaved: (String value) {
                    newProduct.cantidad = int.tryParse(value) ?? 0;
                  },
                  validator: (value) {
                    var num = int.tryParse(value);
                    if (num == null || value.isEmpty) {
                      return "Introduce la cantidad";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      labelText: 'Cantidad',
                      hintText: 'Cantidad',
                      icon: const Icon(Icons.opacity),
                      labelStyle: TextStyle(
                          decorationStyle: TextDecorationStyle.solid)),
                ),
                TextFormField(
                  controller: _controller[1],
                  keyboardType: TextInputType.text,
                  autocorrect: false,
                  maxLines: 1,
                  onSaved: (String value) {
                    newProduct.nombre = value;
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Introduce el nombre";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      labelText: 'Producto',
                      hintText: 'Producto',
                      //filled: true,
                      icon: const Icon(Icons.filter_hdr),
                      labelStyle: TextStyle(
                          decorationStyle: TextDecorationStyle.solid)),
                ),
                TextFormField(
                  controller: _controller[2],
                  keyboardType: TextInputType.text,
                  autocorrect: false,
                  maxLines: 1,
                  onSaved: (String value) {
                    newProduct.ingredienteActivo = value;
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Introduce el ingrediente activo";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      labelText: 'Ingrediente Activo',
                      hintText: 'Ingrediente Activo',
                      //filled: true,
                      icon: const Icon(Icons.build),
                      labelStyle: TextStyle(
                          decorationStyle: TextDecorationStyle.solid)),
                ),
                TextFormField(
                  controller: _controller[3],
                  keyboardType: TextInputType.number,
                  autocorrect: false,
                  maxLines: 1,
                  onSaved: (String value) {
                    newProduct.concentracion =
                        (int.tryParse(value) ?? 0).toString();
                  },
                  validator: (value) {
                    var num = int.tryParse(value);
                    if (num == null || value.isEmpty) {
                      return "Solo introduce la cantidad sin %";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      labelText: 'Concentracion (%)',
                      hintText: 'Concentracion',
                      //filled: true,
                      icon: const Icon(Icons.colorize),
                      labelStyle: TextStyle(
                          decorationStyle: TextDecorationStyle.solid)),
                ),
                TextFormField(
                  controller: _controller[4],
                  keyboardType: TextInputType.number,
                  autocorrect: false,
                  maxLines: 1,
                  onSaved: (String value) {
                    newProduct.intervaloSeguridad =
                        (int.tryParse(value) ?? 0).toString();
                  },
                  validator: (value) {
                    var num = int.tryParse(value);
                    if (num == null || value.isEmpty) {
                      return "Introduce la cantidad de dias";
                    }
                    return null;
                  },
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
          )),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text("Agregar"),
            onPressed: () {
              final form = _formKey.currentState;
              if (form.validate()) {
                // Text forms was validated.
                form.save();
                Navigator.pop(context, newProduct);
              }
            },
          )
        ],
      );
    },
  );
}