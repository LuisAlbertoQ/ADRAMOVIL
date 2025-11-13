import 'package:dartz/dartz.dart';
import 'package:asistencia_app/core/errors/exceptions.dart';
import 'package:asistencia_app/core/errors/failures.dart';
import 'package:asistencia_app/core/network/network_info.dart';
import 'package:asistencia_app/features/asistencia/data/datasources/asistencia_local_datasource.dart';
import 'package:asistencia_app/features/asistencia/data/datasources/asistencia_remote_datasource.dart';
import 'package:asistencia_app/features/asistencia/data/models/asistencia_model.dart';
import 'package:asistencia_app/features/asistencia/domain/entities/asistencia_entity.dart';
import 'package:asistencia_app/features/asistencia/domain/repositories/asistencia_repository.dart';

/// Implementación del Repository de Asistencia (Data Layer)
class AsistenciaRepositoryImpl implements AsistenciaRepository {
  final AsistenciaRemoteDataSource remoteDataSource;
  final AsistenciaLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  AsistenciaRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, AsistenciaEntity>> registrarAsistencia({
    required String userId,
    required DateTime timestamp,
    required double latitude,
    required double longitude,
    required String tipo,
    String? fotoPath,
    String? observaciones,
  }) async {
    try {
      // Crear el modelo de asistencia
      final asistencia = AsistenciaModel(
        userId: userId,
        timestamp: timestamp,
        latitude: latitude,
        longitude: longitude,
        tipo: tipo,
        fotoPath: fotoPath,
        observaciones: observaciones,
        sincronizado: false,
      );

      // Guardar localmente primero
      final asistenciaGuardada =
          await localDataSource.guardarAsistencia(asistencia);

      // Intentar sincronizar si hay conexión
      final isConnected = await networkInfo.isConnected;
      if (isConnected) {
        try {
          // Subir foto si existe
          String? fotoUrl;
          if (fotoPath != null) {
            fotoUrl = await remoteDataSource.subirFoto(fotoPath);
          }

          // Enviar asistencia al servidor
          final asistenciaConFoto =
              asistenciaGuardada.copyWith(fotoPath: fotoUrl);
          await remoteDataSource.enviarAsistencia(asistenciaConFoto);

          // Marcar como sincronizada
          if (asistenciaGuardada.id != null) {
            await localDataSource
                .marcarComoSincronizada(asistenciaGuardada.id!);
          }

          return Right(asistenciaConFoto.copyWith(sincronizado: true));
        } on ServerException catch (e) {
          // Si falla el servidor, aún así retornamos la asistencia guardada localmente
          return Right(asistenciaGuardada);
        }
      }

      return Right(asistenciaGuardada);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<AsistenciaEntity>>> obtenerHistorial({
    required String userId,
    DateTime? fechaInicio,
    DateTime? fechaFin,
  }) async {
    try {
      final isConnected = await networkInfo.isConnected;

      if (isConnected) {
        try {
          // Intentar obtener desde el servidor
          final asistencias = await remoteDataSource.obtenerHistorial(
            userId: userId,
            fechaInicio: fechaInicio,
            fechaFin: fechaFin,
          );
          return Right(asistencias);
        } on ServerException {
          // Si falla, obtener desde local
          final asistencias = fechaInicio != null && fechaFin != null
              ? await localDataSource.obtenerAsistenciasPorFecha(
                  fechaInicio: fechaInicio,
                  fechaFin: fechaFin,
                )
              : await localDataSource.obtenerAsistencias();
          return Right(asistencias);
        }
      } else {
        // Sin conexión, obtener desde local
        final asistencias = fechaInicio != null && fechaFin != null
            ? await localDataSource.obtenerAsistenciasPorFecha(
                fechaInicio: fechaInicio,
                fechaFin: fechaFin,
              )
            : await localDataSource.obtenerAsistencias();
        return Right(asistencias);
      }
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<AsistenciaEntity>>>
      obtenerPendientesSincronizacion() async {
    try {
      final asistencias = await localDataSource.obtenerAsistenciasPendientes();
      return Right(asistencias);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> sincronizarAsistencia(
      AsistenciaEntity asistencia) async {
    try {
      final isConnected = await networkInfo.isConnected;

      if (!isConnected) {
        return const Left(
            NetworkFailure(message: 'No hay conexión a internet'));
      }

      // Convertir entidad a modelo
      final asistenciaModel = AsistenciaModel(
        id: asistencia.id,
        userId: asistencia.userId,
        timestamp: asistencia.timestamp,
        latitude: asistencia.latitude,
        longitude: asistencia.longitude,
        tipo: asistencia.tipo,
        fotoPath: asistencia.fotoPath,
        observaciones: asistencia.observaciones,
        sincronizado: asistencia.sincronizado,
      );

      // Subir foto si existe
      if (asistencia.fotoPath != null) {
        final fotoUrl = await remoteDataSource.subirFoto(asistencia.fotoPath!);
        await remoteDataSource
            .enviarAsistencia(asistenciaModel.copyWith(fotoPath: fotoUrl));
      } else {
        await remoteDataSource.enviarAsistencia(asistenciaModel);
      }

      // Marcar como sincronizada
      if (asistencia.id != null) {
        await localDataSource.marcarComoSincronizada(asistencia.id!);
      }

      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.code));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> eliminarAsistencia(String id) async {
    try {
      await localDataSource.eliminarAsistencia(id);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }
}
