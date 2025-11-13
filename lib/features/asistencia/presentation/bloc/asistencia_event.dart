import 'package:equatable/equatable.dart';

/// Eventos del Bloc de Asistencia
abstract class AsistenciaEvent extends Equatable {
  const AsistenciaEvent();

  @override
  List<Object?> get props => [];
}

/// Evento para registrar una nueva asistencia
class RegistrarAsistenciaEvent extends AsistenciaEvent {
  final String tipo; // 'entrada', 'salida', 'break'
  final String? observaciones;

  const RegistrarAsistenciaEvent({
    required this.tipo,
    this.observaciones,
  });

  @override
  List<Object?> get props => [tipo, observaciones];
}

/// Evento para cargar el historial de asistencias
class CargarHistorialEvent extends AsistenciaEvent {
  final DateTime? fechaInicio;
  final DateTime? fechaFin;

  const CargarHistorialEvent({
    this.fechaInicio,
    this.fechaFin,
  });

  @override
  List<Object?> get props => [fechaInicio, fechaFin];
}

/// Evento para sincronizar asistencias pendientes
class SincronizarAsistenciasEvent extends AsistenciaEvent {
  const SincronizarAsistenciasEvent();
}
