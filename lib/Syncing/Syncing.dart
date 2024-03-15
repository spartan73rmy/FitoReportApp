import '../CommonWidgets/alert.dart';
import '../CommonWidgets/loadingScreen.dart';
import '../Services/syncData.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class SyncingData extends StatefulWidget {
  SyncingData({Key key}) : super(key: key);

  @override
  _SyncingDataState createState() => _SyncingDataState();
}

class _SyncingDataState extends State<SyncingData> {
  bool _isLoading = false;
  bool synced = false;
  SyncData get service => GetIt.I<SyncData>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sincronizar Datos"),
      ),
      body: _isLoading
          ? LoadingScreen()
          : Column(children: [
              Center(
                child: synced
                    ? IconButton(
                        icon: Icon(Icons.cloud_download),
                        iconSize: 64,
                        onPressed: () async {
                          _showLoading();
                          bool syncResult = await service.syncData();
                          setState(() {
                            synced = syncResult;
                          });
                          _hideLoading();
                          if (synced) {
                            alertDiag(context, "Datos Syncronizados",
                                "Los datos se guardaron correctamente");
                          } else {
                            alertDiag(context, "Datos Syncronizados",
                                "Favor de conectarse a internet e iniciar sesion");
                          }
                        },
                      )
                    : IconButton(
                        icon: Icon(Icons.sync),
                        iconSize: 64,
                        onPressed: () async {
                          _showLoading();
                          bool syncResult = await service.syncData();
                          setState(() {
                            synced = syncResult;
                          });
                          _hideLoading();
                          if (synced) {
                            alertDiag(context, "Datos Syncronizados",
                                "Los datos se guardaron correctamente");
                          } else {
                            alertDiag(context, "Datos Syncronizados",
                                "Favor de conectarse a internet e iniciar sesion");
                          }
                        },
                      ),
              ),
              Center(
                child: synced
                    ? Text("Datos Syncronizados")
                    : Text("Se necesita syncronizacion"),
              )
            ]),
    );
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
}
