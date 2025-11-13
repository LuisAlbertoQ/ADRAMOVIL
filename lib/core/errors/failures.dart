import 'package:equatable/equatable.dart';

/// Clase base abstracta para todos los fallos de la aplicación
abstract class Failure extends Equatable {
  final String message;
  final int? code;

  const Failure({
    required this.message,
    this.code,
  });

  @override
  List<Object?> get props => [message, code];
}

/// Fallo de servidor (API)
class ServerFailure extends Failure {
  const ServerFailure({
    required super.message,
    super.code,
  });
}

/// Fallo de caché/almacenamiento local
class CacheFailure extends Failure {
  const CacheFailure({
    required super.message,
    super.code,
  });
}

/// Fallo de red/conectividad
class NetworkFailure extends Failure {
  const NetworkFailure({
    required super.message,
    super.code,
  });
}

/// Fallo de validación
class ValidationFailure extends Failure {
  const ValidationFailure({
    required super.message,
    super.code,
  });
}

/// Fallo de permisos
class PermissionFailure extends Failure {
  const PermissionFailure({
    required super.message,
    super.code,
  });
}

/// Fallo de geolocalización
class LocationFailure extends Failure {
  const LocationFailure({
    required super.message,
    super.code,
  });
}

/// Fallo de cámara/reconocimiento facial
class CameraFailure extends Failure {
  const CameraFailure({
    required super.message,
    super.code,
  });
}

/// Fallo desconocido
class UnknownFailure extends Failure {
  const UnknownFailure({
    required super.message,
    super.code,
  });
}
