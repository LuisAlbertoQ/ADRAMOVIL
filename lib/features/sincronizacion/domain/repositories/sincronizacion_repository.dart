import 'package:dartz/dartz.dart';
import 'package:asistencia_app/core/errors/failures.dart';
import 'package:asistencia_app/features/sincronizacion/domain/entities/sync_status_entity.dart';

/// Repository abstracto para Sincronización (Domain Layer)
abstract class SincronizacionRepository {
  /// Sincroniza todos los datos pendientes
  Future<Either<Failure, void>> sincronizarTodo();

  /// Sincroniza solo las asistencias pendientes
  Future<Either<Failure, void>> sincronizarAsistencias();

  /// Sincroniza solo las justificaciones pendientes
  Future<Either<Failure, void>> sincronizarJustificaciones();

  /// Obtiene el estado actual de sincronización
  Future<Either<Failure, SyncStatusEntity>> obtenerEstadoSincronizacion();

  /// Stream para observar cambios en el estado de sincronización
  Stream<SyncStatusEntity> observarEstadoSincronizacion();

  /// Limpia registros ya sincronizados (opcional, para liberar espacio)
  Future<Either<Failure, void>> limpiarSincronizados();
}
