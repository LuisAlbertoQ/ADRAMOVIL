import 'package:dartz/dartz.dart';
import 'package:asistencia_app/core/errors/failures.dart';
import 'package:asistencia_app/features/geolocalizacion/domain/entities/ubicacion_entity.dart';

/// Repository abstracto para Geolocalización (Domain Layer)
abstract class GeolocalizacionRepository {
  /// Obtiene la ubicación actual del dispositivo
  Future<Either<Failure, UbicacionEntity>> obtenerUbicacionActual();

  /// Stream de cambios en la ubicación
  Stream<Either<Failure, UbicacionEntity>> observarUbicacion();

  /// Verifica si el usuario está dentro de una zona permitida
  Future<Either<Failure, bool>> estaEnZonaPermitida({
    required double latitude,
    required double longitude,
  });

  /// Obtiene las zonas permitidas desde el servidor
  Future<Either<Failure, List<ZonaPermitidaEntity>>> obtenerZonasPermitidas();

  /// Calcula la distancia entre dos puntos
  Future<Either<Failure, double>> calcularDistancia({
    required double latInicio,
    required double lonInicio,
    required double latFin,
    required double lonFin,
  });

  /// Obtiene la dirección desde coordenadas (geocoding inverso)
  Future<Either<Failure, String>> obtenerDireccion({
    required double latitude,
    required double longitude,
  });
}
