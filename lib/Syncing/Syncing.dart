import 'package:LikeApp/CommonWidgets/alert.dart';
import 'package:LikeApp/CommonWidgets/loadingScreen.dart';
import 'package:LikeApp/Services/syncData.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class SyncingData extends StatefulWidget {
  SyncingData({Key key}) : super(key: key);

  @override
  _SyncingDataState createState() => _SyncingDataState();
}

class _SyncingDataState extends State<SyncingData> {
  bool _isLoading = false;
  SyncData get service => GetIt.I<SyncData>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sincronizar Datos"),
      ),
      body: _isLoading
          ? LoadingScreen()
          : Center(
              child: IconButton(
                icon: Icon(Icons.sync),
                iconSize: 50,
                onPressed: () async {
                  _showLoading();
                  bool synced = await service.syncData();
                  _hideLoading();
                  if (synced) {
                    alertDiag(context, "Datos Syncronizados",
                        "Los datos se guardaron correctamente");
                  } else {
                    alertDiag(context, "Datos Syncronizados",
                        "Los datos se guardaron correctamente");
                  }
                },
              ),
            ),
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
