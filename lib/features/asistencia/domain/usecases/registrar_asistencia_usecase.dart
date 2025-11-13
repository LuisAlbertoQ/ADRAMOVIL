import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:asistencia_app/core/errors/failures.dart';
import 'package:asistencia_app/core/usecases/usecase.dart';
import 'package:asistencia_app/features/asistencia/domain/entities/asistencia_entity.dart';
import 'package:asistencia_app/features/asistencia/domain/repositories/asistencia_repository.dart';

/// Caso de uso para registrar una asistencia
class RegistrarAsistenciaUseCase
    implements UseCase<AsistenciaEntity, RegistrarAsistenciaParams> {
  final AsistenciaRepository repository;

  RegistrarAsistenciaUseCase(this.repository);

  @override
  Future<Either<Failure, AsistenciaEntity>> call(
      RegistrarAsistenciaParams params) async {
    return await repository.registrarAsistencia(
      userId: params.userId,
      timestamp: params.timestamp,
      latitude: params.latitude,
      longitude: params.longitude,
      tipo: params.tipo,
      fotoPath: params.fotoPath,
      observaciones: params.observaciones,
    );
  }
}

/// Parámetros para registrar asistencia
class RegistrarAsistenciaParams extends Equatable {
  final String userId;
  final DateTime timestamp;
  final double latitude;
  final double longitude;
  final String tipo;
  final String? fotoPath;
  final String? observaciones;

  const RegistrarAsistenciaParams({
    required this.userId,
    required this.timestamp,
    required this.latitude,
    required this.longitude,
    required this.tipo,
    this.fotoPath,
    this.observaciones,
  });

  @override
  List<Object?> get props => [
        userId,
        timestamp,
        latitude,
        longitude,
        tipo,
        fotoPath,
        observaciones,
      ];
}
