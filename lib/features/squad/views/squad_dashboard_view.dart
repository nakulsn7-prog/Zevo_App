import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zevo_app/core/theme/zevo_colors.dart';
import '../data/squad_dashboard_mock_data.dart';

/// Squad Dashboard screen.
///
/// Shown to users who have joined a squad. Presents the squad's weekly rank
/// and division score, a "complete workout" CTA, the current squad MVP,
/// today's progress stat cards and a recent squad activity feed.
///
/// The view is currently backed by [SquadDashboardPreview.sample] display
/// data; real squad / division / workout repository data will replace it once
/// the backend flows are wired.
class SquadDashboardView extends StatelessWidget {
  const SquadDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final preview = SquadDashboardPreview.sample;
    return Scaffold(
      backgroundColor: ZevoColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 52, 20, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTopBar(context),
              const SizedBox(height: 28),
              _buildHeroCard(context, preview),
              const SizedBox(height: 14),
              _buildSquadMvpSection(preview),
              const SizedBox(height: 28),
              _buildTodayProgress(preview),
              const SizedBox(height: 28),
              _buildSquadActivity(preview),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  // ── TOP BAR ──

  Widget _buildTopBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Good Evening,',
                style: TextStyle(
                  fontSize: 12,
                  color: ZevoColors.textSecondary,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.7,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Arshad',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.25,
                    ),
              ),
              const SizedBox(height: 3),
              const Text(
                'Welcome back to ZEVO.',
                style: TextStyle(
                  fontSize: 12,
                  color: ZevoColors.textSecondary,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
        Row(
          children: [
            _buildNotificationButton(),
            const SizedBox(width: 12),
            _buildAvatar(),
          ],
        ),
      ],
    );
  }

  Widget _buildNotificationButton() {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: ZevoColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ZevoColors.border, width: 1),
      ),
      child: const Icon(
        Icons.notifications_outlined,
        size: 17,
        color: ZevoColors.textSecondary,
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: ZevoColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ZevoColors.border, width: 1),
      ),
      child: const Center(
        child: Text(
          'A',
          style: TextStyle(
            color: ZevoColors.textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  // ── HERO CARD ──

  Widget _buildHeroCard(BuildContext context, SquadDashboardPreview preview) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: ZevoColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: ZevoColors.border, width: 1),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  preview.squadName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: ZevoColors.textPrimary,
                    letterSpacing: -0.16,
                  ),
                ),
              ),
              _buildDivisionChip(preview.divisionName),
            ],
          ),
          const SizedBox(height: 20),
          _buildRankAndScore(preview),
          const SizedBox(height: 18),
          _buildProgressToRankOne(preview),
          const SizedBox(height: 16),
          _buildMotivationCard(preview),
          const SizedBox(height: 20),
          _buildCompleteWorkoutButton(context),
        ],
      ),
    );
  }

  Widget _buildDivisionChip(String divisionName) {
    return Container(
      margin: const EdgeInsets.only(left: 12),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: ZevoColors.accent.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: ZevoColors.accent.withValues(alpha: 0.25),
          width: 1,
        ),
      ),
      child: Text(
        divisionName.toUpperCase(),
        style: const TextStyle(
          fontSize: 10,
          color: ZevoColors.accent,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.0,
        ),
      ),
    );
  }

  Widget _buildRankAndScore(SquadDashboardPreview preview) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCardLabel('Current Rank'),
              const SizedBox(height: 4),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: '#${preview.currentRank}',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: ZevoColors.textPrimary,
                      ),
                    ),
                    TextSpan(
                      text: ' of ${preview.totalSquads} Squads',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: ZevoColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _buildCardLabel('Division Score'),
            const SizedBox(height: 4),
            Text(
              '${preview.divisionScore}',
              style: const TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.w800,
                color: ZevoColors.textPrimary,
                height: 1,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCardLabel(String text) {
    return Text(
      text.toUpperCase(),
      style: const TextStyle(
        fontSize: 11,
        color: ZevoColors.textSecondary,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.9,
      ),
    );
  }

  Widget _buildProgressToRankOne(SquadDashboardPreview preview) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Expanded(
              child: Text(
                'Progress to Rank #1',
                style: TextStyle(
                  fontSize: 11,
                  color: ZevoColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '${preview.divisionScore} / ${preview.rankOneScore}',
              style: const TextStyle(
                fontSize: 11,
                color: ZevoColors.accent,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          height: 5,
          decoration: BoxDecoration(
            color: const Color(0xFF262626),
            borderRadius: BorderRadius.circular(99),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: preview.progressToRankOne.clamp(0.0, 1.0).toDouble(),
            child: Container(
              decoration: BoxDecoration(
                color: ZevoColors.accent,
                borderRadius: BorderRadius.circular(99),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMotivationCard(SquadDashboardPreview preview) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: ZevoColors.accent.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: ZevoColors.accent.withValues(alpha: 0.15),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            preview.motivationTitle,
            style: const TextStyle(
              fontSize: 13,
              color: ZevoColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            preview.motivationBody,
            style: const TextStyle(
              fontSize: 12,
              color: ZevoColors.textSecondary,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompleteWorkoutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: () => context.go('/log-workout'),
        style: FilledButton.styleFrom(
          backgroundColor: ZevoColors.accent,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 17),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8,
          ),
        ),
        child: const Text('COMPLETE WORKOUT'),
      ),
    );
  }

  // ── CURRENT SQUAD MVP ──

  Widget _buildSquadMvpSection(SquadDashboardPreview preview) {
    final mvp = preview.mvp;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionLabel('Current Squad MVP'),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: ZevoColors.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: ZevoColors.border, width: 1),
          ),
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  _buildAvatarTile(
                    initial: mvp.initial,
                    size: 56,
                    radius: 12,
                    tinted: true,
                  ),
                  Positioned(
                    bottom: -4,
                    right: -4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: ZevoColors.championGold,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'MVP',
                        style: TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF0D0D0D),
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      mvp.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: ZevoColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      mvp.subtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        color: ZevoColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(
                          Icons.bolt,
                          size: 13,
                          color: ZevoColors.accent,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '${mvp.points} pts',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: ZevoColors.accent,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                size: 16,
                color: ZevoColors.textSecondary.withValues(alpha: 0.4),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ── TODAY'S PROGRESS ──

  Widget _buildTodayProgress(SquadDashboardPreview preview) {
    final today = preview.today;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionLabel("Today's Progress"),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildProgressStat(
                icon: Icons.check_circle,
                iconColor: ZevoColors.success,
                value: today.workoutDone ? 'Done' : 'Pending',
                valueColor: ZevoColors.success,
                label: 'Workout',
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildProgressStat(
                icon: Icons.trending_up,
                iconColor: ZevoColors.accent,
                value: '${today.contributionPoints} pts',
                valueColor: ZevoColors.textPrimary,
                label: 'Contribution',
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildProgressStat(
                icon: Icons.local_fire_department_outlined,
                iconColor: ZevoColors.accent,
                value: '${today.streakDays} Days',
                valueColor: ZevoColors.textPrimary,
                label: 'Streak',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProgressStat({
    required IconData icon,
    required Color iconColor,
    required String value,
    required Color valueColor,
    required String label,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: ZevoColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: ZevoColors.border, width: 1),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: iconColor),
          const SizedBox(height: 10),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: valueColor,
                height: 1,
              ),
            ),
          ),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              label.toUpperCase(),
              style: const TextStyle(
                fontSize: 10,
                color: ZevoColors.textSecondary,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.6,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── RECENT SQUAD ACTIVITY ──

  Widget _buildSquadActivity(SquadDashboardPreview preview) {
    final activity = preview.activity;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionLabel('Recent Squad Activity'),
        const SizedBox(height: 12),
        for (var index = 0; index < activity.length; index++)
          Padding(
            padding: EdgeInsets.only(
              bottom: index < activity.length - 1 ? 10 : 0,
            ),
            child: _buildActivityRow(activity[index]),
          ),
      ],
    );
  }

  Widget _buildActivityRow(SquadActivityPreview item) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: ZevoColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: ZevoColors.border, width: 1),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          _buildAvatarTile(initial: item.initial, size: 36, radius: 8),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: item.name,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: ZevoColors.textPrimary,
                        ),
                      ),
                      TextSpan(
                        text: ' ${item.action}',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: ZevoColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  item.time,
                  style: TextStyle(
                    fontSize: 11,
                    color: ZevoColors.textSecondary.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: ZevoColors.accent.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: ZevoColors.accent.withValues(alpha: 0.15),
                width: 1,
              ),
            ),
            child: Icon(item.icon, size: 13, color: ZevoColors.accent),
          ),
        ],
      ),
    );
  }

  // ── SHARED HELPERS ──

  Widget _buildSectionLabel(String text) {
    return Text(
      text.toUpperCase(),
      style: const TextStyle(
        fontSize: 12,
        color: ZevoColors.textSecondary,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildAvatarTile({
    required String initial,
    required double size,
    required double radius,
    bool tinted = false,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: tinted
            ? ZevoColors.accent.withValues(alpha: 0.15)
            : ZevoColors.surface,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: ZevoColors.border, width: 1),
      ),
      child: Center(
        child: Text(
          initial,
          style: TextStyle(
            color: ZevoColors.textPrimary,
            fontSize: size * 0.42,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    final tabs = [
      {'icon': Icons.home_outlined, 'activeIcon': Icons.home, 'label': 'Home', 'route': '/dashboard', 'active': false},
      {'icon': Icons.emoji_events_outlined, 'activeIcon': Icons.emoji_events, 'label': 'Division', 'route': '/division', 'active': false},
      {'icon': Icons.add_circle_outline, 'activeIcon': Icons.add_circle, 'label': 'Workout', 'route': '/log-workout', 'active': false},
      {'icon': Icons.group_outlined, 'activeIcon': Icons.group, 'label': 'Squad', 'route': '/squad', 'active': true},
      {'icon': Icons.person_outline, 'activeIcon': Icons.person, 'label': 'Profile', 'route': '/profile', 'active': false},
    ];

    return Container(
      decoration: const BoxDecoration(
        color: ZevoColors.background,
        border: Border(
          top: BorderSide(color: Color(0xFF1A1A1A), width: 1),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(8, 12, 8, 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: tabs.map((tab) {
          final isActive = tab['active'] as bool;
          final color = isActive
              ? ZevoColors.accent
              : ZevoColors.textSecondary.withValues(alpha: 0.45);
          return InkWell(
            onTap: () => context.go(tab['route'] as String),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isActive
                        ? tab['activeIcon'] as IconData
                        : tab['icon'] as IconData,
                    size: 20,
                    color: color,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    tab['label'] as String,
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                      color: color,
                      letterSpacing: 0.05,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}