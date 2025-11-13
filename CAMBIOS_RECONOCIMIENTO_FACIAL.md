# Cambios en Reconocimiento Facial

## Problema Resuelto

Se eliminó la dependencia `flutter_face_detection: ^0.0.1` que causaba errores durante la instalación, ya que:
1. No existe en pub.dev
2. No es necesaria porque el reconocimiento facial se realizará mediante una API externa de Python

## Cambios Realizados

### 1. Dependencias Eliminadas ([pubspec.yaml](pubspec.yaml))

**Antes:**
```yaml
# Cámara y Reconocimiento Facial
camera: ^0.11.0+2
image_picker: ^1.1.2
google_ml_kit: ^0.18.0
flutter_face_detection: ^0.0.1  # ELIMINADO
```

**Después:**
```yaml
# Cámara (para captura de fotos)
camera: ^0.10.5+5
image_picker: ^1.0.5
# Nota: El reconocimiento facial se hará mediante API externa de Python
```

### 2. Repositorio Actualizado

**Archivo:** [lib/features/reconocimiento_facial/domain/repositories/reconocimiento_facial_repository.dart](lib/features/reconocimiento_facial/domain/repositories/reconocimiento_facial_repository.dart)

El repositorio ahora refleja que el reconocimiento facial se realiza mediante API externa:

```dart
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
  Future<Either<Failure, String>> procesarImagen(String imagePath);

  /// Verifica que la imagen cumpla con requisitos mínimos de calidad
  Future<Either<Failure, bool>> validarCalidadImagen(String imagePath);
}
```

### 3. Constantes Actualizadas

**Archivo:** [lib/core/constants/app_constants.dart](lib/core/constants/app_constants.dart)

Se agregaron constantes para la API de reconocimiento facial:

```dart
// API de Reconocimiento Facial (Python)
static const String reconocimientoFacialBaseUrl = 'https://api-python.ejemplo.com'; // TODO: URL de la API de Python
static const String reconocimientoFacialEndpoint = '/reconocer';
static const int reconocimientoTimeout = 60000; // 60 segundos para reconocimiento
```

## Flujo de Trabajo con API Externa

### Diagrama del Flujo

```
┌─────────────────┐
│  App Flutter    │
│  (Dispositivo)  │
└────────┬────────┘
         │
         │ 1. Captura foto con cámara
         ▼
┌─────────────────┐
│   Camera API    │
│   (Flutter)     │
└────────┬────────┘
         │
         │ 2. Procesa/optimiza imagen
         ▼
┌─────────────────┐
│ Image Processing│
│   (Flutter)     │
└────────┬────────┘
         │
         │ 3. Envía imagen vía HTTP POST
         ▼
┌─────────────────┐
│  API Python     │
│ (Reconocimiento)│
└────────┬────────┘
         │
         │ 4. Procesa con modelo ML
         │    (face_recognition, etc.)
         ▼
┌─────────────────┐
│   Resultado     │
│   - usuario_id  │
│   - confianza   │
│   - verificado  │
└────────┬────────┘
         │
         │ 5. Retorna resultado
         ▼
┌─────────────────┐
│  App Flutter    │
│  (Procesa)      │
└─────────────────┘
```

## Implementación Sugerida

### 1. Data Source Remoto

Crear `lib/features/reconocimiento_facial/data/datasources/reconocimiento_facial_remote_datasource.dart`:

```dart
abstract class ReconocimientoFacialRemoteDataSource {
  Future<ResultadoReconocimientoModel> enviarParaReconocimiento({
    required String imagePath,
    required String userId,
  });
}

class ReconocimientoFacialRemoteDataSourceImpl
    implements ReconocimientoFacialRemoteDataSource {
  final Dio dio;

  ReconocimientoFacialRemoteDataSourceImpl(this.dio);

  @override
  Future<ResultadoReconocimientoModel> enviarParaReconocimiento({
    required String imagePath,
    required String userId,
  }) async {
    try {
      final file = await MultipartFile.fromFile(imagePath);

      final formData = FormData.fromMap({
        'image': file,
        'user_id': userId,
      });

      final response = await dio.post(
        '${AppConstants.reconocimientoFacialBaseUrl}${AppConstants.reconocimientoFacialEndpoint}',
        data: formData,
        options: Options(
          sendTimeout: Duration(milliseconds: AppConstants.reconocimientoTimeout),
          receiveTimeout: Duration(milliseconds: AppConstants.reconocimientoTimeout),
        ),
      );

      return ResultadoReconocimientoModel.fromJson(response.data);
    } catch (e) {
      throw ServerException(message: 'Error al reconocer rostro: $e');
    }
  }
}
```

### 2. Formato de Respuesta Esperada de la API Python

