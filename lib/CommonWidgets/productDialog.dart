import '../Models/producto.dart';
import 'package:flutter/material.dart';

class AddProductDialog extends StatefulWidget {
  final Producto? producto;

  const AddProductDialog({super.key, this.producto});

  @override
  _AddProductDialogState createState() => _AddProductDialogState();
}

class _AddProductDialogState extends State<AddProductDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Producto producto = new Producto();
  List<String> unidades = ["Kg", "L", "g", "mL"];
  late bool isEdit;
  late List<TextEditingController> textController;
  @override
  void initState() {
    super.initState();
    textController = [
      new TextEditingController(),
      new TextEditingController(),
      new TextEditingController(),
      new TextEditingController(),
      new TextEditingController(),
    ];

    isEdit = widget.producto != null;

    if (isEdit) {
      producto = widget.producto!;
      textController[0].text = "${producto.cantidad}";
      textController[1].text = "${producto.nombre}";
      textController[2].text = "${producto.ingredienteActivo}";
      textController[3].text = "${producto.concentracion}";
      textController[4].text = "${producto.intervaloSeguridad}";
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.only(left: 25, right: 25),
      title: const Center(child: Text("Producto")),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      content: Container(
        height: 360,
        width: 300,
        child: SingleChildScrollView(
            child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                      child: TextFormField(
                    controller: textController[0],
                    keyboardType: TextInputType.number,
                    autocorrect: false,
                    maxLines: 1,
                    onSaved: (String? value) {
                      producto.cantidad = double.tryParse(value ?? '') ?? 0;
                    },
                    validator: (value) {
                      var num = double.tryParse(value ?? '');
                      if (num == null || value == null || value.isEmpty) {
                        return "Introduce la cantidad";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                        labelText: 'Cantidad',
                        hintText: 'Cantidad',
                        icon: Icon(Icons.opacity),
                        labelStyle: TextStyle(
                            decorationStyle: TextDecorationStyle.solid)),
                  )),
                  Expanded(
                      child: DropdownButton<String>(
                    value: producto.unidad.isEmpty ? null : producto.unidad,
                    hint: const Text('Unidad'),
                    isExpanded: true,
                    elevation: 2,
                    iconSize: 30.0,
                    style: const TextStyle(color: Colors.blue),
                    items: unidades.map(
                      (val) {
                        return DropdownMenuItem<String>(
                          value: val,
                          child: Text(val),
                        );
                      },
                    ).toList(),
                    onChanged: (val) {
                      setState(() {
                        producto.unidad = val ?? '';
                      });
                    },
                  )),
                ],
              ),
              TextFormField(
                controller: textController[1],
                keyboardType: TextInputType.text,
                autocorrect: false,
                maxLines: 1,
                onSaved: (String? value) {
                  producto.nombre = value ?? '';
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Introduce el nombre";
                  }
                  return null;
                },
                decoration: const InputDecoration(
                    labelText: 'Producto',
                    hintText: 'Producto',
                    icon: Icon(Icons.filter_hdr),
                    labelStyle:
                        TextStyle(decorationStyle: TextDecorationStyle.solid)),
              ),
              TextFormField(
                controller: textController[2],
                keyboardType: TextInputType.text,
                autocorrect: false,
                maxLines: 1,
                onSaved: (String? value) {
                  producto.ingredienteActivo = value ?? '';
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Introduce el ingrediente activo";
                  }
                  return null;
                },
                decoration: const InputDecoration(
                    labelText: 'Ingrediente Activo',
                    hintText: 'Ingrediente Activo',
                    icon: Icon(Icons.build),
                    labelStyle:
                        TextStyle(decorationStyle: TextDecorationStyle.solid)),
              ),
              TextFormField(
                controller: textController[3],
                keyboardType: TextInputType.number,
                autocorrect: false,
                maxLines: 1,
                onSaved: (String? value) {
                  producto.concentracion =
                      (double.tryParse(value ?? '') ?? 0).toString();
                },
                validator: (value) {
                  var num = double.tryParse(value ?? '');
                  if (num == null || value == null || value.isEmpty) {
                    return "Solo introduce la cantidad sin %";
                  }
                  return null;
                },
                decoration: const InputDecoration(
                    labelText: 'Concentracion (%)',
                    hintText: 'Concentracion',
                    icon: Icon(Icons.colorize),
                    labelStyle:
                        TextStyle(decorationStyle: TextDecorationStyle.solid)),
              ),
              TextFormField(
                controller: textController[4],
                keyboardType: TextInputType.number,
                autocorrect: false,
                maxLines: 1,
                onSaved: (String? value) {
                  producto.intervaloSeguridad =
                      (int.tryParse(value ?? '') ?? 0).toString();
                },
                validator: (value) {
                  var num = int.tryParse(value ?? '');
                  if (num == null || value == null || value.isEmpty) {
                    return "Introduce la cantidad de dias";
                  }
                  return null;
                },
                decoration: const InputDecoration(
                    labelText: 'Intervalo (Dias)',
                    hintText: 'Intervalo de seguridad',
                    icon: Icon(Icons.av_timer),
                    labelStyle:
                        TextStyle(decorationStyle: TextDecorationStyle.solid)),
              ),
            ],
          ),
        )),
      ),
      actions: <Widget>[
        TextButton(
          child: isEdit ? const Text("Editar") : const Text("Agregar"),
          onPressed: () {
            final form = _formKey.currentState;
            if (form != null && form.validate()) {
              form.save();
              Navigator.pop(context, producto);
            }
          },
        )
      ],
    );
  }
}

Future<Producto?> addEditProductDialog(BuildContext context,
    {Producto? producto}) {
  return showDialog<Producto?>(
      context: context,
      builder: (context) {
        return AddProductDialog(
          producto: producto,
        );
      });
}
