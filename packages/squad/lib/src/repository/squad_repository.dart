import '../models/squad.dart';
import '../models/squad_member.dart';

/// Repository interface for managing squads, memberships, and invites.
abstract class SquadRepository {
  /// Fetches the user's current active squad.
  Future<Squad?> getMySquad();

  /// Creates a new squad.
  Future<Squad> createSquad({
    required String name,
    String? logoUrl,
    required bool isPrivate,
  });

  /// Joins an existing squad via invite code.
  Future<Squad> joinSquad(String inviteCode);

  /// Leaves the current active squad.
  Future<void> leaveSquad();

  /// Fetches all active members in the current squad.
  Future<List<SquadMember>> getMembers(String squadId);

  /// Gets the current active invite code for the squad.
  Future<String?> getActiveInviteCode(String squadId);

  /// Transfers ownership to another member.
  Future<void> transferOwnership(String newCaptainId);

  /// Removes a member from the squad.
  Future<void> removeMember(String userId);

  /// Deletes the squad.
  Future<void> deleteSquad();

  /// Regenerates the squad invite code and returns the new code.
  Future<String> regenerateInviteCode();
}
