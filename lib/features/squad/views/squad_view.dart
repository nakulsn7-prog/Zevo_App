import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zevo_app/core/theme/zevo_colors.dart';

/// Solo Squad Empty State screen.
///
/// Shown to users who are training solo and have not joined or created a squad.
/// Presents the "Your Squad" hero card with Join/Create Squad CTAs, plus
/// blurred, locked previews of squad-exclusive features.
class SquadView extends StatelessWidget {
  const SquadView({super.key});

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
                  _buildLockedFeatures(context),
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
          'Your Squad',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: ZevoColors.textPrimary,
            letterSpacing: -0.25,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Train together. Rise together.',
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
              _buildSoloBadge(),
              const SizedBox(height: 24),
              Text(
                'Training Solo',
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
                "You're currently training solo. Join or create a squad to compete in weekly divisions, stay accountable, and climb the leaderboard together.",
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

  Widget _buildSoloBadge() {
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
        Icons.group_outlined,
        size: 34,
        color: ZevoColors.accent.withValues(alpha: 0.5),
      ),
    );
  }

  Widget _buildPrimaryButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Join Squad flow coming soon'),
              duration: Duration(seconds: 2),
            ),
          );
        },
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
        child: const Text('JOIN SQUAD'),
      ),
    );
  }

  Widget _buildSecondaryButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Create Squad flow coming soon'),
              duration: Duration(seconds: 2),
            ),
          );
        },
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
        child: const Text('Create Squad'),
      ),
    );
  }

  Widget _buildLockedFeatures(BuildContext context) {
    const features = [
      (Icons.emoji_events_outlined, 'Weekly Squad MVP', 'Compete for the top spot each week'),
      (Icons.leaderboard_outlined, 'Division Leagues', 'Climb divisions with your squad'),
      (Icons.group_outlined, 'Squad Activity', 'See what your squad is up to'),
      (Icons.workspace_premium_outlined, 'Achievement Showcase', 'Display your squad\'s trophies'),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _SectionDivider(label: 'What you get with a Squad'),
        const SizedBox(height: 16),
        ...features.map((f) {
          final (icon, title, description) = f;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildLockedFeatureCard(icon, title, description),
          );
        }),
      ],
    );
  }

  Widget _buildLockedFeatureCard(IconData icon, String title, String description) {
    return Stack(
      children: [
        Opacity(
          opacity: 0.45,
          child: ImageFiltered(
            imageFilter: ui.ImageFilter.blur(sigmaX: 4, sigmaY: 4),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: ZevoColors.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFF1F1F1F), width: 1),
              ),
              padding: const EdgeInsets.all(18),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: ZevoColors.accent.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: ZevoColors.accent.withValues(alpha: 0.15),
                        width: 1,
                      ),
                    ),
                    child: Icon(
                      icon,
                      size: 20,
                      color: ZevoColors.accent,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: ZevoColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          description,
                          style: TextStyle(
                            fontSize: 11,
                            color: ZevoColors.textSecondary,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: Center(
            child: Container(
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
          ),
        ),
      ],
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
  final String label;
  const _SectionDivider({required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: Color(0xFF1F1F1F), height: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            label,
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
