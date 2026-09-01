import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zevo_app/core/theme/zevo_colors.dart';

/// Division Empty State screen.
///
/// Shown to Solo users on the Division tab. Presents the "Compete With Your
/// Squad" hero card with Join/Create Squad CTAs, plus a blurred, locked
/// preview of the Silver Division leaderboard.
class DivisionView extends StatelessWidget {
  const DivisionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ZevoColors.background,
      body: Stack(
        children: [
          const _AmbientGlow(),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 52, 20, 110),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTopBar(context),
                  const SizedBox(height: 28),
                  _buildHeroCard(context),
                  const SizedBox(height: 20),
                  _buildLockedLeaderboard(context),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Division Leagues',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: ZevoColors.textPrimary,
            letterSpacing: -0.25,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Weekly squad competitions.',
          style: TextStyle(
            fontSize: 13,
            color: ZevoColors.textSecondary,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildHeroCard(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: ZevoColors.surface,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: ZevoColors.accent.withValues(alpha: 0.35),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 36),
      child: Stack(
        children: [
          // Inner glow
          Positioned(
            top: -20,
            left: 0,
            right: 0,
            child: IgnorePointer(
              child: Container(
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      ZevoColors.accent.withValues(alpha: 0.12),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),
          Column(
            children: [
              _buildTrophyBadge(),
              const SizedBox(height: 24),
              Text(
                'Compete With Your Squad',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: ZevoColors.textPrimary,
                  letterSpacing: -0.25,
                  height: 1.25,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Division Leagues unlock once you join or create a squad. Every workout earns points for your team. Climb divisions. Become champions.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: ZevoColors.textSecondary,
                  fontWeight: FontWeight.w400,
                  height: 1.7,
                ),
              ),
              const SizedBox(height: 28),
              _buildPrimaryButton(context),
              const SizedBox(height: 10),
              _buildSecondaryButton(context),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTrophyBadge() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: ZevoColors.accent.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: ZevoColors.accent.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Icon(
        Icons.emoji_events_outlined,
        size: 34,
        color: ZevoColors.accent.withValues(alpha: 0.5),
      ),
    );
  }

  Widget _buildPrimaryButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: () => context.push('/squad'),
        style: FilledButton.styleFrom(
          backgroundColor: ZevoColors.accent,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.05,
          ),
        ),
        child: const Text('JOIN A SQUAD'),
      ),
    );
  }

  Widget _buildSecondaryButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () => context.push('/squad'),
        style: OutlinedButton.styleFrom(
          foregroundColor: ZevoColors.accent,
          padding: const EdgeInsets.symmetric(vertical: 15),
          side: BorderSide(
            color: ZevoColors.accent.withValues(alpha: 0.3),
            width: 1,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.04,
          ),
        ),
        child: const Text('CREATE A SQUAD'),
      ),
    );
  }

  Widget _buildLockedLeaderboard(BuildContext context) {
    const previewSquads = [
      (1, 'Iron Wolves', 920, true),
      (2, 'Iron Titans', 900, false),
      (3, 'Alpha Force', 870, false),
      (4, 'Beast Mode', 850, false),
      (5, 'Phoenix Crew', 810, false),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _SectionDivider(),
        const SizedBox(height: 12),
          Stack(
          children: [
            Opacity(
              opacity: 0.45,
              child: ImageFiltered(
                imageFilter: ui.ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                child: Container(
                  decoration: BoxDecoration(
                    color: ZevoColors.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFF1F1F1F), width: 1),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    children: List.generate(previewSquads.length, (i) {
                      final (rank, name, score, isCrown) = previewSquads[i];
                      final isLast = i == previewSquads.length - 1;
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                        decoration: isLast
                            ? null
                            : const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(color: Color(0xFF1F1F1F), width: 1),
                                ),
                              ),
                        child: Row(
                          children: [
                            _buildRankBadge(rank, isCrown),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Text(
                                name,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: ZevoColors.textPrimary,
                                ),
                              ),
                            ),
                            Text(
                              '$score',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: ZevoColors.textPrimary.withValues(alpha: 0.7),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: ZevoColors.background.withValues(alpha: 0.85),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFF262626), width: 1),
                    ),
                    child: const Icon(
                      Icons.lock_outline,
                      size: 18,
                      color: ZevoColors.accent,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Join a squad to unlock',
                    style: TextStyle(
                      fontSize: 11,
                      color: ZevoColors.textSecondary.withValues(alpha: 0.6),
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.06,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRankBadge(int rank, bool isCrown) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: isCrown
            ? ZevoColors.championGold.withValues(alpha: 0.12)
            : ZevoColors.textSecondary.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(9),
        border: Border.all(
          color: isCrown
              ? ZevoColors.championGold.withValues(alpha: 0.3)
              : const Color(0xFF262626),
          width: 1,
        ),
      ),
      child: isCrown
          ? const Icon(
              Icons.workspace_premium,
              size: 13,
              color: ZevoColors.championGold,
            )
          : Center(
              child: Text(
                '$rank',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: ZevoColors.textSecondary,
                ),
              ),
            ),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    final tabs = [
      {'icon': Icons.home_outlined, 'activeIcon': Icons.home, 'label': 'Home', 'route': '/dashboard', 'active': false},
      {'icon': Icons.emoji_events_outlined, 'activeIcon': Icons.emoji_events, 'label': 'Division', 'route': '/division', 'active': true},
      {'icon': Icons.add_circle_outline, 'activeIcon': Icons.add_circle, 'label': 'Workout', 'route': '/log-workout', 'active': false},
      {'icon': Icons.group_outlined, 'activeIcon': Icons.group, 'label': 'Squad', 'route': '/squad', 'active': false},
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
          final color = isActive ? ZevoColors.accent : ZevoColors.textSecondary.withValues(alpha: 0.45);
          return InkWell(
            onTap: () => context.go(tab['route'] as String),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isActive ? tab['activeIcon'] as IconData : tab['icon'] as IconData,
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

class _AmbientGlow extends StatelessWidget {
  const _AmbientGlow();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 80,
      left: 0,
      right: 0,
      child: IgnorePointer(
        child: Center(
          child: Container(
            width: 340,
            height: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  ZevoColors.accent.withValues(alpha: 0.10),
                  ZevoColors.accent.withValues(alpha: 0.03),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.5, 0.72],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionDivider extends StatelessWidget {
  const _SectionDivider();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: Color(0xFF1F1F1F), height: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            'Silver Division Preview',
            style: TextStyle(
              fontSize: 10,
              color: ZevoColors.textSecondary.withValues(alpha: 0.3),
              fontWeight: FontWeight.w600,
              letterSpacing: 0.1,
            ),
          ),
        ),
        const Expanded(child: Divider(color: Color(0xFF1F1F1F), height: 1)),
      ],
    );
  }
}
