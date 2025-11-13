import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:asistencia_app/core/errors/failures.dart';

/// Clase base abstracta para todos los casos de uso
///
/// [Type] - Tipo de dato que retorna el caso de uso
/// [Params] - Parámetros que recibe el caso de uso
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

/// Clase para casos de uso sin parámetros
class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
}
