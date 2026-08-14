/// Represents a Division tier in Zevo.
class Division {
  final String id;
  final String name; // Rookie, Athlete, Pro, Elite, Legend
  final int tier;
  final String description;

  Division({
    required this.id,
    required this.name,
    required this.tier,
    required this.description,
  });

  /// Creates a Division instance from a JSON map.
  factory Division.fromJson(Map<String, dynamic> json) {
    return Division(
      id: json['id'] as String,
      name: json['name'] as String,
      tier: json['tier'] as int,
      description: json['description'] as String,
    );
  }

  /// Converts the Division instance to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'tier': tier,
      'description': description,
    };
  }
}
