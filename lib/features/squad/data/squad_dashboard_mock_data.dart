import 'package:flutter/material.dart';

/// Preview (mock) display data backing the Squad Dashboard UI.
///
/// These values mirror the Banani Squad Dashboard design and are
/// display-only. When squad / division / workout backend flows are wired,
/// this snapshot should be replaced by data from the squad, division and
/// workout repositories. No database or API calls live in widgets — this file
/// is the single, clearly-isolated source of the current preview content.
@immutable
class SquadDashboardPreview {
  const SquadDashboardPreview({
    required this.squadName,
    required this.divisionName,
    required this.currentRank,
    required this.totalSquads,
    required this.divisionScore,
    required this.rankOneScore,
    required this.progressToRankOne,
    required this.motivationTitle,
    required this.motivationBody,
    required this.mvp,
    required this.today,
    required this.activity,
  });

  final String squadName;
  final String divisionName;
  final int currentRank;
  final int totalSquads;
  final int divisionScore;
  final int rankOneScore;
  final double progressToRankOne;
  final String motivationTitle;
  final String motivationBody;
  final SquadMvpPreview mvp;
  final TodayProgressPreview today;
  final List<SquadActivityPreview> activity;

  static const SquadDashboardPreview sample = SquadDashboardPreview(
    squadName: 'Iron Titans',
    divisionName: 'Silver Division',
    currentRank: 2,
    totalSquads: 10,
    divisionScore: 860,
    rankOneScore: 900,
    progressToRankOne: 0.86,
    motivationTitle: 'Only 40 points behind Rank #1.',
    motivationBody: "Complete today's workout to help your squad take the lead.",
    mvp: SquadMvpPreview(
      initial: 'R',
      name: 'Rahul',
      subtitle: 'Leading this week',
      points: 260,
    ),
    today: TodayProgressPreview(
      workoutDone: true,
      contributionPoints: 40,
      streakDays: 6,
    ),
    activity: [
      SquadActivityPreview(
        initial: 'R',
        name: 'Rahul',
        action: 'completed Push Day',
        time: '2 min ago',
        icon: Icons.fitness_center,
      ),
      SquadActivityPreview(
        initial: 'A',
        name: 'Alex',
        action: 'earned 40 points',
        time: '18 min ago',
        icon: Icons.bolt,
      ),
      SquadActivityPreview(
        initial: 'J',
        name: 'John',
        action: 'joined Iron Titans',
        time: 'Yesterday',
        icon: Icons.person_add_outlined,
      ),
    ],
  );
}

/// Weekly squad MVP shown on the Squad Dashboard.
@immutable
class SquadMvpPreview {
  const SquadMvpPreview({
    required this.initial,
    required this.name,
    required this.subtitle,
    required this.points,
  });

  final String initial;
  final String name;
  final String subtitle;
  final int points;
}

/// "Today's Progress" stat cards on the Squad Dashboard.
@immutable
class TodayProgressPreview {
  const TodayProgressPreview({
    required this.workoutDone,
    required this.contributionPoints,
    required this.streakDays,
  });

  final bool workoutDone;
  final int contributionPoints;
  final int streakDays;
}

/// A single row in the "Recent Squad Activity" feed.
@immutable
class SquadActivityPreview {
  const SquadActivityPreview({
    required this.initial,
    required this.name,
    required this.action,
    required this.time,
    required this.icon,
  });

  final String initial;
  final String name;
  final String action;
  final String time;
  final IconData icon;
}