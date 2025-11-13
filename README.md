# Sistema de Asistencia ADRA - App Móvil

Sistema de registro de asistencia con reconocimiento facial y geolocalización para trabajadores de campo, desarrollado con Flutter y Clean Architecture.

## Características Principales

- **Registro de asistencia** con reconocimiento facial
- **Geolocalización GPS** y validación de zona permitida
- **Modo Offline** con sincronización automática
- **Justificaciones** de ausencias
- **Historial de asistencias**
- Arquitectura limpia y escalable

---

## Arquitectura del Proyecto

Este proyecto sigue los principios de **Clean Architecture** propuesta por Robert C. Martin (Uncle Bob), dividida en 3 capas principales:

### 1. Domain Layer (Capa de Dominio)
Contiene la lógica de negocio pura, independiente de frameworks y librerías externas.

- **Entities**: Modelos de dominio puros
- **Repositories**: Interfaces/contratos abstractos
- **Use Cases**: Casos de uso de la aplicación

### 2. Data Layer (Capa de Datos)
Implementa los repositorios y maneja las fuentes de datos.

- **Models**: Modelos con serialización (extienden las entidades)
- **Data Sources**:
  - Remote (API)
  - Local (SQLite, Hive)
- **Repositories Implementation**: Implementación concreta de los repositorios

### 3. Presentation Layer (Capa de Presentación)
Maneja la UI y la interacción con el usuario.

- **Bloc**: Manejo de estado con flutter_bloc
- **Pages**: Pantallas de la aplicación
- **Widgets**: Componentes reutilizables

---

## Estructura de Carpetas

```
lib/
├── core/                          # Funcionalidades compartidas
│   ├── constants/                 # Constantes globales
│   │   └── app_constants.dart
│   ├── errors/                    # Manejo de errores
│   │   ├── exceptions.dart
│   │   └── failures.dart
│   ├── network/                   # Conectividad y red
│   │   └── network_info.dart
│   ├── usecases/                  # Caso de uso base
│   │   └── usecase.dart
│   ├── utils/                     # Utilidades
│   │   └── logger.dart
│   └── widgets/                   # Widgets compartidos
│
├── features/                      # Módulos de la aplicación
│   ├── asistencia/                # Feature: Registro de asistencia
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   ├── asistencia_local_datasource.dart
│   │   │   │   └── asistencia_remote_datasource.dart
│   │   │   ├── models/
│   │   │   │   └── asistencia_model.dart
│   │   │   └── repositories/
│   │   │       └── asistencia_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── asistencia_entity.dart
│   │   │   ├── repositories/
│   │   │   │   └── asistencia_repository.dart
│   │   │   └── usecases/
│   │   │       └── registrar_asistencia_usecase.dart
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── asistencia_bloc.dart
│   │       │   ├── asistencia_event.dart
│   │       │   └── asistencia_state.dart
│   │       ├── pages/
│   │       └── widgets/
│   │
│   ├── geolocalizacion/           # Feature: Geolocalización y zonas
│   │   ├── data/
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── ubicacion_entity.dart
│   │   │   └── repositories/
│   │   │       └── geolocalizacion_repository.dart
│   │   └── presentation/
│   │
│   ├── reconocimiento_facial/     # Feature: Reconocimiento facial
│   │   ├── data/
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── rostro_entity.dart
│   │   │   └── repositories/
│   │   │       └── reconocimiento_facial_repository.dart
│   │   └── presentation/
│   │
│   ├── justificaciones/           # Feature: Justificaciones
│   │   ├── data/
│   │   ├── domain/
│   │   │   └── entities/
│   │   │       └── justificacion_entity.dart
│   │   └── presentation/
│   │
│   └── sincronizacion/            # Feature: Sincronización offline
│       ├── data/
│       ├── domain/
│       │   ├── entities/
│       │   │   └── sync_status_entity.dart
│       │   └── repositories/
│       │       └── sincronizacion_repository.dart
│       └── presentation/
│
├── injection/                     # Dependency Injection
│   └── injection_container.dart
│
└── main.dart                      # Punto de entrada
```

---

## Tecnologías y Dependencias

### State Management
- **flutter_bloc**: Manejo de estado reactivo
- **equatable**: Comparación de objetos

### Networking
- **dio**: Cliente HTTP
- **retrofit**: REST API client
- **connectivity_plus**: Estado de conectividad

### Local Storage
- **sqflite**: Base de datos SQLite local
- **hive**: Base de datos NoSQL rápida
- **shared_preferences**: Preferencias simples

### Geolocalización
- **geolocator**: Obtener ubicación GPS
- **geocoding**: Geocoding y reverse geocoding
- **google_maps_flutter**: Mapas de Google
- **flutter_map**: Mapas alternativos

### Cámara y ML
- **camera**: Acceso a la cámara
- **image_picker**: Seleccionar imágenes
- **google_ml_kit**: ML Kit de Google
- **flutter_face_detection**: Detección facial

### Dependency Injection
- **get_it**: Service locator
- **injectable**: Generación de código para DI

