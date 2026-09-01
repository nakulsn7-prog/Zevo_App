import 'package:auth/auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zevo_app/features/auth/bloc/auth_bloc.dart';
import 'package:zevo_app/features/auth/bloc/auth_event.dart';
import 'package:zevo_app/features/auth/bloc/auth_state.dart';

class MockAuthRepository implements AuthRepository {
  UserProfile? _current;
  bool _failSet = false;

  MockAuthRepository(UserProfile? current) : _current = current;

  set failSetJourneyChoice(bool value) => _failSet = value;

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
    if (_failSet) throw Exception('persist failed');
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

UserProfile _profile({String? journeyChoice}) => UserProfile(
      id: 'u1',
      fullName: 'Ada',
      journeyChoice: journeyChoice,
      createdAt: DateTime.utc(2026, 1, 1),
      updatedAt: DateTime.utc(2026, 1, 1),
    );

void main() {
  test('SetJourneyChoice emits Authenticated with the saved choice on success',
      () async {
    final repo = MockAuthRepository(_profile());
    final bloc = AuthBloc(repo);

    bloc.add(const SetJourneyChoice('solo'));

    await expectLater(
      bloc.stream,
      emitsInOrder([
        isA<Authenticated>()
            .having((s) => s.profile.journeyChoice, 'journeyChoice', 'solo'),
      ]),
    );

    expect(repo.currentUserProfile?.journeyChoice, 'solo');
    await bloc.close();
  });

  test('SetJourneyChoice with invalid value emits AuthError and does not persist',
      () async {
    final repo = MockAuthRepository(_profile());
    final bloc = AuthBloc(repo);

    bloc.add(const SetJourneyChoice('gaming'));

    await expectLater(
      bloc.stream,
      emits(isA<AuthError>()),
    );

    expect(repo.currentUserProfile?.journeyChoice, isNull);
    await bloc.close();
  });

  test('SetJourneyChoice when persistence fails emits AuthError', () async {
    final repo = MockAuthRepository(_profile())..failSetJourneyChoice = true;
    final bloc = AuthBloc(repo);

    bloc.add(const SetJourneyChoice('solo'));

    await expectLater(
      bloc.stream,
      emits(isA<AuthError>()),
    );

    expect(repo.currentUserProfile?.journeyChoice, isNull);
    await bloc.close();
  });
}
