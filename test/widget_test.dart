import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zevo_app/main.dart';
import 'package:auth/auth.dart';
import 'package:squad/squad.dart';
import 'package:workout/workout.dart';
import 'package:division/division.dart';

class MockAuthRepository implements AuthRepository {
  @override
  Stream<UserProfile?> get authStateChanges => const Stream.empty();
  @override
  UserProfile? get currentUserProfile => null;
  @override
  Future<UserProfile> signUp({required String email, required String password, required String fullName}) async {
    throw UnimplementedError();
  }
  @override
  Future<UserProfile> logIn({required String email, required String password}) async {
    throw UnimplementedError();
  }
  @override
  Future<void> logOut() async {}
  @override
  Future<UserProfile?> fetchUserProfile(String userId) async {
    return null;
  }
  @override
  Future<void> setJourneyChoice(String userId, String choice) async {}
}

class MockSquadRepository implements SquadRepository {
  @override
  Future<Squad?> getMySquad() async => null;
  @override
  Future<Squad> createSquad({required String name, required bool isPrivate}) async {
    throw UnimplementedError();
  }
  @override
  Future<Squad> joinSquad(String inviteCode) async {
    throw UnimplementedError();
  }
  @override
  Future<void> leaveSquad() async {}
  @override
  Future<List<SquadMember>> getMembers(String squadId) async => [];
  @override
  Future<String?> getActiveInviteCode(String squadId) async => null;
}

class MockWorkoutRepository implements WorkoutRepository {
  @override
  Future<Workout> logWorkout({required String workoutType, required int durationMinutes}) async {
    throw UnimplementedError();
  }
  @override
  Future<List<Workout>> getWorkoutHistory() async => [];
  @override
  Future<int> getWeeklyContributionPoints() async => 0;
}

class MockDivisionRepository implements DivisionRepository {
  @override
  Future<Division?> getCurrentDivision(String squadId) async => null;
  @override
  Future<List<WeeklySquadScore>> getDivisionLeaderboard({required String divisionId, required DateTime weekStart}) async => [];
  @override
  Future<List<WeeklyMemberScore>> getWeeklyMemberScores(String weeklySquadScoreId) async => [];
  @override
  Future<WeeklyMemberScore?> getSquadChampion(String weeklySquadScoreId) async => null;
}

void main() {
  testWidgets('App renders placeholder screens', (WidgetTester tester) async {
    await tester.pumpWidget(
      ZevoApp(
        authRepository: MockAuthRepository(),
        squadRepository: MockSquadRepository(),
        workoutRepository: MockWorkoutRepository(),
        divisionRepository: MockDivisionRepository(),
      ),
    );

    // Verify it renders the initial Splash screen branding
    expect(find.text('ZEVO'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
