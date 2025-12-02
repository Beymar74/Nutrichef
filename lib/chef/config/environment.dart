class Environment {
  // ⚠️ REVISA QUE ESTA IP SEA LA DE TU PC EN ESTE MOMENTO
  static const String ipAddress = "192.168.0.16"; 
  
  static const String apiPort = "18000";
  static const String storagePort = "19000";

  static const String apiUrl = "http://$ipAddress:$apiPort/api";
  static const String storageUrl = "http://$ipAddress:$storagePort/nutrichef-bucket";

  static Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
}