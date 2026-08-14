/// Represents a member's points contribution and ranking within their squad for a week.
class WeeklyMemberScore {
  final String id;
  final String weeklySquadScoreId;
  final String userId;
  final int points;
  final int? rank;
  final DateTime createdAt;

  WeeklyMemberScore({
    required this.id,
    required this.weeklySquadScoreId,
    required this.userId,
    required this.points,
    this.rank,
    required this.createdAt,
  });

  /// Creates a WeeklyMemberScore instance from a JSON map.
  factory WeeklyMemberScore.fromJson(Map<String, dynamic> json) {
    return WeeklyMemberScore(
      id: json['id'] as String,
      weeklySquadScoreId: json['weekly_squad_score_id'] as String,
      userId: json['user_id'] as String,
      points: json['points'] as int? ?? 0,
      rank: json['rank'] as int?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  /// Converts the WeeklyMemberScore instance to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'weekly_squad_score_id': weeklySquadScoreId,
      'user_id': userId,
      'points': points,
      'rank': rank,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
