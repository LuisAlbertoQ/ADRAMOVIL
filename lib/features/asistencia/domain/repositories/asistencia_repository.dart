import 'package:dartz/dartz.dart';
import 'package:asistencia_app/core/errors/failures.dart';
import 'package:asistencia_app/features/asistencia/domain/entities/asistencia_entity.dart';

/// Repository abstracto para Asistencia (Domain Layer)
/// Define el contrato que debe implementar el repositorio en la capa de datos
abstract class AsistenciaRepository {
  /// Registra una nueva asistencia
  Future<Either<Failure, AsistenciaEntity>> registrarAsistencia({
    required String userId,
    required DateTime timestamp,
    required double latitude,
    required double longitude,
    required String tipo,
    String? fotoPath,
    String? observaciones,
  });

  /// Obtiene el historial de asistencias del usuario
  Future<Either<Failure, List<AsistenciaEntity>>> obtenerHistorial({
    required String userId,
    DateTime? fechaInicio,
    DateTime? fechaFin,
  });

  /// Obtiene las asistencias pendientes de sincronizar
  Future<Either<Failure, List<AsistenciaEntity>>> obtenerPendientesSincronizacion();

  /// Sincroniza una asistencia con el servidor
  Future<Either<Failure, void>> sincronizarAsistencia(AsistenciaEntity asistencia);

  /// Elimina una asistencia local
  Future<Either<Failure, void>> eliminarAsistencia(String id);
}
