import 'package:flutter/material.dart';

Future<String?> alertInputDiag(
    BuildContext context, String tittle, String text, String error,
    {TextInputType keyboard = TextInputType.number,
    Icon icon = const Icon(Icons.opacity)}) async {
  TextEditingController _controller = new TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? result;
  return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Center(child: Text(tittle)),
          content: Container(
              height: 80,
              width: 200,
              child: SingleChildScrollView(
                  child: Form(
                      key: _formKey,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            TextFormField(
                              controller: _controller,
                              keyboardType: keyboard,
                              autocorrect: false,
                              maxLines: 1,
                              onSaved: (String? value) {
                                result = value;
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return error;
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                  labelText: text,
                                  hintText: text,
                                  icon: icon,
                                  labelStyle: const TextStyle(
                                      decorationStyle:
                                          TextDecorationStyle.solid)),
                            )
                          ])))),
          actions: <Widget>[
            TextButton(
              child: const Text("Aceptar"),
              onPressed: () {
                final form = _formKey.currentState;
                if (form != null && form.validate()) {
                  form.save();
                  Navigator.pop(context, result);
                }
              },
            )
          ],
        );
      });
}