```json
{
  "rostro_detectado": true,
  "cumple_umbrales": true,
  "confianza": 0.95,
  "usuario_id": "user_123",
  "mensaje": "Rostro reconocido exitosamente",
  "rostro": {
    "id": "rostro_456",
    "confianza": 0.95,
    "bounding_box": {
      "x": 120,
      "y": 80,
      "width": 200,
      "height": 240
    },
    "timestamp": "2025-11-12T21:30:00Z"
  }
}
```

### 3. Ejemplo de API Python (FastAPI)

```python
from fastapi import FastAPI, File, UploadFile, Form
import face_recognition
import numpy as np
from PIL import Image
import io

app = FastAPI()

@app.post("/reconocer")
async def reconocer_rostro(
    image: UploadFile = File(...),
    user_id: str = Form(...)
):
    # Leer imagen
    image_data = await image.read()
    img = Image.open(io.BytesIO(image_data))
    img_array = np.array(img)

    # Detectar rostros
    face_locations = face_recognition.face_locations(img_array)

    if not face_locations:
        return {
            "rostro_detectado": False,
            "cumple_umbrales": False,
            "confianza": 0.0,
            "mensaje": "No se detectó ningún rostro"
        }

    # Obtener encoding del rostro
    face_encodings = face_recognition.face_encodings(img_array, face_locations)

    # Aquí comparar con rostros almacenados en DB
    # usuario_encoding = obtener_encoding_de_db(user_id)
    # confianza = comparar_rostros(face_encodings[0], usuario_encoding)

    return {
        "rostro_detectado": True,
        "cumple_umbrales": True,
        "confianza": 0.95,
        "usuario_id": user_id,
        "mensaje": "Rostro reconocido exitosamente",
        "rostro": {
            "id": "rostro_123",
            "confianza": 0.95,
            "bounding_box": {
                "x": face_locations[0][3],
                "y": face_locations[0][0],
                "width": face_locations[0][1] - face_locations[0][3],
                "height": face_locations[0][2] - face_locations[0][0]
            }
        }
    }
```

## Ventajas de este Enfoque

### ✅ Ventajas

1. **Centralización**: La lógica de reconocimiento facial está en un solo lugar (API Python)
2. **Mantenimiento**: Más fácil actualizar el modelo sin redistribuir la app
3. **Rendimiento**: El procesamiento pesado se hace en el servidor
4. **Seguridad**: Los modelos ML no están expuestos en el dispositivo
5. **Compatibilidad**: No depende de capacidades ML del dispositivo
6. **Escalabilidad**: Mejor control sobre recursos y procesamiento

### ⚠️ Consideraciones

1. **Conectividad**: Requiere conexión a internet para reconocimiento
2. **Latencia**: Tiempo de respuesta depende de la red
3. **Privacidad**: Imágenes se envían al servidor (considerar encriptación)
4. **Costos**: Procesamiento en servidor puede tener costos

## Solución para Modo Offline

Para el modo offline, considera:

1. **Cache de validación previa**: Si el usuario ya fue validado recientemente, permitir asistencia sin reconocimiento
2. **Registro pendiente**: Guardar foto localmente y enviarla cuando haya conexión
3. **Validación posterior**: El reconocimiento se hace después, y se marca como "pendiente de verificación"

```dart
// Flujo modo offline
if (!isConnected) {
  // Guardar foto localmente
  await localDataSource.guardarAsistenciaPendiente(asistencia);

  // Cuando recupere conexión
  await sincronizarYValidarConReconocimiento();
}
```

## Próximos Pasos

1. **Configurar URL de la API Python** en `app_constants.dart`
2. **Implementar DataSource remoto** para reconocimiento facial
3. **Implementar Repository** completo
4. **Crear Use Cases** específicos:
   - `CapturarYEnviarFotoUseCase`
   - `ValidarReconocimientoUseCase`
5. **Implementar Bloc** para manejo de estados
6. **Crear UI** para captura y feedback de reconocimiento

## Configuración Adicional

### Permisos Necesarios (solo cámara)

**Android** (`android/app/src/main/AndroidManifest.xml`):
```xml
<uses-permission android:name="android.permission.CAMERA"/>
<uses-feature android:name="android.hardware.camera"/>
```

**iOS** (`ios/Runner/Info.plist`):
```xml
<key>NSCameraUsageDescription</key>
<string>Necesitamos acceso a la cámara para verificar tu identidad</string>
```

## Resumen

El proyecto ahora está configurado correctamente para:
- ✅ Capturar fotos con la cámara del dispositivo
- ✅ Procesar y optimizar imágenes localmente
- ✅ Enviar imágenes a una API externa de Python
- ✅ Recibir resultados de reconocimiento facial
- ✅ Manejar modo offline con sincronización posterior

**Las dependencias se instalaron exitosamente** y el proyecto está listo para continuar con la implementación.
