import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:asistencia_app/core/network/network_info.dart';
import 'package:asistencia_app/features/asistencia/data/datasources/asistencia_local_datasource.dart';
import 'package:asistencia_app/features/asistencia/data/datasources/asistencia_remote_datasource.dart';
import 'package:asistencia_app/features/asistencia/data/repositories/asistencia_repository_impl.dart';
import 'package:asistencia_app/features/asistencia/domain/repositories/asistencia_repository.dart';
import 'package:asistencia_app/features/asistencia/domain/usecases/registrar_asistencia_usecase.dart';
import 'package:asistencia_app/features/asistencia/presentation/bloc/asistencia_bloc.dart';

final sl = GetIt.instance;

/// Inicializa todas las dependencias de la aplicación
Future<void> init() async {
  //! Features - Asistencia
  // Bloc
  sl.registerFactory(
    () => AsistenciaBloc(
      registrarAsistenciaUseCase: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => RegistrarAsistenciaUseCase(sl()));

  // Repository
  sl.registerLazySingleton<AsistenciaRepository>(
    () => AsistenciaRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<AsistenciaRemoteDataSource>(
    () => AsistenciaRemoteDataSourceImpl(),
  );

  sl.registerLazySingleton<AsistenciaLocalDataSource>(
    () => AsistenciaLocalDataSourceImpl(),
  );

  //! Core
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(sl()),
  );

  //! External
  sl.registerLazySingleton(() => Connectivity());

  // TODO: Registrar Database (SQLite)
  // TODO: Registrar Hive boxes
  // TODO: Registrar HTTP client (Dio)
  // TODO: Registrar SharedPreferences
  // TODO: Agregar dependencias de otros features (geolocalización, reconocimiento facial, etc.)
}
