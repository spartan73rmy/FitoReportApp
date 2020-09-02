import 'package:http/http.dart' as http;

class HttpModel {
  static const apiURL = "https://localhost:5001/api/";
  static const headers = {
    'apiKey':
        "yJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1lIjoiQWxiZXJ0byIsImh0dHA6Ly9zY2hlbWFzLnhtbHNvYXAub3JnL3dzLzIwMDUvMDUvaWRlbnRpdHkvY2xhaW1zL25hbWVpZGVudGlmaWVyIjoiOCIsImh0dHA6Ly9zY2hlbWFzLm1pY3Jvc29mdC5jb20vd3MvMjAwOC8wNi9pZGVudGl0eS9jbGFpbXMvcm9sZSI6IkFkbWluIiwibmJmIjoxNTk5MDY5MDE2LCJleHAiOjE1OTkwNjkzMTYsImlzcyI6IkFwcElBUyIsImF1ZCI6IkV2ZXJ5b25lIn0.8xPuEYbVTi-Y9ls2MDTqj4hJHznMXwV7MqVK4RRWcgk"
  };

  dynamic header() {
    return headers;
  }

  String api() {
    return apiURL;
  }
}
