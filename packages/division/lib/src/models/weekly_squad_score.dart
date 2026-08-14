/// Represents a squad's leaderboard score and ranking for a specific week.
class WeeklySquadScore {
  final String id;
  final String squadId;
  final String divisionId;
  final DateTime weekStart;
  final DateTime weekEnd;
  final int totalScore;
  final int? rank;
  final bool finalized;
  final DateTime createdAt;

  WeeklySquadScore({
    required this.id,
    required this.squadId,
    required this.divisionId,
    required this.weekStart,
    required this.weekEnd,
    required this.totalScore,
    this.rank,
    required this.finalized,
    required this.createdAt,
  });

  /// Creates a WeeklySquadScore instance from a JSON map.
  factory WeeklySquadScore.fromJson(Map<String, dynamic> json) {
    return WeeklySquadScore(
      id: json['id'] as String,
      squadId: json['squad_id'] as String,
      divisionId: json['division_id'] as String,
      weekStart: DateTime.parse(json['week_start'] as String),
      weekEnd: DateTime.parse(json['week_end'] as String),
      totalScore: json['total_score'] as int? ?? 0,
      rank: json['rank'] as int?,
      finalized: json['finalized'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  /// Converts the WeeklySquadScore instance to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'squad_id': squadId,
      'division_id': divisionId,
      'week_start': weekStart.toIso8601String().substring(0, 10),
      'week_end': weekEnd.toIso8601String().substring(0, 10),
      'total_score': totalScore,
      'rank': rank,
      'finalized': finalized,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
