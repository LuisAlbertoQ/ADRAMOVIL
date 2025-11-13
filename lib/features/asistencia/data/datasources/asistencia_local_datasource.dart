import 'package:asistencia_app/features/asistencia/data/models/asistencia_model.dart';

/// DataSource local para Asistencia
/// Maneja la persistencia local (SQLite, Hive, etc.)
abstract class AsistenciaLocalDataSource {
  /// Guarda una asistencia localmente
  Future<AsistenciaModel> guardarAsistencia(AsistenciaModel asistencia);

  /// Obtiene todas las asistencias locales
  Future<List<AsistenciaModel>> obtenerAsistencias();

  /// Obtiene asistencias por rango de fechas
  Future<List<AsistenciaModel>> obtenerAsistenciasPorFecha({
    required DateTime fechaInicio,
    required DateTime fechaFin,
  });

  /// Obtiene asistencias pendientes de sincronizar
  Future<List<AsistenciaModel>> obtenerAsistenciasPendientes();

  /// Actualiza una asistencia local
  Future<void> actualizarAsistencia(AsistenciaModel asistencia);

  /// Elimina una asistencia local
  Future<void> eliminarAsistencia(String id);

  /// Marca una asistencia como sincronizada
  Future<void> marcarComoSincronizada(String id);
}

/// Implementación del DataSource local usando SQLite
/// TODO: Implementar con sqflite
class AsistenciaLocalDataSourceImpl implements AsistenciaLocalDataSource {
  // TODO: Inyectar Database

  @override
  Future<AsistenciaModel> guardarAsistencia(AsistenciaModel asistencia) async {
    // TODO: Implementar
    throw UnimplementedError();
  }

  @override
  Future<List<AsistenciaModel>> obtenerAsistencias() async {
    // TODO: Implementar
    throw UnimplementedError();
  }

  @override
  Future<List<AsistenciaModel>> obtenerAsistenciasPorFecha({
    required DateTime fechaInicio,
    required DateTime fechaFin,
  }) async {
    // TODO: Implementar
    throw UnimplementedError();
  }

  @override
  Future<List<AsistenciaModel>> obtenerAsistenciasPendientes() async {
    // TODO: Implementar
    throw UnimplementedError();
  }

  @override
  Future<void> actualizarAsistencia(AsistenciaModel asistencia) async {
    // TODO: Implementar
    throw UnimplementedError();
  }

  @override
  Future<void> eliminarAsistencia(String id) async {
    // TODO: Implementar
    throw UnimplementedError();
  }

  @override
  Future<void> marcarComoSincronizada(String id) async {
    // TODO: Implementar
    throw UnimplementedError();
  }
}
