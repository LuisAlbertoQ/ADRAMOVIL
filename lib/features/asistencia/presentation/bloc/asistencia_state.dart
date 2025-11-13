import 'package:equatable/equatable.dart';
import 'package:asistencia_app/features/asistencia/domain/entities/asistencia_entity.dart';

/// Estados del Bloc de Asistencia
abstract class AsistenciaState extends Equatable {
  const AsistenciaState();

  @override
  List<Object?> get props => [];
}

/// Estado inicial
class AsistenciaInitial extends AsistenciaState {
  const AsistenciaInitial();
}

/// Estado de carga
class AsistenciaLoading extends AsistenciaState {
  const AsistenciaLoading();
}

/// Estado de asistencia registrada exitosamente
class AsistenciaRegistradaSuccess extends AsistenciaState {
  final AsistenciaEntity asistencia;

  const AsistenciaRegistradaSuccess(this.asistencia);

  @override
  List<Object?> get props => [asistencia];
}

/// Estado de historial cargado
class HistorialCargadoSuccess extends AsistenciaState {
  final List<AsistenciaEntity> asistencias;

  const HistorialCargadoSuccess(this.asistencias);

  @override
  List<Object?> get props => [asistencias];
}

/// Estado de sincronización completada
class SincronizacionCompletada extends AsistenciaState {
  final int sincronizados;

  const SincronizacionCompletada(this.sincronizados);

  @override
  List<Object?> get props => [sincronizados];
}

/// Estado de error
class AsistenciaError extends AsistenciaState {
  final String mensaje;

  const AsistenciaError(this.mensaje);

  @override
  List<Object?> get props => [mensaje];
}
