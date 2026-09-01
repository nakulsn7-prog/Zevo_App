/// Represents the user's application profile in Zevo.
class UserProfile {
  final String id;
  final String fullName;
  final String? username;
  final String? avatarUrl;
  final String? journeyChoice;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserProfile({
    required this.id,
    required this.fullName,
    this.username,
    this.avatarUrl,
    this.journeyChoice,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Creates a UserProfile instance from a JSON map.
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String,
      fullName: json['full_name'] as String? ?? 'ZEVO User',
      username: json['username'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      journeyChoice: json['journey_choice'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  /// Converts the UserProfile instance to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'username': username,
      'avatar_url': avatarUrl,
      'journey_choice': journeyChoice,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
