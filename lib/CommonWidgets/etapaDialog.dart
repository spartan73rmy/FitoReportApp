import '../Models/etapaFenologica.dart';
import 'package:flutter/material.dart';

class AddEditEtapaFenologicaDialog extends StatefulWidget {
  final EtapaFenologica etapaFenologica;

  AddEditEtapaFenologicaDialog({this.etapaFenologica});

  @override
  _AddEditEtapaFenologicaDialogState createState() =>
      _AddEditEtapaFenologicaDialogState();
}

class _AddEditEtapaFenologicaDialogState
    extends State<AddEditEtapaFenologicaDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  EtapaFenologica p = new EtapaFenologica();
  bool isEdit;
  List<TextEditingController> c;
  @override
  void initState() {
    super.initState();
    c = [
      new TextEditingController(),
    ];

    isEdit = widget.etapaFenologica != null;

    if (isEdit) {
      p = widget.etapaFenologica;
      c[0].text = "${p.nombre}";
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.only(left: 25, right: 25),
      title: Center(child: Text("Etapa Fenologica")),
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
                    labelText: 'Etapa Fenologica',
                    hintText: 'Etapa Fenologica',
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

Future<EtapaFenologica> addEditEtapaFenologicaDialog(BuildContext context,
    {EtapaFenologica etapaFenologica}) {
  return showDialog(
      context: context,
      builder: (context) {
        return AddEditEtapaFenologicaDialog(
          etapaFenologica: etapaFenologica,
        );
      });
}
