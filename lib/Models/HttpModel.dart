class HttpModel {
  static final String apiURL = developmentHost;
  static final String productionHost =
      'http://104.131.75.47:4000/api/'; //TODO:add production host
  // static final String developmentHost = 'https://10.0.2.2:5001/api/';
  static final String developmentHost = 'https://192.168.1.79:5001/api/';

  static String get getUrl {
    return apiURL;
  }
}
