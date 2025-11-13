# Guía para Comenzar a Desarrollar

## Paso 1: Instalar Dependencias

```bash
cd asistencia_app
flutter pub get
```

Si hay errores de versión, actualiza Flutter:
```bash
flutter upgrade
flutter pub get
```

---

## Paso 2: Configurar la API

### 2.1 Editar constantes

Abre `lib/core/constants/app_constants.dart` y configura:

```dart
// Cambia esta URL por tu API real
static const String baseUrl = 'https://tu-api.com';

// Actualiza los endpoints según tu backend
static const String loginEndpoint = '/auth/login';
static const String asistenciaEndpoint = '/asistencia';
// ...
```

### 2.2 Crear archivo .env (opcional)

Si prefieres usar variables de entorno:

```bash
# Crear archivo .env en la raíz
echo "API_BASE_URL=https://tu-api.com" > .env
```

Luego instala el paquete:
```yaml
# En pubspec.yaml
dependencies:
  flutter_dotenv: ^5.1.0
```

---

## Paso 3: Configurar Permisos

### Android

Abre `android/app/src/main/AndroidManifest.xml` y agrega:

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <!-- Permisos -->
    <uses-permission android:name="android.permission.INTERNET"/>
    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
    <uses-permission android:name="android.permission.CAMERA"/>

    <!-- Features -->
    <uses-feature android:name="android.hardware.camera"/>
    <uses-feature android:name="android.hardware.location.gps"/>

    <application>
        <!-- ... -->
    </application>
</manifest>
```

### iOS

Abre `ios/Runner/Info.plist` y agrega:

```xml
<key>NSCameraUsageDescription</key>
<string>Necesitamos acceso a la cámara para tomar fotos de asistencia</string>

<key>NSLocationWhenInUseUsageDescription</key>
<string>Necesitamos tu ubicación para verificar que estás en la zona permitida</string>

<key>NSLocationAlwaysUsageDescription</key>
<string>Necesitamos tu ubicación para registrar asistencias</string>

