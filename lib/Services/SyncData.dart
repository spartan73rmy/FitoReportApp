import '../Services/Auth.dart';
import '../Services/plagaService.dart';
import '../Services/etapaFService.dart';
import '../Storage/files.dart';
import '../Storage/localStorage.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'enfermedadService.dart';
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
      return resp.error == false;
    }
    return false;
  }

  fetchPlagas(String authToken, bool isOnline) async {
    LocalStorage localS = LocalStorage(FileName().plaga);
    PlagaService plagaService = new PlagaService();
    if (isOnline) {
      var resp = await plagaService.getListPlaga(authToken);
      if (!resp.error) await localS.refreshPlagas(resp.data);
      return resp.error == false;
    }
    return false;
  }

  fetchEtapa(String authToken, bool isOnline) async {
    LocalStorage localS = LocalStorage(FileName().etapa);
    EtapaFService etapaService = new EtapaFService();
    if (isOnline) {
      var resp = await etapaService.getListEtapas(authToken);
      if (!resp.error) await localS.refreshEtapas(resp.data);
      return resp.error == false;
    }
    return false;
  }
}
