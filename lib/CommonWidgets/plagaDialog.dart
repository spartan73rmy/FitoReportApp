import 'package:LikeApp/Models/plaga.dart';
import 'package:flutter/material.dart';

class AddEditPlagaDialog extends StatefulWidget {
  Plaga plaga;

  AddEditPlagaDialog({this.plaga});

  @override
  _AddEditPlagaDialogState createState() => _AddEditPlagaDialogState();
}

class _AddEditPlagaDialogState extends State<AddEditPlagaDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Plaga p = new Plaga();
  bool isEdit;
  List<TextEditingController> c;
  @override
  void initState() {
    super.initState();
    c = [
      new TextEditingController(),
    ];

    isEdit = widget.plaga != null;

    if (isEdit) {
      p = widget.plaga;
      c[0].text = "${p.nombre}";
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.only(left: 25, right: 25),
      title: Center(child: Text("Agregar Plaga")),
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
                  p.nombre = value;
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return "Introduce el nombre";
                  }
                  return null;
                },
                decoration: InputDecoration(
                    labelText: 'Plaga',
                    hintText: 'Plaga',
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
              Navigator.pop(context, p);
            }
          },
        )
      ],
    );
  }
}

Future<Plaga> addEditPlagaDialog(BuildContext context, {Plaga plaga}) {
  return showDialog(
      context: context,
      builder: (context) {
        return AddEditPlagaDialog(
          plaga: plaga,
        );
      });
}
