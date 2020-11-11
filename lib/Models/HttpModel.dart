class HttpModel {
  static final String apiURL = developmentHost;
  static final String productionHost = 'http://104.131.75.47:4000/api/';
  // static final String developmentHost = 'https://10.0.2.2:5001/api/';
  static final String developmentHost = 'https://192.168.0.100:5001/api/';
  // static final String developmentHost = 'https://www.fitoreporte.tk/api/';

  static String get getUrl {
    return apiURL;
  }
}
