/// Represents a Squad entity in Zevo.
class Squad {
  final String id;
  final String name;
  final String? logoUrl;
  final String captainId;
  final bool isPrivate;
  final int maxMembers;
  final DateTime createdAt;

  Squad({
    required this.id,
    required this.name,
    this.logoUrl,
    required this.captainId,
    required this.isPrivate,
    required this.maxMembers,
    required this.createdAt,
  });

  /// Creates a Squad instance from a JSON map.
  factory Squad.fromJson(Map<String, dynamic> json) {
    return Squad(
      id: json['id'] as String,
      name: json['name'] as String,
      logoUrl: json['logo_url'] as String?,
      captainId: json['captain_id'] as String,
      isPrivate: json['is_private'] as bool? ?? true,
      maxMembers: json['max_members'] as int? ?? 10,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  /// Converts the Squad instance to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'logo_url': logoUrl,
      'captain_id': captainId,
      'is_private': isPrivate,
      'max_members': maxMembers,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
