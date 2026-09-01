import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zevo_app/core/theme/zevo_colors.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ZevoColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 52, 20, 110),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTopBar(context),
              const SizedBox(height: 24),
              _buildSquadOnboardingCard(context),
              const SizedBox(height: 20),
              _buildTodaysWorkout(context),
              const SizedBox(height: 20),
              _buildStreakAndWeeklyProgress(),
              const SizedBox(height: 20),
              _buildRecentWorkouts(context),
              const SizedBox(height: 20),
              _buildQuickStats(context),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Good Evening,',
              style: TextStyle(
                fontSize: 12,
                color: ZevoColors.textSecondary,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'Arshad',
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
        Row(
          children: [
            _buildNotificationButton(),
            const SizedBox(width: 10),
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
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: ZevoColors.border, width: 1),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          const Icon(Icons.notifications_outlined, size: 17, color: ZevoColors.textSecondary),
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              width: 7,
              height: 7,
              decoration: BoxDecoration(
                color: ZevoColors.accent,
                shape: BoxShape.circle,
                border: Border.all(color: ZevoColors.background, width: 1.5),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: 36,
      height: 36,
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

  Widget _buildSquadOnboardingCard(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: ZevoColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: ZevoColors.accent.withValues(alpha: 0.4),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: ZevoColors.textSecondary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: ZevoColors.border, width: 1),
            ),
            child: Text(
              'SOLO MODE',
              style: TextStyle(
                fontSize: 9,
                color: ZevoColors.textSecondary,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.12,
              ),
            ),
          ),
          const SizedBox(height: 18),
          Text(
            'Train Better Together',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.5,
              height: 1.25,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "You're currently training solo. Join or create a squad to compete in weekly divisions, stay accountable, and climb the leaderboard together.",
            style: TextStyle(
              fontSize: 13,
              color: ZevoColors.textSecondary,
              fontWeight: FontWeight.w400,
              height: 1.65,
            ),
          ),
          const SizedBox(height: 24),
          Container(
            width: double.infinity,
            height: 80,
            decoration: BoxDecoration(
              color: ZevoColors.accent.withValues(alpha: 0.04),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: ZevoColors.accent.withValues(alpha: 0.2),
                width: 1,
                style: BorderStyle.solid,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.image_outlined, size: 14, color: ZevoColors.accent.withValues(alpha: 0.25)),
                const SizedBox(width: 8),
                Text(
                  'ILLUSTRATION PLACEHOLDER',
                  style: TextStyle(
                    fontSize: 9,
                    color: ZevoColors.accent.withValues(alpha: 0.25),
                    letterSpacing: 0.14,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () {},
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                textStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.04,
                ),
              ),
              child: const Text('JOIN A SQUAD'),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 13),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                textStyle: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              child: const Text('Continue Solo'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTodaysWorkout(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "TODAY'S WORKOUT",
          style: TextStyle(
            fontSize: 11,
            color: ZevoColors.textSecondary,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.1,
          ),
        ),
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
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: ZevoColors.accent.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: ZevoColors.accent.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                child: const Icon(Icons.fitness_center, size: 22, color: ZevoColors.accent),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Lower Body Power',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: ZevoColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text('45 min', style: TextStyle(fontSize: 12, color: ZevoColors.textSecondary)),
                        const SizedBox(width: 10),
                        Container(
                          width: 3,
                          height: 3,
                          decoration: const BoxDecoration(
                            color: ZevoColors.border,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text('6 exercises', style: TextStyle(fontSize: 12, color: ZevoColors.textSecondary)),
                      ],
                    ),
                  ],
                ),
              ),
              FilledButton(
                onPressed: () {},
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)),
                  textStyle: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.04,
                  ),
                ),
                child: const Text('START'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStreakAndWeeklyProgress() {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Container(
            decoration: BoxDecoration(
              color: ZevoColors.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: ZevoColors.border, width: 1),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.local_fire_department_outlined, size: 18, color: ZevoColors.accent),
                const SizedBox(height: 10),
                Text(
                  '6',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: ZevoColors.textPrimary,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 4),
                Text('Day Streak', style: TextStyle(fontSize: 11, color: ZevoColors.textSecondary, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: Container(
            decoration: BoxDecoration(
              color: ZevoColors.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: ZevoColors.border, width: 1),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'THIS WEEK',
                  style: TextStyle(
                    fontSize: 11,
                    color: ZevoColors.textSecondary,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.08,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: List.generate(7, (index) {
                    final days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
                    final done = [true, true, true, false, false, false, false];
                    return Expanded(
                      child: Column(
                        children: [
                          Container(
                            height: 28,
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            decoration: BoxDecoration(
                              color: done[index]
                                  ? ZevoColors.accent
                                  : ZevoColors.border.withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            days[index],
                            style: TextStyle(
                              fontSize: 9,
                              color: done[index] ? ZevoColors.accent : ZevoColors.textSecondary.withValues(alpha: 0.4),
                              fontWeight: done[index] ? FontWeight.w700 : FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 8),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '3 / 7',
                        style: TextStyle(fontSize: 11, color: ZevoColors.textPrimary, fontWeight: FontWeight.w700),
                      ),
                      TextSpan(
                        text: ' workouts done',
                        style: TextStyle(fontSize: 11, color: ZevoColors.textSecondary, fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRecentWorkouts(BuildContext context) {
    final workouts = [
      {'name': 'Upper Body Strength', 'duration': '42 min', 'pts': '+35', 'icon': Icons.fitness_center, 'when': 'Today'},
      {'name': 'HIIT Cardio Blast', 'duration': '28 min', 'pts': '+25', 'icon': Icons.bolt, 'when': 'Yesterday'},
      {'name': 'Core & Mobility', 'duration': '35 min', 'pts': '+20', 'icon': Icons.accessibility_new, 'when': 'Mon'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'RECENT WORKOUTS',
          style: TextStyle(
            fontSize: 11,
            color: ZevoColors.textSecondary,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.1,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: ZevoColors.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: ZevoColors.border, width: 1),
          ),
          child: Column(
            children: List.generate(workouts.length, (index) {
              final w = workouts[index];
              final isLast = index == workouts.length - 1;
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: isLast
                    ? null
                    : const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Color(0xFF1F1F1F), width: 1),
                        ),
                      ),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: ZevoColors.accent.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(11),
                        border: Border.all(
                          color: ZevoColors.accent.withValues(alpha: 0.15),
                          width: 1,
                        ),
                      ),
                      child: Icon(w['icon'] as IconData, size: 15, color: ZevoColors.accent),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            w['name'] as String,
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: ZevoColors.textPrimary),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${w['duration']} · ${w['when']}',
                            style: TextStyle(fontSize: 11, color: ZevoColors.textSecondary, fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      w['pts'] as String,
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: ZevoColors.success),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickStats(BuildContext context) {
    final stats = [
      {'label': 'Total Workouts', 'value': '124', 'icon': Icons.fitness_center},
      {'label': 'Total Points', 'value': '2,860', 'icon': Icons.bolt},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'QUICK STATS',
          style: TextStyle(
            fontSize: 11,
            color: ZevoColors.textSecondary,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.1,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: stats.map((s) {
            return Expanded(
              child: Container(
                margin: const EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                  color: ZevoColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: ZevoColors.border, width: 1),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(s['icon'] as IconData, size: 16, color: ZevoColors.accent),
                    const SizedBox(height: 10),
                    Text(
                      s['value'] as String,
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: ZevoColors.textPrimary,
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      s['label'] as String,
                      style: TextStyle(fontSize: 11, color: ZevoColors.textSecondary, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    final tabs = [
      {'icon': Icons.home_outlined, 'activeIcon': Icons.home, 'label': 'Home', 'route': '/dashboard', 'active': true},
      {'icon': Icons.emoji_events_outlined, 'activeIcon': Icons.emoji_events, 'label': 'Division', 'route': '/division', 'active': false},
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
