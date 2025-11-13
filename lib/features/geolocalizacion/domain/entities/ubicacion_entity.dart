import 'package:equatable/equatable.dart';

/// Entidad de Ubicación (Domain Layer)
class UbicacionEntity extends Equatable {
  final double latitude;
  final double longitude;
  final double? accuracy;
  final double? altitude;
  final DateTime timestamp;
  final String? direccion;

  const UbicacionEntity({
    required this.latitude,
    required this.longitude,
    this.accuracy,
    this.altitude,
    required this.timestamp,
    this.direccion,
  });

  @override
  List<Object?> get props => [
        latitude,
        longitude,
        accuracy,
        altitude,
        timestamp,
        direccion,
      ];
}

/// Entidad de Zona Permitida (Domain Layer)
class ZonaPermitidaEntity extends Equatable {
  final String id;
  final String nombre;
  final double latitude;
  final double longitude;
  final double radio; // en metros
  final bool activo;

  const ZonaPermitidaEntity({
    required this.id,
    required this.nombre,
    required this.latitude,
    required this.longitude,
    required this.radio,
    this.activo = true,
  });

  @override
  List<Object?> get props => [
        id,
        nombre,
        latitude,
        longitude,
        radio,
        activo,
      ];
}
