import 'package:equatable/equatable.dart';

/// Entidad de Rostro detectado (Domain Layer)
class RostroEntity extends Equatable {
  final String? id;
  final double confianza;
  final Map<String, double>? boundingBox; // x, y, width, height
  final DateTime timestamp;
  final String? usuarioId;

  const RostroEntity({
    this.id,
    required this.confianza,
    this.boundingBox,
    required this.timestamp,
    this.usuarioId,
  });

  @override
  List<Object?> get props => [
        id,
        confianza,
        boundingBox,
        timestamp,
        usuarioId,
      ];
}

/// Entidad de Resultado de Reconocimiento Facial
class ResultadoReconocimientoEntity extends Equatable {
  final bool rostroDetectado;
  final bool cumpleUmbrales;
  final double confianza;
  final String? mensaje;
  final RostroEntity? rostro;

  const ResultadoReconocimientoEntity({
    required this.rostroDetectado,
    required this.cumpleUmbrales,
    required this.confianza,
    this.mensaje,
    this.rostro,
  });

  @override
  List<Object?> get props => [
        rostroDetectado,
        cumpleUmbrales,
        confianza,
        mensaje,
        rostro,
      ];
}
