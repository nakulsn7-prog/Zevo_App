import 'package:database_client/database_client.dart';
import '../models/division.dart';
import '../models/weekly_member_score.dart';
import '../models/weekly_squad_score.dart';
import 'division_repository.dart';

/// Implementation of [DivisionRepository] using [DatabaseClient] (Supabase).
class DivisionRepositoryImpl implements DivisionRepository {
  final DatabaseClient _dbClient;

  DivisionRepositoryImpl(this._dbClient);

  @override
  Future<Division?> getCurrentDivision(String squadId) async {
    try {
      final data = await _dbClient.client
          .from('squad_divisions')
          .select('division_id, divisions (*)')
          .eq('squad_id', squadId)
          .maybeSingle();

      if (data == null || data['divisions'] == null) {
        return null;
      }

      return Division.fromJson(data['divisions'] as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<WeeklySquadScore>> getDivisionLeaderboard({
    required String divisionId,
    required DateTime weekStart,
  }) async {
    try {
      final weekStartStr = weekStart.toIso8601String().substring(0, 10);
      
      final data = await _dbClient.client
          .from('weekly_squad_scores')
          .select()
          .eq('division_id', divisionId)
          .eq('week_start', weekStartStr)
          .order('total_score', ascending: false);

      return (data as List)
          .map((item) => WeeklySquadScore.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<WeeklyMemberScore>> getWeeklyMemberScores(String weeklySquadScoreId) async {
    try {
      final data = await _dbClient.client
          .from('weekly_member_scores')
          .select()
          .eq('weekly_squad_score_id', weeklySquadScoreId)
          .order('points', ascending: false);

      return (data as List)
          .map((item) => WeeklyMemberScore.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<WeeklyMemberScore?> getSquadChampion(String weeklySquadScoreId) async {
    try {
      final data = await _dbClient.client
          .from('weekly_member_scores')
          .select()
          .eq('weekly_squad_score_id', weeklySquadScoreId)
          .order('points', ascending: false)
          .limit(1)
          .maybeSingle();

      if (data == null) return null;
      return WeeklyMemberScore.fromJson(data);
    } catch (_) {
      return null;
    }
  }
}
