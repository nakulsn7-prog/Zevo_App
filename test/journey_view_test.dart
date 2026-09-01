import 'package:auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:zevo_app/core/theme/zevo_theme.dart';
import 'package:zevo_app/features/auth/bloc/auth_bloc.dart';
import 'package:zevo_app/features/journey/views/journey_view.dart';

class MockAuthRepository implements AuthRepository {
  final List<String> savedChoices = [];
  UserProfile? _current;
  bool _fail = false;

  MockAuthRepository(UserProfile? current) : _current = current;

  set failSetJourneyChoice(bool value) => _fail = value;

  @override
  Stream<UserProfile?> get authStateChanges => const Stream.empty();

  @override
  UserProfile? get currentUserProfile => _current;

  @override
  Future<UserProfile> signUp({
    required String email,
    required String password,
    required String fullName,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<UserProfile> logIn({
    required String email,
    required String password,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<void> logOut() async {}

  @override
  Future<UserProfile?> fetchUserProfile(String userId) async => _current;

  @override
  Future<void> setJourneyChoice(String userId, String choice) async {
    if (_fail) throw Exception('persist failed');
    savedChoices.add(choice);
    final current = _current;
    if (current != null) {
      _current = UserProfile(
        id: current.id,
        fullName: current.fullName,
        username: current.username,
        avatarUrl: current.avatarUrl,
        journeyChoice: choice,
        createdAt: current.createdAt,
        updatedAt: current.updatedAt,
      );
    }
  }
}

UserProfile _profile() => UserProfile(
      id: 'u1',
      fullName: 'Ada',
      createdAt: DateTime.utc(2026, 1, 1),
      updatedAt: DateTime.utc(2026, 1, 1),
    );

class _Placeholder extends StatelessWidget {
  final String title;
  const _Placeholder(this.title);

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text(title)));
  }
}

Widget buildApp(MockAuthRepository repo) {
  final router = GoRouter(
    initialLocation: '/journey',
    routes: [
      GoRoute(
        path: '/journey',
        builder: (context, state) => const JourneyView(),
      ),
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => const _Placeholder('Dashboard Screen'),
      ),
      GoRoute(
        path: '/squad',
        builder: (context, state) => const _Placeholder('Squad Screen'),
      ),
    ],
  );

  return BlocProvider(
    create: (_) => AuthBloc(repo),
    child: MaterialApp.router(
      theme: ZevoTheme.darkTheme,
      routerConfig: router,
    ),
  );
}

void main() {
  testWidgets('Journey screen displays heading and option content',
      (WidgetTester tester) async {
    final repo = MockAuthRepository(_profile());
    await tester.pumpWidget(buildApp(repo));
    await tester.pumpAndSettle();

    expect(find.textContaining('How are you starting'), findsOneWidget);
    expect(find.text("I'm Starting Alone"), findsOneWidget);
    expect(find.text("I'm Joining Friends"), findsOneWidget);
    expect(find.text('Continue Solo'), findsOneWidget);
    expect(find.text('Join / Create Squad'), findsOneWidget);
  });

  testWidgets('Journey screen renders without overflow', (tester) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final repo = MockAuthRepository(_profile());
    await tester.pumpWidget(buildApp(repo));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text("I'm Starting Alone"), findsOneWidget);
    expect(find.text("I'm Joining Friends"), findsOneWidget);
  });

  testWidgets('Continue Solo persists then navigates to /dashboard',
      (tester) async {
    final repo = MockAuthRepository(_profile());
    await tester.pumpWidget(buildApp(repo));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Continue Solo'));
    await tester.pumpAndSettle();

    expect(repo.savedChoices, ['solo']);
    expect(find.text('Dashboard Screen'), findsOneWidget);
  });

  testWidgets('Join / Create Squad persists then navigates to /dashboard',
      (tester) async {
    final repo = MockAuthRepository(_profile());
    await tester.pumpWidget(buildApp(repo));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Join / Create Squad'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Join / Create Squad'));
    await tester.pumpAndSettle();

    expect(repo.savedChoices, ['squad']);
    expect(find.text('Dashboard Screen'), findsOneWidget);
  });

  testWidgets('Failed persistence stays on Journey and shows error',
      (tester) async {
    final repo = MockAuthRepository(_profile())..failSetJourneyChoice = true;
    await tester.pumpWidget(buildApp(repo));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Continue Solo'));
    await tester.pumpAndSettle();

    expect(find.text("I'm Starting Alone"), findsOneWidget);
    expect(find.text('Could not save your journey choice. Please try again.'),
        findsOneWidget);
  });
}