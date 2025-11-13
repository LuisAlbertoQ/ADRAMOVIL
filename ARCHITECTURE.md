# Documentación de Arquitectura

## Diagrama de Clean Architecture

```
┌─────────────────────────────────────────────────────────────────────┐
│                         PRESENTATION LAYER                          │
│  ┌───────────┐  ┌───────────┐  ┌─────────────────────────────────┐│
│  │  Widgets  │  │   Pages   │  │           BLoC                   ││
│  │           │  │           │  │  ┌──────────┐  ┌──────────┐     ││
│  │  - UI     │  │ - Screens │  │  │  Events  │  │  States  │     ││
│  │  - Forms  │  │ - Routes  │  │  └────┬─────┘  └─────▲────┘     ││
│  └───────────┘  └───────────┘  │       │              │          ││
│                                 │       └──────┬───────┘          ││
│                                 │              │                   ││
│                                 └──────────────┼───────────────────┘│
└─────────────────────────────────────────────┬─┘
                                              │
┌─────────────────────────────────────────────┴─────────────────────┐
│                          DOMAIN LAYER                              │
│  ┌──────────────┐  ┌───────────────┐  ┌────────────────────────┐ │
│  │   Entities   │  │  Repositories  │  │      Use Cases         │ │
│  │              │  │  (Interfaces)  │  │                        │ │
│  │ - Pure Dart  │  │                │  │ - Business Logic       │ │
│  │ - No deps    │  │  - Contracts   │  │ - Single Responsibility│ │
│  └──────────────┘  └───────────────┘  └────────────────────────┘ │
└─────────────────────────────────────────────┬─────────────────────┘
                                              │
┌─────────────────────────────────────────────┴─────────────────────┐
│                           DATA LAYER                               │
│  ┌──────────────┐  ┌───────────────┐  ┌────────────────────────┐ │
│  │    Models    │  │  Repositories  │  │     Data Sources       │ │
│  │              │  │ (Implementation│  │                        │ │
│  │ - fromJson   │  │                │  │  ┌──────────────────┐  │ │
│  │ - toJson     │  │  - Logic       │  │  │ Remote (API)     │  │ │
│  │ - fromMap    │  │  - Error       │  │  │ - Dio/Retrofit   │  │ │
│  │ - toMap      │  │    Handling    │  │  └──────────────────┘  │ │
│  └──────────────┘  └───────────────┘  │  ┌──────────────────┐  │ │
│                                        │  │ Local (DB)       │  │ │
│                                        │  │ - SQLite         │  │ │
│                                        │  │ - Hive           │  │ │
│                                        │  └──────────────────┘  │ │
│                                        └────────────────────────┘ │
└───────────────────────────────────────────────────────────────────┘
```

## Flujo de Datos Detallado

### 1. Registro de Asistencia (Ejemplo Completo)

```
┌──────────────┐
│    User      │
│  Taps button │
└──────┬───────┘
       │
       ▼
┌──────────────────────────────────────────┐
│  PRESENTATION - AsistenciaPage           │
│  - Muestra UI                            │
│  - context.read<AsistenciaBloc>().add()  │
└──────┬───────────────────────────────────┘
       │ RegistrarAsistenciaEvent
       ▼
┌──────────────────────────────────────────┐
│  PRESENTATION - AsistenciaBloc           │
│  - Recibe evento                         │
│  - Llama al UseCase                      │
└──────┬───────────────────────────────────┘
       │ RegistrarAsistenciaParams
       ▼
┌──────────────────────────────────────────┐
│  DOMAIN - RegistrarAsistenciaUseCase     │
│  - Valida reglas de negocio              │
│  - Llama al Repository                   │
└──────┬───────────────────────────────────┘
       │ call(params)
       ▼
┌──────────────────────────────────────────┐
│  DOMAIN - AsistenciaRepository Interface │
│  - Define contrato                       │
└──────┬───────────────────────────────────┘
       │
       ▼
┌──────────────────────────────────────────┐
│  DATA - AsistenciaRepositoryImpl         │
│  - Implementa lógica                     │
│  - Coordina datasources                  │
│  - Maneja errores                        │
└──────┬───────────────────────────────────┘
       │
       ├─────────────────┬────────────────┐
       │                 │                │
       ▼                 ▼                ▼
┌─────────────┐  ┌──────────────┐  ┌────────────┐
│   Local     │  │   Remote     │  │  Network   │
│ DataSource  │  │ DataSource   │  │    Info    │
│             │  │              │  │            │
│ - SQLite    │  │ - API call   │  │ - Check    │
│ - Hive      │  │ - Retrofit   │  │   status   │
└─────┬───────┘  └──────┬───────┘  └────────────┘
      │                 │
      │ AsistenciaModel │
      ▼                 ▼
┌─────────────────────────────────────┐
│  Either<Failure, AsistenciaEntity>  │
│  - Left: Error                      │
│  - Right: Success                   │
└─────┬───────────────────────────────┘
      │
      ▼
┌──────────────────────────────────────────┐
│  PRESENTATION - AsistenciaBloc           │
│  - Procesa resultado                     │
│  - Emite nuevo estado                    │
└──────┬───────────────────────────────────┘
       │ AsistenciaState
       ▼
┌──────────────────────────────────────────┐
│  PRESENTATION - AsistenciaPage           │
│  - BlocBuilder se reconstruye            │
│  - Muestra resultado al usuario          │
└──────────────────────────────────────────┘
```

