// lib/models/pokemon.dart
class Pokemon {
  final int id;
  final String name;
  final String imageUrl;
  final int height; // decimeters
  final int weight; // hectograms
  final List<String> abilities;
  final List<String> types;

  Pokemon({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.height,
    required this.weight,
    required this.abilities,
    required this.types,
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    final sprite = (json['sprites'] ?? {}) as Map<String, dynamic>;
    final other = (sprite['other'] ?? {}) as Map<String, dynamic>;
    final official = (other['official-artwork'] ?? {}) as Map<String, dynamic>;
    final image = official['front_default'] ?? sprite['front_default'] ?? '';

    return Pokemon(
      id: json['id'] as int,
      name: json['name'] as String,
      imageUrl: image as String,
      height: (json['height'] as int),
      weight: (json['weight'] as int),
      abilities: (json['abilities'] as List)
          .map((a) => a['ability']['name'] as String)
          .toList(),
      types: (json['types'] as List)
          .map((t) => t['type']['name'] as String)
          .toList(),
    );
  }
}
