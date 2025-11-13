import 'package:asistencia_app/features/asistencia/domain/entities/asistencia_entity.dart';

/// Modelo de Asistencia (Data Layer)
/// Extiende la entidad y añade funcionalidad de serialización
class AsistenciaModel extends AsistenciaEntity {
  const AsistenciaModel({
    super.id,
    required super.userId,
    required super.timestamp,
    required super.latitude,
    required super.longitude,
    super.fotoPath,
    required super.tipo,
    super.sincronizado,
    super.observaciones,
  });

  /// Crea un modelo desde JSON (API)
  factory AsistenciaModel.fromJson(Map<String, dynamic> json) {
    return AsistenciaModel(
      id: json['id'] as String?,
      userId: json['user_id'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      fotoPath: json['foto_path'] as String?,
      tipo: json['tipo'] as String,
      sincronizado: json['sincronizado'] as bool? ?? false,
      observaciones: json['observaciones'] as String?,
    );
  }

  /// Convierte el modelo a JSON (para enviar a la API)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'timestamp': timestamp.toIso8601String(),
      'latitude': latitude,
      'longitude': longitude,
      'foto_path': fotoPath,
      'tipo': tipo,
      'sincronizado': sincronizado,
      'observaciones': observaciones,
    };
  }

  /// Crea un modelo desde un Map local (SQLite/Hive)
  factory AsistenciaModel.fromMap(Map<String, dynamic> map) {
    return AsistenciaModel(
      id: map['id'] as String?,
      userId: map['user_id'] as String,
      timestamp: DateTime.parse(map['timestamp'] as String),
      latitude: map['latitude'] as double,
      longitude: map['longitude'] as double,
      fotoPath: map['foto_path'] as String?,
      tipo: map['tipo'] as String,
      sincronizado: (map['sincronizado'] as int) == 1,
      observaciones: map['observaciones'] as String?,
    );
  }

  /// Convierte el modelo a Map (para almacenar localmente)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'timestamp': timestamp.toIso8601String(),
      'latitude': latitude,
      'longitude': longitude,
      'foto_path': fotoPath,
      'tipo': tipo,
      'sincronizado': sincronizado ? 1 : 0,
      'observaciones': observaciones,
    };
  }

  /// Copia el modelo con campos modificados
  AsistenciaModel copyWith({
    String? id,
    String? userId,
    DateTime? timestamp,
    double? latitude,
    double? longitude,
    String? fotoPath,
    String? tipo,
    bool? sincronizado,
    String? observaciones,
  }) {
    return AsistenciaModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      timestamp: timestamp ?? this.timestamp,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      fotoPath: fotoPath ?? this.fotoPath,
      tipo: tipo ?? this.tipo,
      sincronizado: sincronizado ?? this.sincronizado,
      observaciones: observaciones ?? this.observaciones,
    );
  }
}
