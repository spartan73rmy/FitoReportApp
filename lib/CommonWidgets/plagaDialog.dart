import '../Models/plaga.dart';
import 'package:flutter/material.dart';

class AddEditPlagaDialog extends StatefulWidget {
  final Plaga? plaga;

  const AddEditPlagaDialog({super.key, this.plaga});

  @override
  _AddEditPlagaDialogState createState() => _AddEditPlagaDialogState();
}

class _AddEditPlagaDialogState extends State<AddEditPlagaDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Plaga p = new Plaga();
  late bool isEdit;
  late List<TextEditingController> c;
  @override
  void initState() {
    super.initState();
    c = [
      new TextEditingController(),
    ];

    isEdit = widget.plaga != null;

    if (isEdit) {
      p = widget.plaga!;
      c[0].text = "${p.nombre}";
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.only(left: 25, right: 25),
      title: const Center(child: Text("Plaga")),
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
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: c[0],
                keyboardType: TextInputType.text,
                autocorrect: false,
                maxLines: 1,
                onSaved: (String? value) {
                  p.nombre = value;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Introduce el nombre";
                  }
                  return null;
                },
                decoration: const InputDecoration(
                    labelText: 'Plaga',
                    hintText: 'Plaga',
                    icon: Icon(Icons.bug_report),
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
              Navigator.pop(context, p);
            }
          },
        )
      ],
    );
  }
}

Future<Plaga?> addEditPlagaDialog(BuildContext context, {Plaga? plaga}) {
  return showDialog<Plaga?>(
      context: context,
      builder: (context) {
        return AddEditPlagaDialog(
          plaga: plaga,
        );
      });
}
