class HttpModel {
  static final String apiURL = productionHost;
  static final String productionHost =
      'https://hungry-bush-03263.pktriot.net/FitoreportAPI/api/';
  // static final String developmentHost = 'https://10.0.2.2:5001/api/';
  static final String developmentHost =
      'https://hungry-bush-03263.pktriot.net/FitoreportAPI/api/';
  // static final String developmentHost = 'https://www.fitoreporte.tk/api/';

  static String get getUrl {
    return apiURL;
  }
}