## Dependency Flow (Inversión de Dependencias)

```
PRESENTATION  ──depends on──►  DOMAIN  ◄──depends on──  DATA
    │                            ▲                        │
    │                            │                        │
    └────────────────────────────┴────────────────────────┘
                    (Interfaces/Abstractions)
```

**Regla fundamental:** Las capas externas dependen de las internas, nunca al revés.

- `Presentation` conoce `Domain`
- `Data` conoce `Domain`
- `Domain` NO conoce ni `Presentation` ni `Data`

## Módulos por Feature

### Feature: Asistencia

```
asistencia/
│
├── data/
│   ├── datasources/
│   │   ├── asistencia_local_datasource.dart
│   │   │   └── Implementación: AsistenciaLocalDataSourceImpl
│   │   └── asistencia_remote_datasource.dart
│   │       └── Implementación: AsistenciaRemoteDataSourceImpl
│   │
│   ├── models/
│   │   └── asistencia_model.dart
│   │       ├── fromJson() - Desde API
│   │       ├── toJson()   - Para API
│   │       ├── fromMap()  - Desde DB local
│   │       └── toMap()    - Para DB local
│   │
│   └── repositories/
│       └── asistencia_repository_impl.dart
│           └── Implementa: AsistenciaRepository
│           └── Usa: LocalDataSource + RemoteDataSource + NetworkInfo
│
├── domain/
│   ├── entities/
│   │   └── asistencia_entity.dart
│   │       └── Pure Dart class (Equatable)
│   │
│   ├── repositories/
│   │   └── asistencia_repository.dart
│   │       └── Abstract class (contrato)
│   │
│   └── usecases/
│       ├── registrar_asistencia_usecase.dart
│       ├── obtener_historial_usecase.dart
│       └── sincronizar_asistencias_usecase.dart
│
└── presentation/
    ├── bloc/
    │   ├── asistencia_bloc.dart
    │   ├── asistencia_event.dart
    │   └── asistencia_state.dart
    │
    ├── pages/
    │   ├── registro_asistencia_page.dart
    │   └── historial_asistencia_page.dart
    │
    └── widgets/
        ├── asistencia_card.dart
        └── camera_preview_widget.dart
```

## Manejo de Errores

### Excepciones (Data Layer)

```dart
try {
  final result = await apiCall();
} catch (e) {
  throw ServerException(message: 'Error de servidor');
}
```

### Failures (Domain Layer)

```dart
Either<Failure, Entity> result;

if (error) {
  return Left(ServerFailure(message: 'Error'));
} else {
  return Right(entity);
}
```

### Estados (Presentation Layer)

```dart
BlocBuilder<AsistenciaBloc, AsistenciaState>(
  builder: (context, state) {
    if (state is AsistenciaError) {
      return ErrorWidget(state.mensaje);
    }
    // ...
  },
)
```

## Dependency Injection con GetIt

