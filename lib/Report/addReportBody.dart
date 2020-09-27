import 'package:LikeApp/CommonWidgets/loadingScreen.dart';
import 'package:LikeApp/Models/etapaFenologica.dart';
import 'package:LikeApp/Report/selectPlaga.dart';
import 'package:LikeApp/Services/auth.dart';
import 'package:LikeApp/Services/etapaFService.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Models/reportData.dart';
import 'package:LikeApp/Models/APIResponse.dart';

class StepperBody extends StatefulWidget {
  StepperBody({Key key}) : super(key: key);
  @override
  _StepperBodyState createState() => _StepperBodyState();
}

class _StepperBodyState extends State<StepperBody> {
  int currStep = 0;
  static var _focusNode = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  static ReportData data = new ReportData();
  String _etapaFenologica;
  List<String> etapaFenologica;

  EtapaFService get service => GetIt.I<EtapaFService>();
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  SharedPreferences _sharedPreferences;
  APIResponse<List<EtapaFenologica>> res;

  bool _isLoading;

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      if (_isLoading) {
        return LoadingScreen();
      }

      if (res.error ?? false) {
        return Center(child: Text(res.errorMessage));
      }

      return Container(
          child: Form(
        autovalidate: true,
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
                        content:
                            Text('Llena correctamente el paso $currStep')));
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
          DropdownButton(
            hint: _etapaFenologica == null
                ? Text('Selecciona una opcion')
                : Text(
                    _etapaFenologica,
                    style: TextStyle(color: Colors.black),
                  ),
            isExpanded: true,
            iconSize: 30.0,
            style: TextStyle(color: Colors.blue),
            items: etapaFenologica.map(
              (val) {
                return DropdownMenuItem<String>(
                  value: val,
                  child: Text(val),
                );
              },
            ).toList(),
            onChanged: (val) {
              setState(
                () {
                  _etapaFenologica = val;
                },
              );
            },
          ),
          FloatingActionButton.extended(
            icon: Icon(Icons.add),
            backgroundColor: Theme.of(context).primaryColor,
            onPressed: () {
              var valid = isValid();
              print("es valido: $valid");
              if (isValid()) {
                _saveData();

                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SelectPlaga(data: data)),
                );
              }
            },
            label: Text("Continuar"),
          )
        ]),
      ));
    });
  }

  bool isValid() {
    for (var item in formKeys) if (!item.currentState.validate()) return false;

    if (_etapaFenologica == null) return false;
    return true;
  }

  void _saveData() {
    final form = _formKey.currentState;
    data.etapaFenologica = _etapaFenologica;

    form.save();
    for (var item in formKeys) {
      item.currentState.save();
    }
  }

  _fetchEtapas() async {
    _showLoading();

    _sharedPreferences = await _prefs;
    String authToken = Auth.getToken(_sharedPreferences);
    var resp = await service.getListEtapas(authToken);

    setState(() {
      etapaFenologica = resp.data.map((e) => e.nombre).toList();
      res = resp;
    });
    _hideLoading();
  }

  _showLoading() {
    setState(() {
      _isLoading = true;
    });
  }

  _hideLoading() {
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    _fetchEtapas();
    super.initState();
    _focusNode = FocusNode();
    etapaFenologica = new List();
    etapaFenologica.add("EtapaPrueba");

    _focusNode.addListener(() {
      setState(() {});
      print('Has focus: $_focusNode.hasFocus');
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
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
