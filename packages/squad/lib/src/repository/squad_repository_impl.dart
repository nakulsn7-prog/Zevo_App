import 'package:database_client/database_client.dart';
import '../models/squad.dart';
import '../models/squad_member.dart';
import 'squad_repository.dart';

/// Implementation of [SquadRepository] using [DatabaseClient] (Supabase).
class SquadRepositoryImpl implements SquadRepository {
  final DatabaseClient _dbClient;

  SquadRepositoryImpl(this._dbClient);

  @override
  Future<Squad?> getMySquad() async {
    try {
      // Call the RPC helper to fetch the active squad details
      final response = await _dbClient.client.rpc('get_my_squad');
      
      if (response == null) return null;
      
      if (response is List && response.isNotEmpty) {
        return Squad.fromJson(response.first as Map<String, dynamic>);
      } else if (response is List && response.isEmpty) {
        return null;
      } else if (response is Map) {
        return Squad.fromJson(response as Map<String, dynamic>);
      }
      
      return null;
    } catch (_) {
      // If RPC is missing or fails, fallback to direct query via active member table
      try {
        final userId = _dbClient.client.auth.currentUser?.id;
        if (userId == null) return null;

        final memberData = await _dbClient.client
            .from('squad_members')
            .select('squad_id, squads (*)')
            .eq('user_id', userId)
            .eq('is_active', true)
            .maybeSingle();

        if (memberData == null || memberData['squads'] == null) {
          return null;
        }

        return Squad.fromJson(memberData['squads'] as Map<String, dynamic>);
      } catch (_) {
        return null;
      }
    }
  }

  @override
  Future<Squad> createSquad({
    required String name,
    String? logoUrl,
    required bool isPrivate,
  }) async {
    try {
      final squadId = await _dbClient.client.rpc('create_squad', params: {
        'p_name': name,
        'p_logo_url': logoUrl,
        'p_is_private': isPrivate,
      });

      if (squadId == null) {
        throw Exception('Failed to create squad: ID returned was null');
      }

      // Fetch newly created squad details using the RPC
      final squad = await getMySquad();
      if (squad == null) {
        throw Exception('Squad was created but could not be retrieved.');
      }
      return squad;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Squad> joinSquad(String inviteCode) async {
    try {
      final squadId = await _dbClient.client.rpc('join_squad', params: {
        'p_invite_code': inviteCode,
      });

      if (squadId == null) {
        throw Exception('Failed to join squad: ID returned was null');
      }

      // Fetch squad details using the RPC
      final squad = await getMySquad();
      if (squad == null) {
        throw Exception('Joined squad but could not retrieve it.');
      }
      return squad;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> leaveSquad() async {
    try {
      await _dbClient.client.rpc('leave_squad');
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<SquadMember>> getMembers(String squadId) async {
    try {
      final data = await _dbClient.client
          .from('squad_members')
          .select()
          .eq('squad_id', squadId)
          .eq('is_active', true);

      return (data as List)
          .map((item) => SquadMember.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String?> getActiveInviteCode(String squadId) async {
    try {
      final data = await _dbClient.client
          .from('invites')
          .select('invite_code')
          .eq('squad_id', squadId)
          .eq('is_active', true)
          .maybeSingle();

      if (data == null) return null;
      return data['invite_code'] as String?;
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> transferOwnership(String newCaptainId) async {
    try {
      await _dbClient.client.rpc('transfer_squad_ownership', params: {
        'p_new_captain_id': newCaptainId,
      });
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> removeMember(String userId) async {
    try {
      await _dbClient.client.rpc('remove_squad_member', params: {
        'p_user_id': userId,
      });
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteSquad() async {
    try {
      await _dbClient.client.rpc('delete_squad');
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> regenerateInviteCode() async {
    try {
      final newCode = await _dbClient.client.rpc('regenerate_squad_invite');
      if (newCode == null) throw Exception('Failed to regenerate invite code');
      return newCode as String;
    } catch (e) {
      rethrow;
    }
  }
}
