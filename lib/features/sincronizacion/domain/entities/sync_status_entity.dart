import 'package:equatable/equatable.dart';

/// Entidad de Estado de Sincronización (Domain Layer)
class SyncStatusEntity extends Equatable {
  final int pendientesAsistencia;
  final int pendientesJustificaciones;
  final DateTime? ultimaSincronizacion;
  final bool sincronizando;
  final String? error;

  const SyncStatusEntity({
    required this.pendientesAsistencia,
    required this.pendientesJustificaciones,
    this.ultimaSincronizacion,
    this.sincronizando = false,
    this.error,
  });

  @override
  List<Object?> get props => [
        pendientesAsistencia,
        pendientesJustificaciones,
        ultimaSincronizacion,
        sincronizando,
        error,
      ];

  SyncStatusEntity copyWith({
    int? pendientesAsistencia,
    int? pendientesJustificaciones,
    DateTime? ultimaSincronizacion,
    bool? sincronizando,
    String? error,
  }) {
    return SyncStatusEntity(
      pendientesAsistencia: pendientesAsistencia ?? this.pendientesAsistencia,
      pendientesJustificaciones:
          pendientesJustificaciones ?? this.pendientesJustificaciones,
      ultimaSincronizacion: ultimaSincronizacion ?? this.ultimaSincronizacion,
      sincronizando: sincronizando ?? this.sincronizando,
      error: error ?? this.error,
    );
  }
}
