final String tableSlimes = 'slimes';

class Slime {
  final int? id;
  final String? name;
  final bool isFavourite;
  final DateTime timestamp;
  final int colorGeneA;
  final int colorGeneB;

  const Slime({
    this.id,
    this.name,
    this.isFavourite = false,
    required this.timestamp,
    required this.colorGeneA,
    required this.colorGeneB,
  });

  Slime copy({
    int? id,
    String? name,
    bool? isFavourite,
    DateTime? timestamp,
    int? colorGeneA,
    int? colorGeneB,
  }) => Slime(
    id: id ?? this.id,
    name: name ?? this.name,
    isFavourite: isFavourite ?? this.isFavourite,
    timestamp: timestamp ?? this.timestamp,
    colorGeneA: colorGeneA ?? this.colorGeneA,
    colorGeneB: colorGeneB ?? this.colorGeneB,
  );

  static Slime fromJson(Map<String, Object?> json) => Slime(
    id: json[SlimeFields.id] as int?,
    name: json[SlimeFields.name] as String,
    isFavourite: json[SlimeFields.isFavourite] == 1,
    timestamp: DateTime.parse(json[SlimeFields.timestamp] as String),
    colorGeneA: json[SlimeFields.colorGeneA] as int,
    colorGeneB: json[SlimeFields.colorGeneB] as int,
  );

  Map<String, Object?> toJson() => {
    SlimeFields.id: id,
    SlimeFields.name: name,
    SlimeFields.isFavourite: isFavourite ? 1 : 0,
    SlimeFields.timestamp: timestamp.toIso8601String(),
    SlimeFields.colorGeneA: colorGeneA,
    SlimeFields.colorGeneB: colorGeneB,
  };
}

class SlimeFields {
  static final List<String> values = [
    id,
    name,
    isFavourite,
    timestamp,
    colorGeneA,
    colorGeneB,
  ];

  static final String id = '_id';
  static final String name = 'name';
  static final String isFavourite = 'isFavourite';
  static final String timestamp = 'timestamp';
  static final String colorGeneA = 'colorGeneA';
  static final String colorGeneB = 'colorGeneB';
}