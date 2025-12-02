class Environment {
  // IP definida por el usuario
  static const String ipAddress = "192.168.0.16"; 
  
  // Puertos de tus contenedores Docker
  static const String apiPort = "18000";
  static const String storagePort = "19000"; // MinIO

  // URLs Base
  static const String apiUrl = "http://$ipAddress:$apiPort/api";
  static const String storageUrl = "http://$ipAddress:$storagePort/nutrichef-bucket"; // Ajusta el nombre del bucket si es diferente

  // Headers comunes
  static Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
}