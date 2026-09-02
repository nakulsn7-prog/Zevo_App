import 'package:equatable/equatable.dart';

abstract class SquadEvent extends Equatable {
  const SquadEvent();

  @override
  List<Object?> get props => [];
}

class LoadSquad extends SquadEvent {}

class CreateSquadRequested extends SquadEvent {
  final String name;
  final String? logoUrl;
  final bool isPrivate;

  const CreateSquadRequested({
    required this.name,
    this.logoUrl,
    required this.isPrivate,
  });

  @override
  List<Object?> get props => [name, logoUrl, isPrivate];
}

class JoinSquadRequested extends SquadEvent {
  final String inviteCode;

  const JoinSquadRequested(this.inviteCode);

  @override
  List<Object?> get props => [inviteCode];
}

class LeaveSquadRequested extends SquadEvent {}

class RemoveMemberRequested extends SquadEvent {
  final String userId;

  const RemoveMemberRequested(this.userId);

  @override
  List<Object?> get props => [userId];
}

class TransferOwnershipRequested extends SquadEvent {
  final String newCaptainId;

  const TransferOwnershipRequested(this.newCaptainId);

  @override
  List<Object?> get props => [newCaptainId];
}

class DeleteSquadRequested extends SquadEvent {}

class RegenerateInviteCodeRequested extends SquadEvent {}
