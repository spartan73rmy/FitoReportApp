import 'dart:io';
import 'dart:ui';
import 'package:LikeApp/CommonWidgets/alert.dart';
import 'package:LikeApp/CommonWidgets/alertEditCreate.dart';
import 'package:LikeApp/CommonWidgets/deleteDialog.dart';
import 'package:LikeApp/CommonWidgets/etapaDialog.dart';
import 'package:LikeApp/Login/login.dart';
import 'package:LikeApp/Report/pickImage.dart';
import 'package:LikeApp/Services/conectionService.dart';
import 'package:LikeApp/Storage/files.dart';
import 'package:LikeApp/Storage/localStorage.dart';
import 'package:flutter/material.dart';
import 'package:LikeApp/CommonWidgets/loadingScreen.dart';
import 'package:LikeApp/Models/etapaFenologica.dart';
import 'package:LikeApp/Report/selectPlaga.dart';
import 'package:LikeApp/Services/auth.dart';
import 'package:LikeApp/Services/etapaFService.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Models/reportData.dart';
import 'package:LikeApp/Models/APIResponse.dart';

class AddReport extends StatefulWidget {
  @override
  _AddReportState createState() => new _AddReportState();
}

class _AddReportState extends State<AddReport> {
  int currStep = 0;
  static var _focusNode = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  static ReportData data = new ReportData();
  String etapaFenologica;

  EtapaFService get service => GetIt.I<EtapaFService>();
  Ping get ping => GetIt.I<Ping>();
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  SharedPreferences _sharedPreferences;
  APIResponse<List<EtapaFenologica>> res;
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

        if (isOnline && res.error ?? false) {
          return Center(child: Text(res.errorMessage));
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
                            focusNode: _focusNode,
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
            res.data.isEmpty
                ? FlatButton(
                    onPressed: () async {
                      await addEditEtapaFenologicaDialog(context).then((value) {
                        if (value == null || value.nombre == null) return;
                        setState(() {
                          res.data.add(value);
                          etapaFenologica = value.nombre;
                        });
                      });
                    },
                    child: Text("Agregar Etapa Fenologica"))
                : DropdownButton(
                    hint: etapaFenologica == null
                        ? Text(
                            'Selecciona la etapa fenologica',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          )
                        : Text(etapaFenologica,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.normal)),
                    isExpanded: true,
                    elevation: 2,
                    iconSize: 40,
                    style: TextStyle(color: Colors.blue, fontSize: 16),
                    items: res.data.map(
                      (val) {
                        return DropdownMenuItem<String>(
                          value: val.nombre,
                          child: Dismissible(
                              key: ValueKey(val.nombre),
                              direction: DismissDirection.startToEnd,
                              onDismissed: (direction) async {},
                              confirmDismiss: (direction) async {
                                final result = await showDialog(
                                        context: context,
                                        builder: (_) => DeleteDialog()) ??
                                    false;
                                //If delete is confirmed delete from list if exist
                                if (result) {
                                  await deleteEtapa(val);
                                }
                                return result;
                              },
                              background: Container(
                                color: Colors.blue,
                                padding: EdgeInsets.only(left: 16),
                                child: Align(
                                  child:
                                      Icon(Icons.delete, color: Colors.white),
                                  alignment: Alignment.centerLeft,
                                ),
                              ),
                              child: GestureDetector(
                                onLongPress: () async {
                                  await addEditEtapa(val);
                                },
                                child: Container(
                                  height: 40,
                                  width: 600,
                                  child: Text(val.nombre),
                                ),
                              )),
                        );
                      },
                    ).toList(),
                    onChanged: (val) {
                      setState(
                        () {
                          etapaFenologica = val;
                          data.etapaFenologica = etapaFenologica;
                        },
                      );
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
                    builder: (context) => SelectPlaga(data: data)),
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

    if (etapaFenologica == null) return false;
    return true;
  }

  void _saveData() {
    data.etapaFenologica = etapaFenologica;
    print(data.images);
    final form = _formKey.currentState;
    form.save();
    for (var item in formKeys) {
      item.currentState.save();
    }
  }

  addEditEtapa(EtapaFenologica val) async {
    await showDialog(
        context: context,
        builder: (context) {
          return SelectCreateEdit(
            tittle: "Crear o Editar",
            text:
                "Seleccione si desea crear un elemento nuevo o editar el pulsado",
          );
        }).then((create) async => {
          if (create ?? true)
            await addEditEtapaFenologicaDialog(context).then((value) {
              if (value == null || value.nombre == null) return;
              setState(() {
                res.data.add(value);
                etapaFenologica = value.nombre;
              });
            })
          else
            await addEditEtapaFenologicaDialog(context, etapaFenologica: val)
                .then((value) {
              if (value == null || value.nombre == null) return;
              setState(() {
                val.nombre = value.nombre;
                etapaFenologica = val.nombre;
              });
            })
        });
  }

  deleteEtapa(EtapaFenologica data) async {
    isOnline = await ping.ping() ?? false;
    bool isNotLocal = data.id != null;

    if (isNotLocal && isOnline) {
      _sharedPreferences = await _prefs;
      String authToken = Auth.getToken(_sharedPreferences);
      var resp = await service.deleteEtapa(data.id, authToken);
      if (resp.error)
        await alertDiag(context, "Error", resp.errorMessage);
      else if (res.data.contains(data))
        setState(() {
          etapaFenologica = null;
          res.data.remove(data);
        });
    } else {
      //Remove from local
      if (res.data.contains(data))
        setState(() {
          etapaFenologica = null;
          res.data.remove(data);
        });
    }
  }

  fetchEtapas() async {
    _sharedPreferences = await _prefs;
    isOnline = await ping.ping() ?? false;
    bool isNotLogged = !Auth.isLogged(_sharedPreferences);
    LocalStorage localS = LocalStorage(FileName().etapa);

    if (isOnline) {
      if (isNotLogged) toLogIn();
      _showLoading();
      String authToken = Auth.getToken(_sharedPreferences);
      var resp = await service.getListEtapas(authToken);

      if (resp.error) {
        await alertDiag(context, "Error", res.errorMessage);
        setState(() {
          res = resp;
        });
      } else {
        //En cada peticion con internet se actualizan los datos localmente
        await localS.refreshEtapas(resp.data);

        setState(() {
          res = resp;
        });
      }
      _hideLoading();
    } else {
      _showLoading();
      List<EtapaFenologica> resp = await localS.readEtapas();
      if (resp.length == 0) {
        await alertDiag(context, "Error",
            "No hay datos para cargar, favor de conectarse a internet");
      }
      setState(() {
        res = APIResponse<List<EtapaFenologica>>(data: resp, error: false);
      });
      _hideLoading();
    }
  }

  toLogIn() {
    Navigator.of(context).popUntil((route) => route.isFirst);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Login("FitoReport")),
    );
  }

  _showLoading() {
    setState(() {
      isLoading = true;
    });
  }

  _hideLoading() {
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      setState(() {});
      print('Has focus: $_focusNode.hasFocus');
    });
    data.id = 0;
    isLoading = true;
    isOnline = true;
    fetchEtapas();
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
  GlobalKey<FormState>(),
  GlobalKey<FormState>()
];
