/// Represents a workout record in Zevo.
class Workout {
  final String id;
  final String userId;
  final String workoutType; // e.g., Strength, Cardio, Running, etc.
  final int durationMinutes;
  final int pointsEarned;
  final DateTime completedAt;
  final DateTime createdAt;

  Workout({
    required this.id,
    required this.userId,
    required this.workoutType,
    required this.durationMinutes,
    required this.pointsEarned,
    required this.completedAt,
    required this.createdAt,
  });

  /// Creates a Workout instance from a JSON map.
  factory Workout.fromJson(Map<String, dynamic> json) {
    return Workout(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      workoutType: json['workout_type'] as String,
      durationMinutes: json['duration_minutes'] as int,
      pointsEarned: json['points_earned'] as int,
      completedAt: DateTime.parse(json['completed_at'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  /// Converts the Workout instance to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'workout_type': workoutType,
      'duration_minutes': durationMinutes,
      'points_earned': pointsEarned,
      'completed_at': completedAt.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
    };
  }
}
