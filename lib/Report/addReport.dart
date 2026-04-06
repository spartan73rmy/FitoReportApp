import 'dart:io';
import '../Login/login.dart';
import '../Report/pickImage.dart';
import '../Report/selectEtapasFenologicas.dart';
import '../Services/conectionService.dart';
import 'package:flutter/material.dart';
import '../CommonWidgets/loadingScreen.dart';
import '../Services/etapaFService.dart';
import 'package:get_it/get_it.dart';
import '../Models/reportData.dart';

class AddReport extends StatefulWidget {
  const AddReport({super.key});

  @override
  _AddReportState createState() => _AddReportState();
}

class _AddReportState extends State<AddReport> {
  int currStep = 0;
  static List<FocusNode> _focusNode = [];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  static ReportData data = ReportData(created: DateTime.now());
  EtapaFService get service => GetIt.I<EtapaFService>();
  Ping get ping => GetIt.I<Ping>();
  List<File> images = [];
  bool isLoading = false;
  bool isOnline = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reporte'), actions: <Widget>[
        TextButton(
            style: TextButton.styleFrom(
              padding: const EdgeInsets.all(10.0),
            ),
            child: const Row(
              children: <Widget>[
                Center(
                  child: Text("Imagenes", style: TextStyle(color: Colors.white)),
                ),
                Icon(
                  Icons.photo,
                  color: Colors.white,
                ),
              ],
            ),
            onPressed: () async {
              List<File> imgs = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) =>
                        ImagenPicker(images: data.images),
                    fullscreenDialog: true,
                  ));
              setState(() {
                data.images = imgs;
              });
            })
      ]),
      body: Builder(builder: (context) {
        if (isLoading) {
          return LoadingScreen();
        }
        return Container(
            child: Form(
          key: _formKey,
          child: ListView(shrinkWrap: true, children: <Widget>[
            Stepper(
              physics: const ClampingScrollPhysics(),
              steps: [
                Step(
                    title: const Text('Nombre Completo'),
                    isActive: true,
                    state: StepState.indexed,
                    content: Form(
                      key: formKeys[0],
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            focusNode: _focusNode[0],
                            keyboardType: TextInputType.text,
                            autocorrect: false,
                            onSaved: (String? value) => {data.productor = value},
                            maxLines: 1,
                            validator: (String? value) {
                              if (value == null || value.isEmpty || value.length < 1) {
                                return 'Introduce el nombre';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                                labelText: 'Nombre del productor',
                                hintText: 'Nombre completo',
                                icon: Icon(Icons.person),
                                labelStyle: TextStyle(
                                    decorationStyle:
                                        TextDecorationStyle.solid)),
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
                            focusNode: _focusNode[1],
                            keyboardType: TextInputType.text,
                            autocorrect: false,
                            onSaved: (String? value) {
                              data.lugar = value;
                            },
                            maxLines: 1,
                            validator: (String? value) {
                              if (value == null || value.isEmpty || value.length < 1) {
                                return 'Introduce el lugar';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                                labelText: 'Lugar',
                                hintText: 'Lugar',
                                icon: Icon(Icons.person),
                                labelStyle: TextStyle(
                                    decorationStyle:
                                        TextDecorationStyle.solid)),
                          ),
                        ],
                      ),
                    )),
                Step(
                    title: const Text('Ubicacion'),
                    isActive: true,
                    state: StepState.indexed,
                    content: Form(
                      key: formKeys[2],
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            focusNode: _focusNode[2],
                            keyboardType: TextInputType.text,
                            autocorrect: false,
                            onSaved: (String? value) {
                              data.ubicacion = value;
                            },
                            maxLines: 1,
                            validator: (String? value) {
                              if (value == null || value.isEmpty || value.length < 1) {
                                return 'Introduce la ubicacion';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                                labelText: 'Ubicacion',
                                hintText: 'Ubicacion',
                                icon: Icon(Icons.person),
                                labelStyle: TextStyle(
                                    decorationStyle:
                                        TextDecorationStyle.solid)),
                          ),
                        ],
                      ),
                    )),
                Step(
                    title: const Text('Nombre del predio'),
                    isActive: true,
                    state: StepState.indexed,
                    content: Form(
                      key: formKeys[3],
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            focusNode: _focusNode[3],
                            keyboardType: TextInputType.text,
                            autocorrect: false,
                            onSaved: (String? value) {
                              data.predio = value;
                            },
                            maxLines: 1,
                            validator: (String? value) {
                              if (value == null || value.isEmpty || value.length < 1) {
                                return 'Introduce el nombre del predio';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                                labelText: 'Predio',
                                hintText: 'Nombre del predio',
                                icon: Icon(Icons.person),
                                labelStyle: TextStyle(
                                    decorationStyle:
                                        TextDecorationStyle.solid)),
                          ),
                        ],
                      ),
                    )),
                Step(
                    title: const Text('Cultivo'),
                    isActive: true,
                    state: StepState.indexed,
                    content: Form(
                      key: formKeys[4],
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            focusNode: _focusNode[4],
                            keyboardType: TextInputType.text,
                            autocorrect: false,
                            onSaved: (String? value) {
                              data.cultivo = value;
                            },
                            maxLines: 1,
                            initialValue: 'Aguacate',
                            validator: (String? value) {
                              if (value == null || value.isEmpty || value.length < 1) {
                                return 'Introduce el nombre del cultivo';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                                labelText: 'Cultivo',
                                hintText: 'Nombre del cultivo',
                                icon: Icon(Icons.person),
                                labelStyle: TextStyle(
                                    decorationStyle:
                                        TextDecorationStyle.solid)),
                          ),
                        ],
                      ),
                    )),
                Step(
                    title: const Text('Observaciones'),
                    isActive: true,
                    state: StepState.indexed,
                    content: Form(
                      key: formKeys[5],
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            focusNode: _focusNode[5],
                            keyboardType: TextInputType.text,
                            autocorrect: false,
                            onSaved: (String? value) {
                              data.observaciones = value;
                            },
                            maxLines: 2,
                            validator: (String? value) {
                              if (value == null || value.isEmpty || value.length < 1) {
                                return 'Introduce observaciones';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                                labelText: 'Observaciones',
                                hintText: '',
                                icon: Icon(Icons.person),
                                labelStyle: TextStyle(
                                    decorationStyle:
                                        TextDecorationStyle.solid)),
                          ),
                        ],
                      ),
                    )),
              ],
              type: StepperType.vertical,
              currentStep: currStep,
              onStepContinue: () {
                setState(() {
                  if (formKeys[currStep].currentState?.validate() == true) {
                    if (currStep < 5) {
                      currStep += 1;
                    } else {
                      currStep = 0;
                    }
                  } else {
                    if (currStep > 0) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content:
                              Text("Llena correctamente los pasos faltantes")));
                    }
                  }
                  FocusScope.of(context).requestFocus(_focusNode[currStep]);
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
                  FocusScope.of(context).requestFocus(_focusNode[currStep]);
                });
              },
            ),
          ]),
        ));
      }),
      persistentFooterButtons: [
        FloatingActionButton.extended(
          icon: const Icon(Icons.navigate_next),
          backgroundColor: Theme.of(context).primaryColor,
          onPressed: () {
            if (isValid()) {
              _saveData();
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SelectEtapa(data: data)),
              );
            }
          },
          label: const Text("Continuar"),
        )
      ],
    );
  }

  bool isValid() {
    for (var item in formKeys) if (item.currentState?.validate() != true) return false;
    return true;
  }

  void _saveData() {
    final form = _formKey.currentState;
    form?.save();
    for (var item in formKeys) {
      item.currentState?.save();
    }
  }

  void toLogIn() {
    Navigator.of(context).popUntil((route) => route.isFirst);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const Login("FitoReport")),
    );
  }

  @override
  void initState() {
    _focusNode = [
      FocusNode(),
      FocusNode(),
      FocusNode(),
      FocusNode(),
      FocusNode(),
      FocusNode(),
    ];
    data = ReportData(created: DateTime.now());
    data.id = 0;
    isLoading = false;
    isOnline = true;
    images = [];
    super.initState();
  }

  @override
  void dispose() {
    for (var element in _focusNode) {
      element.dispose();
    }
    images.clear();
    data.images?.clear();
    super.dispose();
  }
}

List<GlobalKey<FormState>> formKeys = [
  GlobalKey<FormState>(),
  GlobalKey<FormState>(),
  GlobalKey<FormState>(),
  GlobalKey<FormState>(),
  GlobalKey<FormState>(),
  GlobalKey<FormState>()
];
