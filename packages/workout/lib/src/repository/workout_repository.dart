import '../models/workout.dart';

/// Repository interface for logging workouts, viewing history, and tracking weekly points.
abstract class WorkoutRepository {
  /// Logs a manual workout.
  Future<Workout> logWorkout({
    required String workoutType,
    required int durationMinutes,
  });

  /// Fetches the user's complete workout history.
  Future<List<Workout>> getWorkoutHistory();

  /// Gets the current member's weekly points (competitive contribution score, up to 300).
  Future<int> getWeeklyContributionPoints();
}
