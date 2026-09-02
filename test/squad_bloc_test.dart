import 'package:flutter_test/flutter_test.dart';
import 'package:squad/squad.dart';
import 'package:zevo_app/features/squad/bloc/squad_bloc.dart';
import 'package:zevo_app/features/squad/bloc/squad_event.dart';
import 'package:zevo_app/features/squad/bloc/squad_state.dart';

class MockSquadRepository implements SquadRepository {
  Squad? currentSquad;
  List<SquadMember> currentMembers = [];
  String? currentInvite;

  @override
  Future<Squad?> getMySquad() async => currentSquad;

  @override
  Future<List<SquadMember>> getMembers(String squadId) async => currentMembers;

  @override
  Future<String?> getActiveInviteCode(String squadId) async => currentInvite;

  @override
  Future<Squad> createSquad({required String name, String? logoUrl, required bool isPrivate}) async {
    currentSquad = Squad(
      id: 'squad1',
      name: name,
      captainId: 'user1',
      isPrivate: isPrivate,
      maxMembers: 10,
      createdAt: DateTime.now(),
    );
    currentMembers = [
      SquadMember(id: 'm1', squadId: 'squad1', userId: 'user1', role: 'captain', joinedAt: DateTime.now(), isActive: true)
    ];
    return currentSquad!;
  }

  @override
  Future<Squad> joinSquad(String inviteCode) async {
    if (inviteCode == 'INVALID') throw Exception('Invite code is invalid');
    if (inviteCode == 'FULL') throw Exception('This squad is full');
    
    currentSquad = Squad(
      id: 'squad2',
      name: 'Joined Squad',
      captainId: 'owner',
      isPrivate: true,
      maxMembers: 10,
      createdAt: DateTime.now(),
    );
    return currentSquad!;
  }

  @override
  Future<void> leaveSquad() async {
    currentSquad = null;
    currentMembers = [];
  }

  @override
  Future<void> transferOwnership(String newCaptainId) async {}

  @override
  Future<void> removeMember(String userId) async {}

  @override
  Future<void> deleteSquad() async {
    currentSquad = null;
    currentMembers = [];
  }

  @override
  Future<String> regenerateInviteCode() async => 'NEW-CODE';
}

void main() {
  group('SquadBloc', () {
    late MockSquadRepository squadRepository;
    late SquadBloc squadBloc;

    setUp(() {
      squadRepository = MockSquadRepository();
      squadBloc = SquadBloc(squadRepository: squadRepository);
    });

    tearDown(() {
      squadBloc.close();
    });

    test('initial state is SquadInitial', () {
      expect(squadBloc.state, isA<SquadInitial>());
    });

    test('emits SquadEmpty when no squad is found', () async {
      squadRepository.currentSquad = null;
      squadBloc.add(LoadSquad());
      
      await expectLater(
        squadBloc.stream,
        emitsInOrder([
          isA<SquadLoading>(),
          isA<SquadEmpty>(),
        ]),
      );
    });

    test('emits SquadLoaded when squad is found', () async {
      squadRepository.currentSquad = Squad(
        id: 'squad1',
        name: 'Test Squad',
        captainId: 'user1',
        isPrivate: true,
        maxMembers: 10,
        createdAt: DateTime.now(),
      );
      
      squadBloc.add(LoadSquad());
      
      await expectLater(
        squadBloc.stream,
        emitsInOrder([
          isA<SquadLoading>(),
          isA<SquadLoaded>(),
        ]),
      );
    });

    test('emits SquadOperationSuccess and then reloads when creating squad', () async {
      squadBloc.add(const CreateSquadRequested(name: 'New Squad', isPrivate: true));
      
      // Wait for states
      final states = await squadBloc.stream.take(4).toList();
      expect(states[0], isA<SquadLoading>());
      expect(states[1], isA<SquadOperationSuccess>());
      expect(states[2], isA<SquadLoading>()); // from LoadSquad
      expect(states[3], isA<SquadLoaded>()); // from LoadSquad
    });
    
    test('emits SquadError when joining full squad', () async {
      squadBloc.add(const JoinSquadRequested('FULL'));
      
      final states = await squadBloc.stream.take(3).toList();
      expect(states[0], isA<SquadLoading>());
      expect(states[1], isA<SquadError>());
      expect(states[2], isA<SquadEmpty>());
    });
  });
}
