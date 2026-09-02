import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squad/squad.dart';
import 'squad_event.dart';
import 'squad_state.dart';

class SquadBloc extends Bloc<SquadEvent, SquadState> {
  final SquadRepository _squadRepository;

  SquadBloc({required SquadRepository squadRepository})
      : _squadRepository = squadRepository,
        super(SquadInitial()) {
    on<LoadSquad>(_onLoadSquad);
    on<CreateSquadRequested>(_onCreateSquadRequested);
    on<JoinSquadRequested>(_onJoinSquadRequested);
    on<LeaveSquadRequested>(_onLeaveSquadRequested);
    on<RemoveMemberRequested>(_onRemoveMemberRequested);
    on<TransferOwnershipRequested>(_onTransferOwnershipRequested);
    on<DeleteSquadRequested>(_onDeleteSquadRequested);
    on<RegenerateInviteCodeRequested>(_onRegenerateInviteCodeRequested);
  }

  Future<void> _onLoadSquad(LoadSquad event, Emitter<SquadState> emit) async {
    emit(SquadLoading());
    try {
      final squad = await _squadRepository.getMySquad();
      if (squad == null) {
        emit(SquadEmpty());
        return;
      }

      final members = await _squadRepository.getMembers(squad.id);
      String? inviteCode;
      
      // Only the captain should be able to see the active invite code
      // We'll fetch it and let the UI decide based on current user id
      inviteCode = await _squadRepository.getActiveInviteCode(squad.id);

      emit(SquadLoaded(
        squad: squad,
        members: members,
        inviteCode: inviteCode,
      ));
    } catch (e) {
      emit(SquadError(e.toString()));
      emit(SquadEmpty());
    }
  }

  Future<void> _onCreateSquadRequested(
    CreateSquadRequested event,
    Emitter<SquadState> emit,
  ) async {
    if (state is SquadLoading) return;
    
    // Validate
    if (event.name.trim().isEmpty) {
      emit(const SquadError('Squad name is required.'));
      return;
    }

    final currentState = state;
    emit(SquadLoading());
    try {
      await _squadRepository.createSquad(
        name: event.name.trim(),
        logoUrl: event.logoUrl,
        isPrivate: event.isPrivate,
      );
      emit(const SquadOperationSuccess('Squad created successfully!'));
      add(LoadSquad());
    } catch (e) {
      emit(SquadError(_formatError(e)));
      if (currentState is SquadLoaded || currentState is SquadEmpty) {
        emit(currentState);
      } else {
        emit(SquadEmpty());
      }
    }
  }

  Future<void> _onJoinSquadRequested(
    JoinSquadRequested event,
    Emitter<SquadState> emit,
  ) async {
    if (state is SquadLoading) return;
    
    if (event.inviteCode.trim().isEmpty) {
      emit(const SquadError('Invite code is invalid.'));
      return;
    }

    final currentState = state;
    emit(SquadLoading());
    try {
      await _squadRepository.joinSquad(event.inviteCode.trim());
      emit(const SquadOperationSuccess('Joined squad successfully!'));
      add(LoadSquad());
    } catch (e) {
      emit(SquadError(_formatError(e)));
      if (currentState is SquadLoaded || currentState is SquadEmpty) {
        emit(currentState);
      } else {
        emit(SquadEmpty());
      }
    }
  }

  Future<void> _onLeaveSquadRequested(
    LeaveSquadRequested event,
    Emitter<SquadState> emit,
  ) async {
    if (state is SquadLoading) return;
    final currentState = state;
    emit(SquadLoading());
    try {
      await _squadRepository.leaveSquad();
      emit(const SquadOperationSuccess('You have left the squad.'));
      emit(SquadEmpty());
    } catch (e) {
      emit(SquadError(_formatError(e)));
      if (currentState is SquadLoaded) {
        emit(currentState);
      }
    }
  }

  Future<void> _onRemoveMemberRequested(
    RemoveMemberRequested event,
    Emitter<SquadState> emit,
  ) async {
    if (state is SquadLoading) return;
    final currentState = state;
    if (currentState is! SquadLoaded) return;

    emit(SquadLoading());
    try {
      await _squadRepository.removeMember(event.userId);
      emit(const SquadOperationSuccess('Member removed.'));
      add(LoadSquad());
    } catch (e) {
      emit(SquadError(_formatError(e)));
      emit(currentState);
    }
  }

  Future<void> _onTransferOwnershipRequested(
    TransferOwnershipRequested event,
    Emitter<SquadState> emit,
  ) async {
    if (state is SquadLoading) return;
    final currentState = state;
    if (currentState is! SquadLoaded) return;

    emit(SquadLoading());
    try {
      await _squadRepository.transferOwnership(event.newCaptainId);
      emit(const SquadOperationSuccess('Ownership transferred.'));
      add(LoadSquad());
    } catch (e) {
      emit(SquadError(_formatError(e)));
      emit(currentState);
    }
  }

  Future<void> _onDeleteSquadRequested(
    DeleteSquadRequested event,
    Emitter<SquadState> emit,
  ) async {
    if (state is SquadLoading) return;
    final currentState = state;
    emit(SquadLoading());
    try {
      await _squadRepository.deleteSquad();
      emit(const SquadOperationSuccess('Squad deleted.'));
      emit(SquadEmpty());
    } catch (e) {
      emit(SquadError(_formatError(e)));
      if (currentState is SquadLoaded) {
        emit(currentState);
      }
    }
  }

  Future<void> _onRegenerateInviteCodeRequested(
    RegenerateInviteCodeRequested event,
    Emitter<SquadState> emit,
  ) async {
    if (state is SquadLoading) return;
    final currentState = state;
    if (currentState is! SquadLoaded) return;

    emit(SquadLoading());
    try {
      final newCode = await _squadRepository.regenerateInviteCode();
      emit(const SquadOperationSuccess('Invite code regenerated.'));
      emit(currentState.copyWith(inviteCode: newCode));
    } catch (e) {
      emit(SquadError(_formatError(e)));
      emit(currentState);
    }
  }

  String _formatError(dynamic error) {
    final msg = error.toString().toLowerCase();
    if (msg.contains('full')) {
      return 'This squad is full.';
    } else if (msg.contains('already in a squad') || msg.contains('duplicate')) {
      return 'You are already in a squad.';
    } else if (msg.contains('invalid') || msg.contains('not found')) {
      return 'Invite code is invalid.';
    } else if (msg.contains('permission') || msg.contains('authorized')) {
      return "You don't have permission to do that.";
    } else if (msg.contains('transfer ownership')) {
      return 'You must transfer ownership before leaving.';
    }
    return 'Something went wrong. Please try again.';
  }
}