<key>NSPhotoLibraryUsageDescription</key>
<string>Necesitamos acceso a tus fotos para adjuntar documentos</string>
```

---

## Paso 4: Implementar Base de Datos Local

### 4.1 SQLite para Asistencias

Crea `lib/core/database/database_helper.dart`:

```dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('asistencia.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE asistencias (
        id TEXT PRIMARY KEY,
        user_id TEXT NOT NULL,
        timestamp TEXT NOT NULL,
        latitude REAL NOT NULL,
        longitude REAL NOT NULL,
        foto_path TEXT,
        tipo TEXT NOT NULL,
        sincronizado INTEGER NOT NULL,
        observaciones TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE justificaciones (
        id TEXT PRIMARY KEY,
        user_id TEXT NOT NULL,
        fecha TEXT NOT NULL,
        motivo TEXT NOT NULL,
        descripcion TEXT NOT NULL,
        adjunto_path TEXT,
        estado TEXT NOT NULL,
        created_at TEXT NOT NULL,
        sincronizado INTEGER NOT NULL
      )
    ''');
  }
}
```

### 4.2 Implementar LocalDataSource

Actualiza `lib/features/asistencia/data/datasources/asistencia_local_datasource.dart`:

```dart
class AsistenciaLocalDataSourceImpl implements AsistenciaLocalDataSource {
  final DatabaseHelper databaseHelper;

  AsistenciaLocalDataSourceImpl(this.databaseHelper);

  @override
  Future<AsistenciaModel> guardarAsistencia(AsistenciaModel asistencia) async {
    final db = await databaseHelper.database;

    final id = const Uuid().v4();
    final asistenciaConId = asistencia.copyWith(id: id);

    await db.insert(
      'asistencias',
      asistenciaConId.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return asistenciaConId;
  }

  @override
  Future<List<AsistenciaModel>> obtenerAsistencias() async {
    final db = await databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('asistencias');

    return List.generate(maps.length, (i) {
      return AsistenciaModel.fromMap(maps[i]);
    });
  }

  @override
  Future<List<AsistenciaModel>> obtenerAsistenciasPendientes() async {
    final db = await databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'asistencias',
      where: 'sincronizado = ?',
      whereArgs: [0],
    );

    return List.generate(maps.length, (i) {
      return AsistenciaModel.fromMap(maps[i]);
    });
  }

  // Implementar demás métodos...
}
```

---

## Paso 5: Implementar Cliente HTTP (Retrofit)

### 5.1 Crear API Client

Crea `lib/core/network/api_client.dart`:

```dart
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:asistencia_app/core/constants/app_constants.dart';

part 'api_client.g.dart';

@RestApi(baseUrl: AppConstants.baseUrl)
abstract class ApiClient {
  factory ApiClient(Dio dio, {String baseUrl}) = _ApiClient;

  // Asistencias
  @POST('/asistencia')
  Future<Map<String, dynamic>> enviarAsistencia(
    @Body() Map<String, dynamic> body,
  );

  @GET('/asistencia/{userId}')
  Future<List<Map<String, dynamic>>> obtenerHistorial(
    @Path('userId') String userId,
    @Query('fechaInicio') String? fechaInicio,
    @Query('fechaFin') String? fechaFin,
  );

  @POST('/upload/foto')
  @MultiPart()
  Future<Map<String, dynamic>> subirFoto(
    @Part(name: 'file') File file,
  );
}
```

### 5.2 Configurar Dio con Interceptors

Crea `lib/core/network/dio_client.dart`:

```dart
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class DioClient {
  static Dio createDio() {
    final dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Logger
    dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
      ),
    );

    // Auth Interceptor
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // TODO: Agregar token de autenticación
          // final token = await getToken();
          // options.headers['Authorization'] = 'Bearer $token';
          return handler.next(options);
        },
        onError: (error, handler) {
          // Manejar errores globalmente
          return handler.next(error);
        },
      ),
    );

    return dio;
  }
}
```

### 5.3 Generar código

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

---

## Paso 6: Actualizar Dependency Injection

Actualiza `lib/injection/injection_container.dart`:

```dart
import 'package:dio/dio.dart';
import 'package:sqflite/sqflite.dart';
// ... otros imports

Future<void> init() async {
  //! External
  // Dio
  final dio = DioClient.createDio();
  sl.registerLazySingleton(() => dio);

  // API Client
  sl.registerLazySingleton(() => ApiClient(sl()));

  // Database
  sl.registerLazySingleton(() => DatabaseHelper.instance);

  // Connectivity
  sl.registerLazySingleton(() => Connectivity());

  //! Core
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(sl()),
  );

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
    () => AsistenciaRemoteDataSourceImpl(sl()), // Pasarle ApiClient
  );

  sl.registerLazySingleton<AsistenciaLocalDataSource>(
    () => AsistenciaLocalDataSourceImpl(sl()), // Pasarle DatabaseHelper
  );
}
```

---

## Paso 7: Crear Primera Pantalla (Registro de Asistencia)

Crea `lib/features/asistencia/presentation/pages/registro_asistencia_page.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:asistencia_app/features/asistencia/presentation/bloc/asistencia_bloc.dart';
import 'package:asistencia_app/injection/injection_container.dart' as di;

class RegistroAsistenciaPage extends StatelessWidget {
  const RegistroAsistenciaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.sl<AsistenciaBloc>(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Registrar Asistencia'),
        ),
        body: BlocConsumer<AsistenciaBloc, AsistenciaState>(
          listener: (context, state) {
            if (state is AsistenciaError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.mensaje)),
              );
            } else if (state is AsistenciaRegistradaSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Asistencia registrada')),
              );
            }
          },
          builder: (context, state) {
            if (state is AsistenciaLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.camera_alt, size: 100),
                  const SizedBox(height: 20),
                  const Text('Registra tu asistencia'),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () {
                      context.read<AsistenciaBloc>().add(
                        const RegistrarAsistenciaEvent(tipo: 'entrada'),
                      );
                    },
                    icon: const Icon(Icons.login),
                    label: const Text('Entrada'),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: () {
                      context.read<AsistenciaBloc>().add(
                        const RegistrarAsistenciaEvent(tipo: 'salida'),
                      );
                    },
                    icon: const Icon(Icons.logout),
                    label: const Text('Salida'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
```

Actualiza la navegación en `lib/main.dart`:

```dart
ElevatedButton.icon(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const RegistroAsistenciaPage(),
      ),
    );
  },
  icon: const Icon(Icons.camera_alt),
  label: const Text('Registrar Asistencia'),
),
```

---

## Paso 8: Ejecutar la Aplicación

```bash
# Verificar que todo está bien
flutter doctor

# Ejecutar en modo debug
flutter run

# O especificar dispositivo
flutter run -d chrome  # Para web
flutter run -d emulator-id  # Para Android/iOS
```

---

## Paso 9: Implementar Funcionalidades Faltantes

### TODO List por Prioridad:

1. **Alta prioridad:**
   - [ ] Implementar captura de cámara
   - [ ] Implementar obtención de GPS
   - [ ] Implementar sincronización en background
   - [ ] Implementar autenticación

2. **Media prioridad:**
   - [ ] Implementar reconocimiento facial
   - [ ] Implementar validación de zonas
   - [ ] Implementar justificaciones
   - [ ] Implementar historial

3. **Baja prioridad:**
   - [ ] Mejorar UI/UX
   - [ ] Agregar animaciones
   - [ ] Implementar notificaciones
   - [ ] Agregar reportes

---

## Comandos Útiles Durante el Desarrollo

```bash
# Watch mode para build_runner (regenera automáticamente)
flutter pub run build_runner watch

# Limpiar proyecto
flutter clean
flutter pub get

# Análisis de código
flutter analyze

# Formatear todo el código
dart format lib/ -l 80

# Ver dispositivos disponibles
flutter devices

# Ver logs en tiempo real
flutter logs

# Build para release
flutter build apk --release  # Android
flutter build ios --release  # iOS
```

---

## Recursos Útiles

### Documentación
- [Flutter Docs](https://docs.flutter.dev/)
- [Dart Docs](https://dart.dev/guides)
- [BLoC Pattern](https://bloclibrary.dev/)
- [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)

### Packages
- [Dio](https://pub.dev/packages/dio)
- [Retrofit](https://pub.dev/packages/retrofit)
- [SQLite](https://pub.dev/packages/sqflite)
- [Geolocator](https://pub.dev/packages/geolocator)
- [Camera](https://pub.dev/packages/camera)

### Tutoriales
- [Reso Coder - Flutter Clean Architecture](https://resocoder.com/flutter-clean-architecture-tdd/)
- [Flutter BLoC Tutorials](https://bloclibrary.dev/tutorials/flutter-counter/)

---

## Troubleshooting Común

### Error: "Waiting for another flutter command to release the startup lock"
```bash
rm ~/.flutter_tool_state
flutter doctor
```

### Error al generar código con build_runner
```bash
flutter clean
flutter pub get
flutter pub run build_runner clean
flutter pub run build_runner build --delete-conflicting-outputs
```

### Error de permisos en Android
Verifica que:
1. Los permisos están en AndroidManifest.xml
2. Estás pidiendo permisos en runtime (usa permission_handler)
3. El targetSdkVersion es correcto

### Error de pods en iOS
```bash
cd ios
pod deintegrate
pod install
cd ..
flutter clean
flutter run
```

---

## Contacto y Soporte

Para dudas o problemas:
1. Revisa la documentación en README.md y ARCHITECTURE.md
2. Busca en los issues del repositorio
3. Consulta Stack Overflow con el tag [flutter]
4. Lee la documentación oficial de Flutter

Buena suerte con el desarrollo! 🚀
