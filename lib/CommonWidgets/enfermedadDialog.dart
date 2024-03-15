import '../Models/enfermedad.dart';
import 'package:flutter/material.dart';

class AddEditEnfermedadDialog extends StatefulWidget {
  final Enfermedad enfermedad;

  AddEditEnfermedadDialog({this.enfermedad});

  @override
  _AddEditEnfermedadDialogState createState() =>
      _AddEditEnfermedadDialogState();
}

class _AddEditEnfermedadDialogState extends State<AddEditEnfermedadDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Enfermedad e = new Enfermedad();
  bool isEdit;
  List<TextEditingController> c;
  @override
  void initState() {
    super.initState();
    c = [
      new TextEditingController(),
    ];

    isEdit = widget.enfermedad != null;

    if (isEdit) {
      e = widget.enfermedad;
      c[0].text = "${e.nombre}";
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.only(left: 25, right: 25),
      title: Center(child: Text("Enfermedad")),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      content: Container(
        height: 100,
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
                controller: c[0],
                keyboardType: TextInputType.text,
                autocorrect: false,
                maxLines: 1,
                onSaved: (String value) {
                  e.nombre = value;
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return "Introduce el nombre";
                  }
                  return null;
                },
                decoration: InputDecoration(
                    labelText: 'Enfermedad',
                    hintText: 'Enfermedad',
                    //filled: true,
                    icon: const Icon(Icons.bug_report),
                    labelStyle:
                        TextStyle(decorationStyle: TextDecorationStyle.solid)),
              ),
            ],
          ),
        )),
      ),
      actions: <Widget>[
        FlatButton(
          child: isEdit ? Text("Editar") : Text("Agregar"),
          onPressed: () {
            final form = _formKey.currentState;
            if (form.validate()) {
              form.save();
              Navigator.pop(context, e);
            }
          },
        )
      ],
    );
  }
}

Future<Enfermedad> addEditEnfermedadDialog(BuildContext context,
    {Enfermedad enfermedad}) {
  return showDialog(
      context: context,
      builder: (context) {
        return AddEditEnfermedadDialog(
          enfermedad: enfermedad,
        );
      });
}