```
main.dart
  │
  └─► init() - injection_container.dart
       │
       ├─► Feature Blocs (Factory)
       │    └─► Se crean cada vez que se necesitan
       │
       ├─► Use Cases (LazySingleton)
       │    └─► Una instancia, creada al primer uso
       │
       ├─► Repositories (LazySingleton)
       │
       ├─► DataSources (LazySingleton)
       │
       └─► External (LazySingleton)
            ├─► Dio
            ├─► Database
            ├─► Connectivity
            └─► SharedPreferences
```

### Registro de Dependencias

```dart
// Factory - Nueva instancia cada vez
sl.registerFactory(() => AsistenciaBloc(useCase: sl()));

// LazySingleton - Una sola instancia (lazy)
sl.registerLazySingleton(() => RegistrarAsistenciaUseCase(sl()));

// Singleton - Una sola instancia (eager)
sl.registerSingleton(SomeClass());
```

## Modo Offline - Estrategia de Sincronización

```
┌──────────────┐
│  User Action │
└──────┬───────┘
       │
       ▼
┌─────────────────────────────────┐
│  NetworkInfo.isConnected?       │
└─────┬────────────────────┬──────┘
      │                    │
   No │                    │ Yes
      ▼                    ▼
┌─────────────────┐  ┌──────────────────┐
│ Save to Local   │  │ Save to Local    │
│ sincronizado:   │  │ + Send to API    │
│   false         │  │ sincronizado:    │
└─────────────────┘  │   true           │
                     └──────────────────┘
       │
       │ On Network Restored
       ▼
┌──────────────────────────────────┐
│  SyncService (Background)        │
│  1. Get pending records          │
│  2. Upload photos                │
│  3. Send to API                  │
│  4. Mark as synchronized         │
│  5. Retry with backoff on error  │
└──────────────────────────────────┘
```

### Lógica de Retry

```
Attempt 1: Immediate
Attempt 2: 5 seconds
Attempt 3: 15 seconds
Attempt 4: Give up, keep pending
```

## Testing Strategy

### Unit Tests (Domain Layer)

```dart
test('should return AsistenciaEntity when successful', () async {
  // Arrange
  when(mockRepository.registrarAsistencia(...))
    .thenAnswer((_) async => Right(tAsistenciaEntity));

  // Act
  final result = await useCase(params);

  // Assert
  expect(result, Right(tAsistenciaEntity));
});
```

### Bloc Tests

```dart
blocTest<AsistenciaBloc, AsistenciaState>(
  'should emit [Loading, Success] when successful',
  build: () => asistenciaBloc,
  act: (bloc) => bloc.add(RegistrarAsistenciaEvent()),
  expect: () => [
    AsistenciaLoading(),
    AsistenciaRegistradaSuccess(asistencia),
  ],
);
```

### Widget Tests

```dart
testWidgets('should display asistencia when loaded', (tester) async {
  await tester.pumpWidget(makeTestableWidget(AsistenciaPage()));
  expect(find.byType(AsistenciaCard), findsOneWidget);
});
```

## Buenas Prácticas Implementadas

### SOLID Principles

- **S**ingle Responsibility: Cada clase tiene una única razón para cambiar
- **O**pen/Closed: Abierto para extensión, cerrado para modificación
- **L**iskov Substitution: Los subtipos deben ser sustituibles por sus tipos base
- **I**nterface Segregation: Interfaces específicas mejor que una general
- **D**ependency Inversion: Depender de abstracciones, no de concreciones

### DRY (Don't Repeat Yourself)

- Código común en `core/`
- Widgets reutilizables
- UseCase base abstracto

### KISS (Keep It Simple, Stupid)

- Código fácil de leer
- Funciones pequeñas
- Nombres descriptivos

### YAGNI (You Aren't Gonna Need It)

- Implementar solo lo necesario
- No código especulativo
- Evolucionar según necesidades

## Recursos Adicionales

- [Clean Architecture - Uncle Bob](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [Flutter BLoC Pattern](https://bloclibrary.dev/)
- [Reso Coder - Flutter Clean Architecture](https://resocoder.com/flutter-clean-architecture-tdd/)
- [Functional Programming with Dartz](https://pub.dev/packages/dartz)
