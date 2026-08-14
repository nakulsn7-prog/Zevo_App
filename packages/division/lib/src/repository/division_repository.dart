import '../models/division.dart';
import '../models/weekly_member_score.dart';
import '../models/weekly_squad_score.dart';

/// Repository interface for division leaderboards, member rankings, and squad divisions.
abstract class DivisionRepository {
  /// Fetches the current division of a squad.
  Future<Division?> getCurrentDivision(String squadId);

  /// Fetches the division leaderboard for a specific division and week start date.
  Future<List<WeeklySquadScore>> getDivisionLeaderboard({
    required String divisionId,
    required DateTime weekStart,
  });

  /// Fetches member score contributions for a squad's finalized weekly score.
  Future<List<WeeklyMemberScore>> getWeeklyMemberScores(String weeklySquadScoreId);

  /// Fetches the Squad Champion's member score for a specific squad week (highest score).
  Future<WeeklyMemberScore?> getSquadChampion(String weeklySquadScoreId);
}
