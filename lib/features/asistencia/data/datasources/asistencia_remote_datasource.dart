import 'package:asistencia_app/features/asistencia/data/models/asistencia_model.dart';

/// DataSource remoto para Asistencia
/// Maneja las peticiones a la API
abstract class AsistenciaRemoteDataSource {
  /// Envía una asistencia al servidor
  Future<AsistenciaModel> enviarAsistencia(AsistenciaModel asistencia);

  /// Obtiene el historial de asistencias desde el servidor
  Future<List<AsistenciaModel>> obtenerHistorial({
    required String userId,
    DateTime? fechaInicio,
    DateTime? fechaFin,
  });

  /// Sube una foto de asistencia al servidor
  Future<String> subirFoto(String fotoPath);
}

/// Implementación del DataSource remoto usando Retrofit/Dio
/// TODO: Implementar con retrofit
class AsistenciaRemoteDataSourceImpl implements AsistenciaRemoteDataSource {
  // TODO: Inyectar ApiClient (Retrofit)

  @override
  Future<AsistenciaModel> enviarAsistencia(AsistenciaModel asistencia) async {
    // TODO: Implementar
    throw UnimplementedError();
  }

  @override
  Future<List<AsistenciaModel>> obtenerHistorial({
    required String userId,
    DateTime? fechaInicio,
    DateTime? fechaFin,
  }) async {
    // TODO: Implementar
    throw UnimplementedError();
  }

  @override
  Future<String> subirFoto(String fotoPath) async {
    // TODO: Implementar
    throw UnimplementedError();
  }
}
