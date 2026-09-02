import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:squad/squad.dart';
import 'package:zevo_app/core/theme/zevo_colors.dart';
import 'package:zevo_app/features/squad/bloc/squad_bloc.dart';
import 'package:zevo_app/features/squad/bloc/squad_event.dart';
import 'package:zevo_app/features/auth/bloc/auth_bloc.dart';
import 'package:zevo_app/features/auth/bloc/auth_event.dart';

class SquadHomeView extends StatelessWidget {
  final Squad squad;
  final List<SquadMember> members;
  final String? inviteCode;
  final String currentUserId;

  const SquadHomeView({
    super.key,
    required this.squad,
    required this.members,
    this.inviteCode,
    required this.currentUserId,
  });

  bool get isOwner => squad.captainId == currentUserId;

  void _copyInviteCode(BuildContext context) {
    if (inviteCode != null) {
      Clipboard.setData(ClipboardData(text: inviteCode!));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invite code copied to clipboard!')),
      );
    }
  }

  void _showMembersSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: ZevoColors.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return BlocProvider.value(
          value: context.read<SquadBloc>(),
          child: _SquadMembersSheet(
            squad: squad,
            members: members,
            currentUserId: currentUserId,
            isOwner: isOwner,
          ),
        );
      },
    );
  }

  void _leaveSquad(BuildContext context) {
    if (isOwner) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('You must transfer ownership before leaving.'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: ZevoColors.surface,
        title: const Text('Leave Squad', style: TextStyle(color: ZevoColors.textPrimary)),
        content: const Text(
          'Are you sure you want to leave this squad?',
          style: TextStyle(color: ZevoColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: ZevoColors.textSecondary)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<SquadBloc>().add(LeaveSquadRequested());
            },
            child: Text('Leave', style: TextStyle(color: Theme.of(context).colorScheme.error)),
          ),
        ],
      ),
    );
  }

  void _deleteSquad(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: ZevoColors.surface,
        title: const Text('Delete Squad', style: TextStyle(color: ZevoColors.textPrimary)),
        content: const Text(
          'Are you sure you want to completely delete this squad? This action cannot be undone.',
          style: TextStyle(color: ZevoColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: ZevoColors.textSecondary)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<SquadBloc>().add(DeleteSquadRequested());
            },
            child: Text('Delete', style: TextStyle(color: Theme.of(context).colorScheme.error)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ZevoColors.background,
      appBar: AppBar(
        backgroundColor: ZevoColors.background,
        elevation: 0,
        title: Text(
          squad.name,
          style: const TextStyle(
            color: ZevoColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: ZevoColors.textPrimary),
            onPressed: () {
              context.read<AuthBloc>().add(LogoutRequested());
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Squad Stats Card
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: ZevoColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: ZevoColors.border),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.group, size: 48, color: ZevoColors.accent),
                    const SizedBox(height: 16),
                    Text(
                      '${members.length} / ${squad.maxMembers} Members',
                      style: const TextStyle(
                        color: ZevoColors.textPrimary,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isOwner ? 'You are the captain' : 'You are a member',
                      style: const TextStyle(
                        color: ZevoColors.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Invite Code Section (Only for owner, or visible to all depending on rules. Rules say "Owner can: View invite code, Share invite, Regenerate")
              if (isOwner && inviteCode != null) ...[
                const Text(
                  'INVITE CODE',
                  style: TextStyle(
                    color: ZevoColors.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: ZevoColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: ZevoColors.border),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          inviteCode!,
                          style: const TextStyle(
                            color: ZevoColors.accent,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 2.0,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.copy, color: ZevoColors.textSecondary),
                        onPressed: () => _copyInviteCode(context),
                      ),
                      IconButton(
                        icon: const Icon(Icons.refresh, color: ZevoColors.textSecondary),
                        onPressed: () {
                          context.read<SquadBloc>().add(RegenerateInviteCodeRequested());
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
              ],

              // Actions
              ElevatedButton.icon(
                icon: const Icon(Icons.people),
                label: const Text('View Members'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: ZevoColors.surface,
                  foregroundColor: ZevoColors.textPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: ZevoColors.border),
                  ),
                ),
                onPressed: () => _showMembersSheet(context),
              ),
              const SizedBox(height: 16),

              if (!isOwner)
                OutlinedButton.icon(
                  icon: const Icon(Icons.exit_to_app),
                  label: const Text('Leave Squad'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: BorderSide(color: Theme.of(context).colorScheme.error),
                    foregroundColor: Theme.of(context).colorScheme.error,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => _leaveSquad(context),
                ),

              if (isOwner)
                OutlinedButton.icon(
                  icon: const Icon(Icons.delete_forever),
                  label: const Text('Delete Squad'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: BorderSide(color: Theme.of(context).colorScheme.error),
                    foregroundColor: Theme.of(context).colorScheme.error,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => _deleteSquad(context),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SquadMembersSheet extends StatelessWidget {
  final Squad squad;
  final List<SquadMember> members;
  final String currentUserId;
  final bool isOwner;

  const _SquadMembersSheet({
    required this.squad,
    required this.members,
    required this.currentUserId,
    required this.isOwner,
  });

  void _transferOwnership(BuildContext context, SquadMember member) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: ZevoColors.surface,
        title: const Text('Transfer Ownership', style: TextStyle(color: ZevoColors.textPrimary)),
        content: Text(
          'Are you sure you want to make ${member.userId} the new captain? You will become a regular member.',
          style: const TextStyle(color: ZevoColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: ZevoColors.textSecondary)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<SquadBloc>().add(TransferOwnershipRequested(member.userId));
            },
            child: const Text('Transfer', style: TextStyle(color: ZevoColors.accent)),
          ),
        ],
      ),
    );
  }

  void _removeMember(BuildContext context, SquadMember member) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: ZevoColors.surface,
        title: const Text('Remove Member', style: TextStyle(color: ZevoColors.textPrimary)),
        content: Text(
          'Are you sure you want to remove ${member.userId} from the squad?',
          style: const TextStyle(color: ZevoColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: ZevoColors.textSecondary)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<SquadBloc>().add(RemoveMemberRequested(member.userId));
            },
            child: Text('Remove', style: TextStyle(color: Theme.of(context).colorScheme.error)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).padding.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Squad Members',
            style: TextStyle(
              color: ZevoColors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: members.length,
              separatorBuilder: (context, index) => const Divider(color: ZevoColors.border),
              itemBuilder: (context, index) {
                final member = members[index];
                final isMe = member.userId == currentUserId;
                final isMemberCaptain = member.role == 'captain';

                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    backgroundColor: ZevoColors.surface,
                    child: Icon(
                      isMemberCaptain ? Icons.star : Icons.person,
                      color: isMemberCaptain ? ZevoColors.championGold : ZevoColors.textSecondary,
                    ),
                  ),
                  title: Text(
                    isMe ? 'You' : member.userId.substring(0, 8), // Just showing start of UUID for now
                    style: const TextStyle(color: ZevoColors.textPrimary),
                  ),
                  subtitle: Text(
                    isMemberCaptain ? 'Captain' : 'Member',
                    style: TextStyle(
                      color: isMemberCaptain ? ZevoColors.championGold : ZevoColors.textSecondary,
                    ),
                  ),
                  trailing: (isOwner && !isMe)
                      ? PopupMenuButton<String>(
                          icon: const Icon(Icons.more_vert, color: ZevoColors.textSecondary),
                          color: ZevoColors.surface,
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 'transfer',
                              child: Text('Make Captain', style: TextStyle(color: ZevoColors.textPrimary)),
                            ),
                            PopupMenuItem(
                              value: 'remove',
                              child: Text('Remove', style: TextStyle(color: Theme.of(context).colorScheme.error)),
                            ),
                          ],
                          onSelected: (value) {
                            if (value == 'transfer') {
                              _transferOwnership(context, member);
                            } else if (value == 'remove') {
                              _removeMember(context, member);
                            }
                          },
                        )
                      : null,
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: ZevoColors.surface,
              foregroundColor: ZevoColors.textPrimary,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(color: ZevoColors.border),
              ),
            ),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
