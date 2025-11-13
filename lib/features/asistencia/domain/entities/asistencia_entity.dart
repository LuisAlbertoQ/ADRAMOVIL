import 'package:equatable/equatable.dart';

/// Entidad de Asistencia (Domain Layer)
/// Representa una asistencia registrada por un trabajador
class AsistenciaEntity extends Equatable {
  final String? id;
  final String userId;
  final DateTime timestamp;
  final double latitude;
  final double longitude;
  final String? fotoPath;
  final String tipo; // 'entrada', 'salida', 'break'
  final bool sincronizado;
  final String? observaciones;

  const AsistenciaEntity({
    this.id,
    required this.userId,
    required this.timestamp,
    required this.latitude,
    required this.longitude,
    this.fotoPath,
    required this.tipo,
    this.sincronizado = false,
    this.observaciones,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        timestamp,
        latitude,
        longitude,
        fotoPath,
        tipo,
        sincronizado,
        observaciones,
      ];
}
