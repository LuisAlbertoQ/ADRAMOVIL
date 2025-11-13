/// Constantes globales de la aplicación
class AppConstants {
  // API
  static const String baseUrl = 'https://api.ejemplo.com'; // TODO: Cambiar por la URL real
  static const String apiVersion = '/v1';
  static const int connectionTimeout = 30000; // 30 segundos
  static const int receiveTimeout = 30000;

  // Endpoints (ejemplos - actualizar según tu API)
  static const String loginEndpoint = '/auth/login';
  static const String asistenciaEndpoint = '/asistencia';
  static const String justificacionesEndpoint = '/justificaciones';
  static const String sincronizacionEndpoint = '/sync';

  // API de Reconocimiento Facial (Python)
  static const String reconocimientoFacialBaseUrl = 'https://api-python.ejemplo.com'; // TODO: URL de la API de Python
  static const String reconocimientoFacialEndpoint = '/reconocer';
  static const int reconocimientoTimeout = 60000; // 60 segundos para reconocimiento

  // Local Storage
  static const String appDatabase = 'asistencia_app.db';
  static const String hiveBox = 'asistencia_box';
  static const String prefsKeyToken = 'auth_token';
  static const String prefsKeyUserId = 'user_id';
  static const String prefsKeyLastSync = 'last_sync';

  // Permisos
  static const double maxDistanceMeters = 100.0; // Radio permitido para marcar asistencia
  static const int locationUpdateInterval = 5000; // 5 segundos

  // Configuración de cámara
  static const double minFaceConfidence = 0.7; // Confianza mínima para reconocimiento facial
  static const int maxImageSizeKb = 1024; // 1MB máximo por imagen

  // Sincronización
  static const int syncRetryAttempts = 3;
  static const int syncRetryDelay = 5000; // 5 segundos entre intentos
  static const int maxPendingRecords = 100; // Máximo de registros pendientes de sincronizar

  // UI
  static const Duration splashDuration = Duration(seconds: 2);
  static const Duration snackbarDuration = Duration(seconds: 3);

  // Códigos de error (ejemplos)
  static const int errorUnauthorized = 401;
  static const int errorNotFound = 404;
  static const int errorServerError = 500;
}