### Utilidades
- **dartz**: Programación funcional (Either)
- **logger**: Logging
- **intl**: Internacionalización y formateo
- **permission_handler**: Manejo de permisos

---

## Configuración Inicial

### 1. Instalar dependencias

```bash
cd asistencia_app
flutter pub get
```

### 2. Generar código

Para generar código de serialización, injectable, etc:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 3. Configurar API

Edita `lib/core/constants/app_constants.dart` y actualiza:
- `baseUrl`: URL de tu API
- Endpoints específicos según tu backend

### 4. Configurar permisos

#### Android (`android/app/src/main/AndroidManifest.xml`):

```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
<uses-permission android:name="android.permission.CAMERA"/>
<uses-feature android:name="android.hardware.camera"/>
```

#### iOS (`ios/Runner/Info.plist`):

```xml
<key>NSCameraUsageDescription</key>
<string>Necesitamos acceso a la cámara para el reconocimiento facial</string>
<key>NSLocationWhenInUseUsageDescription</key>
<string>Necesitamos tu ubicación para registrar la asistencia</string>
<key>NSLocationAlwaysUsageDescription</key>
<string>Necesitamos tu ubicación para registrar la asistencia</string>
```

---

## Flujo de Datos

### Ejemplo: Registrar Asistencia

```
UI (Widget)
  ↓ Dispara evento
Bloc (AsistenciaBloc)
  ↓ Ejecuta
Use Case (RegistrarAsistenciaUseCase)
  ↓ Llama a
Repository (AsistenciaRepository)
  ↓ Coordina
DataSources (Local + Remote)
  ↓ Retorna Either<Failure, Entity>
Bloc emite nuevo estado
  ↓
UI se actualiza
```

### Modo Offline

1. Usuario registra asistencia sin conexión
2. Se guarda localmente en SQLite/Hive con `sincronizado = false`
3. Cuando recupera conexión, el servicio de sincronización:
   - Detecta registros pendientes
   - Sube la foto al servidor
   - Envía los datos a la API
   - Marca como `sincronizado = true`

---

## Patrones Implementados

### Repository Pattern
Abstracción de fuentes de datos, permite cambiar implementación sin afectar la lógica de negocio.

### Use Case Pattern
Cada acción de usuario es un caso de uso independiente y testeable.

### Dependency Injection
GetIt + Injectable para inversión de control.

### Either Pattern (Dartz)
Manejo funcional de errores sin excepciones:
```dart
Either<Failure, Success>
```

### Bloc Pattern
Separación de lógica de negocio y UI:
```
Event → Bloc → State → UI
```

---

## Próximos Pasos de Implementación

### Fase 1: Configuración de Persistencia
- [ ] Implementar tablas SQLite
- [ ] Configurar Hive boxes
- [ ] Implementar LocalDataSource completos

### Fase 2: Integración de API
- [ ] Crear cliente Retrofit
- [ ] Implementar RemoteDataSource
- [ ] Configurar interceptors (auth, logging)

### Fase 3: Features Core
- [ ] Implementar módulo de autenticación
- [ ] Implementar reconocimiento facial
- [ ] Implementar geolocalización y validación de zonas
- [ ] Implementar registro de asistencia completo

### Fase 4: Sincronización
- [ ] Servicio de sincronización en background
- [ ] Cola de tareas pendientes
- [ ] Retry logic con backoff exponencial

### Fase 5: UI/UX
- [ ] Diseñar pantallas principales
- [ ] Implementar navegación
- [ ] Agregar animaciones y feedback visual
- [ ] Manejo de estados de carga y error

### Fase 6: Testing
- [ ] Tests unitarios de use cases
- [ ] Tests de repositories
- [ ] Tests de bloc
- [ ] Tests de integración

---

## Comandos Útiles

### Ejecutar app
```bash
flutter run
```

### Generar código
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Análisis de código
```bash
flutter analyze
```

### Formatear código
```bash
dart format lib/
```

### Tests
```bash
flutter test
```

### Build para producción
```bash
# Android
flutter build apk --release

# iOS
flutter build ios --release
```

---

## Consideraciones Importantes

### Seguridad
- Nunca commitear archivos `.env` o con API keys
- Usar HTTPS para todas las comunicaciones
- Validar datos en servidor, no confiar solo en cliente
- Encriptar datos sensibles en storage local

### Rendimiento
- Optimizar imágenes antes de subir (máx 1MB)
- Implementar paginación en listas largas
- Usar lazy loading para imágenes
- Limpiar registros sincronizados antiguos

### Offline First
- Toda operación crítica debe funcionar sin conexión
- Sincronizar en background cuando hay conexión
- Informar al usuario del estado de sincronización
- Implementar retry automático con límite

---

## Soporte

Para preguntas o problemas:
1. Revisar la documentación de Flutter: https://flutter.dev
2. Consultar Clean Architecture: https://blog.cleancoder.com
3. Revisar issues conocidos en el repositorio

---

## Licencia

[Especificar licencia del proyecto]

---

## Contribuciones

[Especificar proceso de contribución si aplica]
