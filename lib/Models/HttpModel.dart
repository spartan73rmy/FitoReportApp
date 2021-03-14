class HttpModel {
  static final String apiURL = productionHost;
  static final String productionHost = 'https://104.131.75.47/api/';
  // static final String developmentHost = 'https://10.0.2.2:5001/api/';
  static final String developmentHost = 'https://192.168.101.9:5001/api/';
  // static final String developmentHost = 'https://www.fitoreporte.tk/api/';

  static String get getUrl {
    return apiURL;
  }
}
