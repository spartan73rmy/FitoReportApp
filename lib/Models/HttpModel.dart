class HttpModel {
  static final String apiURL = developmentHost;
  static final String productionHost =
      'https://.herokuapp.com'; //TODO:add production host
  static final String developmentHost = 'https://10.0.2.2:5001/api/';
  // static final String developmentHost = 'https://192.168.56.1:5001/api/';

  static String getUrl() {
    return apiURL;
  }
}
