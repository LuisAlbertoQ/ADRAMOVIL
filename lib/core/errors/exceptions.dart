/// Excepción base para todas las excepciones de la aplicación
class AppException implements Exception {
  final String message;
  final int? code;

  AppException({
    required this.message,
    this.code,
  });

  @override
  String toString() => 'AppException: $message (Code: $code)';
}

/// Excepción de servidor
class ServerException extends AppException {
  ServerException({
    required super.message,
    super.code,
  });
}

/// Excepción de caché
class CacheException extends AppException {
  CacheException({
    required super.message,
    super.code,
  });
}

/// Excepción de red
class NetworkException extends AppException {
  NetworkException({
    required super.message,
    super.code,
  });
}

/// Excepción de permisos
class PermissionException extends AppException {
  PermissionException({
    required super.message,
    super.code,
  });
}

/// Excepción de ubicación
class LocationException extends AppException {
  LocationException({
    required super.message,
    super.code,
  });
}

/// Excepción de cámara
class CameraException extends AppException {
  CameraException({
    required super.message,
    super.code,
  });
}
