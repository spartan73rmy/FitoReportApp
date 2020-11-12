import 'dart:ui';
import 'package:LikeApp/Login/login.dart';
import 'package:LikeApp/Report/pickImage.dart';
import 'package:LikeApp/Report/selectEtapasFenologicas.dart';
import 'package:LikeApp/Services/conectionService.dart';
import 'package:flutter/material.dart';
import 'package:LikeApp/CommonWidgets/loadingScreen.dart';
import 'package:LikeApp/Services/etapaFService.dart';
import 'package:get_it/get_it.dart';
import '../Models/reportData.dart';

class AddReport extends StatefulWidget {
  @override
  _AddReportState createState() => new _AddReportState();
}

class _AddReportState extends State<AddReport> {
  int currStep = 0;
  static List<FocusNode> _focusNode;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  static ReportData data = new ReportData();
  EtapaFService get service => GetIt.I<EtapaFService>();
  Ping get ping => GetIt.I<Ping>();
  List<Image> images;
  bool isLoading;
  bool isOnline;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Reporte'), actions: <Widget>[
        FlatButton(
            padding: EdgeInsets.all(10.0),
            child: Row(
              children: <Widget>[
                Center(
                  child:
                      Text("Imagenes", style: TextStyle(color: Colors.white)),
                ),
                Icon(
                  Icons.photo,
                  color: Colors.white,
                ),
              ],
            ),
            onPressed: () async {
              var images = await Navigator.push(
                  context,
                  new MaterialPageRoute(
                    builder: (BuildContext context) =>
                        new ImagenPicker(images: data.images),
                    fullscreenDialog: true,
                  ));
              setState(() {
                data.images = images;
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
              physics: ClampingScrollPhysics(),
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
                            onSaved: (String value) {
                              data.ubicacion = value;
                            },
                            maxLines: 1,
                            validator: (String value) {
                              if (value.isEmpty || value.length < 1) {
                                return 'Introduce la ubicacion';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                labelText: 'Ubicacion',
                                hintText: 'Ubicacion',
                                icon: const Icon(Icons.person),
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
                                    decorationStyle:
                                        TextDecorationStyle.solid)),
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
                    if (currStep < 5) {
                      currStep += 1;
                    } else {
                      currStep = 0;
                    }
                  } else {
                    if (currStep > 0) {
                      Scaffold.of(context).showSnackBar(SnackBar(
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
          icon: Icon(Icons.navigate_next),
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
          label: Text("Continuar"),
        )
      ],
    );
  }

  bool isValid() {
    for (var item in formKeys) if (!item.currentState.validate()) return false;
    return true;
  }

  void _saveData() {
    final form = _formKey.currentState;
    form.save();
    for (var item in formKeys) {
      item.currentState.save();
    }
  }

  toLogIn() {
    Navigator.of(context).popUntil((route) => route.isFirst);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Login("FitoReport")),
    );
  }

  @override
  void initState() {
    super.initState();
    _focusNode = [
      FocusNode(),
      FocusNode(),
      FocusNode(),
      FocusNode(),
      FocusNode(),
      FocusNode(),
    ];

    data.id = 0;
    isLoading = false;
    isOnline = true;
  }

  @override
  void dispose() {
    _focusNode.forEach((element) {
      element.dispose();
    });
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
