import 'package:LikeApp/Report/reciepReport.dart';
import 'package:flutter/material.dart';
import '../Models/reportData.dart';

class StepperBody extends StatefulWidget {
  StepperBody({Key key}) : super(key: key);
  @override
  _StepperBodyState createState() => _StepperBodyState();
}

class _StepperBodyState extends State<StepperBody> {
  int currStep = 0;
  static var _focusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  static ReportData data = new ReportData();

  @override
  Widget build(BuildContext context) {
    void _saveModel() {
      final form = _formKey.currentState;
      print(form.validate());

      if (form.validate()) {
        form.save();
        for (var item in formKeys) {
          item.currentState.save();
        }
      }
    }

    return Container(
        child: Form(
      key: _formKey,
      child: ListView(shrinkWrap: true, children: <Widget>[
        Stepper(
          physics: ClampingScrollPhysics(),
          steps: [
            Step(
                title: const Text('Nombre'),
                isActive: true,
                state: StepState.indexed,
                content: Form(
                  key: formKeys[0],
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        focusNode: _focusNode,
                        keyboardType: TextInputType.text,
                        autocorrect: false,
                        onSaved: (String value) => {data.productor = value},
                        maxLines: 1,
                        validator: (String value) {
                          if (value.isEmpty || value.length < 1) {
                            return 'Introduce el nombre';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            labelText: 'Nombre del productor',
                            hintText: 'Nombre completo',
                            icon: const Icon(Icons.person),
                            labelStyle: TextStyle(
                                decorationStyle: TextDecorationStyle.solid)),
                      ),
                    ],
                  ),
                )),
            Step(
                title: const Text('Lugar'),
                isActive: true,
                state: StepState.indexed,
                content: Form(
                  key: formKeys[1],
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        focusNode: _focusNode,
                        keyboardType: TextInputType.text,
                        autocorrect: false,
                        onSaved: (String value) {
                          data.lugar = value;
                        },
                        maxLines: 1,
                        validator: (String value) {
                          if (value.isEmpty || value.length < 1) {
                            return 'Introduce el lugar';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            labelText: 'Lugar',
                            hintText: 'Lugar',
                            icon: const Icon(Icons.person),
                            labelStyle: TextStyle(
                                decorationStyle: TextDecorationStyle.solid)),
                      ),
                    ],
                  ),
                )),
            Step(
                title: const Text('Nombre del predio'),
                isActive: true,
                state: StepState.indexed,
                content: Form(
                  key: formKeys[2],
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        focusNode: _focusNode,
                        keyboardType: TextInputType.text,
                        autocorrect: false,
                        onSaved: (String value) {
                          data.predio = value;
                        },
                        maxLines: 1,
                        validator: (String value) {
                          if (value.isEmpty || value.length < 1) {
                            return 'Introduce el nombre del predio';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            labelText: 'Predio',
                            hintText: 'Nombre del predio',
                            //filled: true,
                            icon: const Icon(Icons.person),
                            labelStyle: TextStyle(
                                decorationStyle: TextDecorationStyle.solid)),
                      ),
                    ],
                  ),
                )),
            Step(
                title: const Text('Cultivo'),
                isActive: true,
                state: StepState.indexed,
                content: Form(
                  key: formKeys[3],
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        focusNode: _focusNode,
                        keyboardType: TextInputType.text,
                        autocorrect: false,
                        onSaved: (String value) {
                          data.cultivo = value;
                        },
                        maxLines: 1,
                        initialValue: 'Aguacate',
                        validator: (String value) {
                          if (value.isEmpty || value.length < 1) {
                            return 'Introduce el nombre del cultivo';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            labelText: 'Cultivo',
                            hintText: 'Nombre del cultivo',
                            icon: const Icon(Icons.person),
                            labelStyle: TextStyle(
                                decorationStyle: TextDecorationStyle.solid)),
                      ),
                    ],
                  ),
                )),
            Step(
                title: const Text('Observaciones'),
                isActive: true,
                state: StepState.indexed,
                content: Form(
                  key: formKeys[4],
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        focusNode: _focusNode,
                        keyboardType: TextInputType.text,
                        autocorrect: false,
                        onSaved: (String value) {
                          data.observaciones = value;
                        },
                        maxLines: 2,
                        validator: (String value) {
                          if (value.isEmpty || value.length < 1) {
                            return 'Introduce observaciones';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            labelText: 'Observaciones',
                            hintText: '',
                            icon: const Icon(Icons.person),
                            labelStyle: TextStyle(
                                decorationStyle: TextDecorationStyle.solid)),
                      ),
                    ],
                  ),
                )),
          ],
          type: StepperType.vertical,
          currentStep: this.currStep,
          onStepContinue: () {
            setState(() {
              if (formKeys[currStep].currentState.validate()) {
                if (currStep < 4) {
                  currStep += 1;
                } else {
                  currStep = 0;
                }
              } else {
                if (currStep > 1) {
                  Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text('Llena correctamente el paso $currStep')));
                }
              }
            });
          },
          onStepCancel: () {
            setState(() {
              if (currStep > 0) {
                currStep -= 1;
              } else {
                currStep = 0;
              }
            });
          },
          onStepTapped: (step) {
            setState(() {
              currStep = step;
            });
          },
        ),
        FloatingActionButton.extended(
          icon: Icon(Icons.add),
          backgroundColor: Color(Colors.green.value),
          foregroundColor: Color(Colors.black.value),
          onPressed: () {
            _saveModel();

            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ReciepReport(data)),
            );
          },
          label: Text("Agregar Productos"),
        )
      ]),
    ));
  }

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();

    _focusNode.addListener(() {
      setState(() {});
      print('Has focus: $_focusNode.hasFocus');
    });
  }

  @override
  void dispose() {
    super.dispose();
  }
}

List<GlobalKey<FormState>> formKeys = [
  GlobalKey<FormState>(),
  GlobalKey<FormState>(),
  GlobalKey<FormState>(),
  GlobalKey<FormState>(),
  GlobalKey<FormState>()
];
