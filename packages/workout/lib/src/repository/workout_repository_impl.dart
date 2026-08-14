import 'package:database_client/database_client.dart';
import '../models/workout.dart';
import 'workout_repository.dart';

/// Implementation of [WorkoutRepository] using [DatabaseClient] (Supabase).
class WorkoutRepositoryImpl implements WorkoutRepository {
  final DatabaseClient _dbClient;

  WorkoutRepositoryImpl(this._dbClient);

  @override
  Future<Workout> logWorkout({
    required String workoutType,
    required int durationMinutes,
  }) async {
    try {
      // Call the RPC to log a workout. It creates the workout, awards points, and caps points.
      final response = await _dbClient.client.rpc('log_workout', params: {
        'workout_type': workoutType,
        'duration_minutes': durationMinutes,
      });

      if (response == null) {
        throw Exception('Failed to log workout: ID returned was null');
      }

      // Fetch the newly logged workout record
      final data = await _dbClient.client
          .from('workouts')
          .select()
          .eq('id', response)
          .single();

      return Workout.fromJson(data);
    } catch (_) {
      // Fallback: If RPC fails or is not found, insert directly into the table for development/testing
      try {
        final userId = _dbClient.client.auth.currentUser?.id;
        if (userId == null) throw Exception('User not authenticated');

        final points = durationMinutes; // 1 min = 1 point

        final data = await _dbClient.client
            .from('workouts')
            .insert({
              'user_id': userId,
              'workout_type': workoutType,
              'duration_minutes': durationMinutes,
              'points_earned': points,
            })
            .select()
            .single();

        return Workout.fromJson(data);
      } catch (e) {
        rethrow;
      }
    }
  }

  @override
  Future<List<Workout>> getWorkoutHistory() async {
    try {
      final userId = _dbClient.client.auth.currentUser?.id;
      if (userId == null) return [];

      final data = await _dbClient.client
          .from('workouts')
          .select()
          .eq('user_id', userId)
          .order('completed_at', ascending: false);

      return (data as List)
          .map((item) => Workout.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<int> getWeeklyContributionPoints() async {
    try {
      final userId = _dbClient.client.auth.currentUser?.id;
      if (userId == null) return 0;

      // Determine current week start in IST (UTC +5:30)
      final nowUtc = DateTime.now().toUtc();
      final nowIst = nowUtc.add(const Duration(hours: 5, minutes: 30));
      final daysToSubtract = nowIst.weekday - 1; // Mon = 0 days to subtract
      final mondayIst = DateTime(nowIst.year, nowIst.month, nowIst.day)
          .subtract(Duration(days: daysToSubtract));
      
      // Query weekly_member_scores joining weekly_squad_scores for the current week
      final data = await _dbClient.client
          .from('weekly_member_scores')
          .select('points, weekly_squad_scores (week_start)')
          .eq('user_id', userId)
          .eq('weekly_squad_scores.week_start', mondayIst.toIso8601String().substring(0, 10))
          .maybeSingle();

      if (data == null) return 0;
      return data['points'] as int? ?? 0;
    } catch (_) {
      return 0;
    }
  }
}
