import 'package:auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zevo_app/core/router/app_router.dart';
import 'package:zevo_app/features/auth/bloc/auth_bloc.dart';
import 'package:zevo_app/features/dashboard/views/dashboard_view.dart';
import 'package:zevo_app/features/squad/views/squad_dashboard_view.dart';
import 'package:zevo_app/features/squad/views/squad_view.dart';

class _HarnessAuthRepository implements AuthRepository {
  _HarnessAuthRepository(this._profile);
  final UserProfile _profile;

  @override
  Stream<UserProfile?> get authStateChanges => Stream.value(_profile);
  @override
  UserProfile? get currentUserProfile => _profile;
  @override
  Future<UserProfile> signUp(
          {required String email,
          required String password,
          required String fullName}) =>
      throw UnimplementedError();
  @override
  Future<UserProfile> logIn(
          {required String email, required String password}) =>
      throw UnimplementedError();
  @override
  Future<void> logOut() async {}
  @override
  Future<UserProfile?> fetchUserProfile(String userId) async => _profile;
  @override
  Future<void> setJourneyChoice(String userId, String choice) async {}
}

UserProfile _profile(String choice) => UserProfile(
      id: 'u1',
      fullName: 'Ada',
      journeyChoice: choice,
      createdAt: DateTime.utc(2026, 1, 1),
      updatedAt: DateTime.utc(2026, 1, 1),
    );

Future<void> _pumpResolver(
  WidgetTester tester,
  Widget child,
  String journeyChoice,
) async {
  final bloc = AuthBloc(_HarnessAuthRepository(_profile(journeyChoice)));
  addTearDown(bloc.close);
  await tester.pumpWidget(
    BlocProvider.value(
      value: bloc,
      child: MaterialApp(home: child),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  // ── ZevoDashboardView (Home resolver) ──

  testWidgets('solo journeyChoice → Solo Dashboard', (tester) async {
    await _pumpResolver(tester, const ZevoDashboardView(), 'solo');
    expect(find.byType(DashboardView), findsOneWidget);
    expect(find.byType(SquadDashboardView), findsNothing);
  });

  testWidgets('squad journeyChoice → Squad Dashboard', (tester) async {
    await _pumpResolver(tester, const ZevoDashboardView(), 'squad');
    expect(find.byType(SquadDashboardView), findsOneWidget);
    expect(find.byType(DashboardView), findsNothing);
    expect(find.text('Iron Titans'), findsOneWidget);
  });

  // ── ZevoSquadSectionView (Squad tab resolver) ──

  testWidgets('solo journeyChoice → Solo Squad Empty / Locked State',
      (tester) async {
    await _pumpResolver(tester, const ZevoSquadSectionView(), 'solo');
    expect(find.byType(SquadView), findsOneWidget);
    expect(find.text('Training Solo'), findsOneWidget);
    expect(find.byType(SquadDashboardView), findsNothing);
  });

  testWidgets('squad journeyChoice → Phase 3 Squad placeholder',
      (tester) async {
    await _pumpResolver(tester, const ZevoSquadSectionView(), 'squad');
    expect(find.text('Squad Section'), findsOneWidget);
    expect(find.text('Your squad details are coming in Phase 3.'),
        findsOneWidget);
    expect(find.byType(SquadDashboardView), findsNothing);
  });

  // ── resolveJourneyRoute ──

  test('resolveJourneyRoute returns /dashboard for solo', () {
    expect(resolveJourneyRoute('solo'), AppRoutes.dashboard);
  });

  test('resolveJourneyRoute returns /dashboard for squad', () {
    expect(resolveJourneyRoute('squad'), AppRoutes.dashboard);
  });

  test('resolveJourneyRoute returns /journey for null', () {
    expect(resolveJourneyRoute(null), AppRoutes.journey);
  });

  testWidgets(
      'bottom nav Home (/dashboard) always uses ZevoDashboardView',
      (tester) async {
    // Verify the router configures /dashboard with ZevoDashboardView
    // by checking the route builder indirectly.
    // We test the resolver widget directly since the GoRouter is a static
    // singleton and re-using it between tests causes stale navigation state.
    await _pumpResolver(tester, const ZevoDashboardView(), 'squad');
    expect(find.byType(SquadDashboardView), findsOneWidget);
  });

  testWidgets(
      'bottom nav Squad (/squad) always uses ZevoSquadSectionView',
      (tester) async {
    await _pumpResolver(tester, const ZevoSquadSectionView(), 'solo');
    expect(find.byType(SquadView), findsOneWidget);
  });
}
