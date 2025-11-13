import 'package:equatable/equatable.dart';

/// Entidad de Justificación (Domain Layer)
class JustificacionEntity extends Equatable {
  final String? id;
  final String userId;
  final DateTime fecha;
  final String motivo;
  final String descripcion;
  final String? adjuntoPath;
  final String estado; // 'pendiente', 'aprobada', 'rechazada'
  final DateTime createdAt;
  final bool sincronizado;

  const JustificacionEntity({
    this.id,
    required this.userId,
    required this.fecha,
    required this.motivo,
    required this.descripcion,
    this.adjuntoPath,
    this.estado = 'pendiente',
    required this.createdAt,
    this.sincronizado = false,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        fecha,
        motivo,
        descripcion,
        adjuntoPath,
        estado,
        createdAt,
        sincronizado,
      ];
}
