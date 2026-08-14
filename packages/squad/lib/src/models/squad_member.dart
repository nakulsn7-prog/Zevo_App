/// Represents a membership record for a Squad.
class SquadMember {
  final String id;
  final String squadId;
  final String userId;
  final String role; // 'captain' or 'member'
  final DateTime joinedAt;
  final bool isActive;

  SquadMember({
    required this.id,
    required this.squadId,
    required this.userId,
    required this.role,
    required this.joinedAt,
    required this.isActive,
  });

  /// Creates a SquadMember instance from a JSON map.
  factory SquadMember.fromJson(Map<String, dynamic> json) {
    return SquadMember(
      id: json['id'] as String,
      squadId: json['squad_id'] as String,
      userId: json['user_id'] as String,
      role: json['role'] as String,
      joinedAt: DateTime.parse(json['joined_at'] as String),
      isActive: json['is_active'] as bool? ?? true,
    );
  }

  /// Converts the SquadMember instance to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'squad_id': squadId,
      'user_id': userId,
      'role': role,
      'joined_at': joinedAt.toIso8601String(),
      'is_active': isActive,
    };
  }
}
