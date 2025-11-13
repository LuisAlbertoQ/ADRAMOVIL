import 'package:dartz/dartz.dart';
import 'package:asistencia_app/core/errors/failures.dart';
import 'package:asistencia_app/features/reconocimiento_facial/domain/entities/rostro_entity.dart';

/// Repository abstracto para Reconocimiento Facial (Domain Layer)
/// NOTA: El reconocimiento facial se realiza mediante una API externa de Python
abstract class ReconocimientoFacialRepository {
  /// Captura una foto usando la cámara del dispositivo
  Future<Either<Failure, String>> capturarFoto();

  /// Envía la foto a la API de Python para reconocimiento facial
  /// Retorna el resultado del reconocimiento desde la API
  Future<Either<Failure, ResultadoReconocimientoEntity>> enviarParaReconocimiento({
    required String imagePath,
    required String userId,
  });

  /// Procesa y optimiza una imagen antes de enviarla a la API
  /// (redimensionar, comprimir, etc.)
  Future<Either<Failure, String>> procesarImagen(String imagePath);

  /// Verifica que la imagen cumpla con requisitos mínimos de calidad
  /// antes de enviarla a la API (tamaño, formato, etc.)
  Future<Either<Failure, bool>> validarCalidadImagen(String imagePath);
}
