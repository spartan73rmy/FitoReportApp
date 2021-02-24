import 'package:LikeApp/Models/etapaFenologica.dart';
import 'package:LikeApp/Services/Auth.dart';
import 'package:LikeApp/Services/PlagaService.dart';
import 'package:LikeApp/Services/etapaFService.dart';
import 'package:LikeApp/Storage/files.dart';
import 'package:LikeApp/Storage/localStorage.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'EnfermedadService.dart';
import 'conectionService.dart';

class SyncData {
  Ping get ping => GetIt.I<Ping>();

  Future<bool> syncData() async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    SharedPreferences _sharedPreferences;

    _sharedPreferences = await _prefs;
    String authToken = Auth.getToken(_sharedPreferences);
    bool isOnline = true;
    bool synced = true;
    try {
      synced &= await fetchEtapa(authToken, isOnline);
      synced &= await fetchPlagas(authToken, isOnline);
      synced &= await fetchEnfermedades(authToken, isOnline);
    } catch (e) {
      synced = false;
    }
    return synced;
  }

  fetchEnfermedades(String authToken, bool isOnline) async {
    LocalStorage localS = LocalStorage(FileName().enfermedad);
    EnfermedadService enfermedadService = new EnfermedadService();
    if (isOnline) {
      var resp = await enfermedadService.getListEnfermedad(authToken);
      if (!resp.error) await localS.refreshEnfermedades(resp.data);
      return true;
    }
    return false;
  }

  fetchPlagas(String authToken, bool isOnline) async {
    LocalStorage localS = LocalStorage(FileName().plaga);
    PlagaService plagaService = new PlagaService();
    if (isOnline) {
      var resp = await plagaService.getListPlaga(authToken);
      if (!resp.error) await localS.refreshPlagas(resp.data);
      return true;
    }
    return false;
  }

  fetchEtapa(String authToken, bool isOnline) async {
    LocalStorage localS = LocalStorage(FileName().etapa);
    EtapaFService etapaService = new EtapaFService();
    if (isOnline) {
      var resp = await etapaService.getListEtapas(authToken);
      if (!resp.error) await localS.refreshEtapas(resp.data);
      return true;
    }
    return false;
  }
}
