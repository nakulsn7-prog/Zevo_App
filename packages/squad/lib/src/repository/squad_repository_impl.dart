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
      } catch (e) {
        return null;
      }
    }
  }

  @override
  Future<Squad> createSquad({
    required String name,
    required bool isPrivate,
  }) async {
    try {
      final squadId = await _dbClient.client.rpc('create_squad', params: {
        'squad_name': name,
        'is_private': isPrivate,
      });

      if (squadId == null) {
        throw Exception('Failed to create squad: ID returned was null');
      }

      // Fetch newly created squad details
      final squadData = await _dbClient.client
          .from('squads')
          .select()
          .eq('id', squadId)
          .single();

      return Squad.fromJson(squadData);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Squad> joinSquad(String inviteCode) async {
    try {
      final squadId = await _dbClient.client.rpc('join_squad', params: {
        'invite_code': inviteCode,
      });

      if (squadId == null) {
        throw Exception('Failed to join squad: ID returned was null');
      }

      // Fetch squad details
      final squadData = await _dbClient.client
          .from('squads')
          .select()
          .eq('id', squadId)
          .single();

      return Squad.fromJson(squadData);
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
}
