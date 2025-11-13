import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:asistencia_app/features/asistencia/domain/usecases/registrar_asistencia_usecase.dart';
import 'package:asistencia_app/features/asistencia/presentation/bloc/asistencia_event.dart';
import 'package:asistencia_app/features/asistencia/presentation/bloc/asistencia_state.dart';

/// Bloc de Asistencia
/// Maneja la lógica de negocio de la UI para asistencias
class AsistenciaBloc extends Bloc<AsistenciaEvent, AsistenciaState> {
  final RegistrarAsistenciaUseCase registrarAsistenciaUseCase;
  // TODO: Agregar otros use cases (obtener historial, sincronizar, etc.)

  AsistenciaBloc({
    required this.registrarAsistenciaUseCase,
  }) : super(const AsistenciaInitial()) {
    on<RegistrarAsistenciaEvent>(_onRegistrarAsistencia);
    on<CargarHistorialEvent>(_onCargarHistorial);
    on<SincronizarAsistenciasEvent>(_onSincronizarAsistencias);
  }

  Future<void> _onRegistrarAsistencia(
    RegistrarAsistenciaEvent event,
    Emitter<AsistenciaState> emit,
  ) async {
    emit(const AsistenciaLoading());

    // TODO: Obtener ubicación actual
    // TODO: Capturar foto
    // TODO: Obtener userId del usuario autenticado

    // Ejemplo de uso del caso de uso
    // final params = RegistrarAsistenciaParams(
    //   userId: 'user_id',
    //   timestamp: DateTime.now(),
    //   latitude: 0.0,
    //   longitude: 0.0,
    //   tipo: event.tipo,
    //   fotoPath: 'foto_path',
    //   observaciones: event.observaciones,
    // );
    //
    // final result = await registrarAsistenciaUseCase(params);
    //
    // result.fold(
    //   (failure) => emit(AsistenciaError(failure.message)),
    //   (asistencia) => emit(AsistenciaRegistradaSuccess(asistencia)),
    // );
  }

  Future<void> _onCargarHistorial(
    CargarHistorialEvent event,
    Emitter<AsistenciaState> emit,
  ) async {
    emit(const AsistenciaLoading());

    // TODO: Implementar con el use case correspondiente
  }

  Future<void> _onSincronizarAsistencias(
    SincronizarAsistenciasEvent event,
    Emitter<AsistenciaState> emit,
  ) async {
    emit(const AsistenciaLoading());

    // TODO: Implementar con el use case correspondiente
  }
}
