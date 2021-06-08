import 'package:json_annotation/json_annotation.dart';

final String tableSlimes = 'slimes';

@JsonSerializable(explicitToJson: true)
class Slime {
  final int? id;
  final DateTime timestamp;
  final int colorIndex;

  const Slime({
    this.id,
    required this.timestamp,
    required this.colorIndex,
  });

  Slime copy({
    int? id,
    DateTime? timestamp,
    int? colorIndex,
  }) => Slime(
    id: id ?? this.id,
    timestamp: timestamp ?? this.timestamp,
    colorIndex: colorIndex ?? this.colorIndex,
  );

  static Slime fromJson(Map<String, Object?> json) => Slime(
    id: json[SlimeFields.id] as int?,
    timestamp: DateTime.parse(json[SlimeFields.timestamp] as String),
    colorIndex: json[SlimeFields.colorIndex] as int,
  );

  Map<String, Object?> toJson() => {
    SlimeFields.id: id,
    SlimeFields.timestamp: timestamp.toIso8601String(),
    SlimeFields.colorIndex: colorIndex,
  };
}

class SlimeFields {
  static final List<String> values = [
    id,
    timestamp,
    colorIndex,
  ];

  static final String id = '_id';
  static final String timestamp = 'timestamp';
  static final String colorIndex = 'colorGeneA';
}