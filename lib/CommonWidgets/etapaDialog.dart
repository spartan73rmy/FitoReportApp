import '../Models/etapaFenologica.dart';
import 'package:flutter/material.dart';

class AddEditEtapaFenologicaDialog extends StatefulWidget {
  final EtapaFenologica? etapaFenologica;

  const AddEditEtapaFenologicaDialog({super.key, this.etapaFenologica});

  @override
  _AddEditEtapaFenologicaDialogState createState() =>
      _AddEditEtapaFenologicaDialogState();
}

class _AddEditEtapaFenologicaDialogState
    extends State<AddEditEtapaFenologicaDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  EtapaFenologica p = new EtapaFenologica();
  late bool isEdit;
  late List<TextEditingController> c;
  @override
  void initState() {
    super.initState();
    c = [
      new TextEditingController(),
    ];

    isEdit = widget.etapaFenologica != null;

    if (isEdit) {
      p = widget.etapaFenologica!;
      c[0].text = "${p.nombre}";
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.only(left: 25, right: 25),
      title: const Center(child: Text("Etapa Fenologica")),
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
                    labelText: 'Etapa Fenologica',
                    hintText: 'Etapa Fenologica',
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

Future<EtapaFenologica?> addEditEtapaFenologicaDialog(BuildContext context,
    {EtapaFenologica? etapaFenologica}) {
  return showDialog<EtapaFenologica?>(
      context: context,
      builder: (context) {
        return AddEditEtapaFenologicaDialog(
          etapaFenologica: etapaFenologica,
        );
      });
}
