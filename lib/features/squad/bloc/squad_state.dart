import 'package:equatable/equatable.dart';
import 'package:squad/squad.dart';

abstract class SquadState extends Equatable {
  const SquadState();

  @override
  List<Object?> get props => [];
}

class SquadInitial extends SquadState {}

class SquadLoading extends SquadState {}

class SquadEmpty extends SquadState {}

class SquadLoaded extends SquadState {
  final Squad squad;
  final List<SquadMember> members;
  final String? inviteCode;

  const SquadLoaded({
    required this.squad,
    required this.members,
    this.inviteCode,
  });

  @override
  List<Object?> get props => [squad, members, inviteCode];

  SquadLoaded copyWith({
    Squad? squad,
    List<SquadMember>? members,
    String? inviteCode,
  }) {
    return SquadLoaded(
      squad: squad ?? this.squad,
      members: members ?? this.members,
      inviteCode: inviteCode ?? this.inviteCode,
    );
  }
}

class SquadOperationSuccess extends SquadState {
  final String message;

  const SquadOperationSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class SquadError extends SquadState {
  final String message;

  const SquadError(this.message);

  @override
  List<Object?> get props => [message];
}
