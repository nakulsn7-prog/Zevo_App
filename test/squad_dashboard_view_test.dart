import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zevo_app/core/theme/zevo_theme.dart';
import 'package:zevo_app/features/squad/views/squad_dashboard_view.dart';

void main() {
  testWidgets('Squad dashboard renders key content', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(theme: ZevoTheme.darkTheme, home: const SquadDashboardView()),
    );

    expect(find.text('Iron Titans'), findsOneWidget);
    expect(find.text('SILVER DIVISION'), findsOneWidget);
    expect(find.text('860'), findsOneWidget);
    expect(find.text('COMPLETE WORKOUT'), findsOneWidget);
    expect(find.text('CURRENT SQUAD MVP'), findsOneWidget);
    expect(find.text('260 pts'), findsOneWidget);
    expect(find.text("TODAY'S PROGRESS"), findsOneWidget);
    await tester.ensureVisible(find.text('RECENT SQUAD ACTIVITY'));
    expect(find.text('RECENT SQUAD ACTIVITY'), findsOneWidget);
    expect(find.text('Rahul'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Squad dashboard renders sections on small screen',
      (tester) async {
    tester.view.physicalSize = const Size(400, 640);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(theme: ZevoTheme.darkTheme, home: const SquadDashboardView()),
    );

    expect(find.text('Iron Titans'), findsOneWidget);
    expect(find.text('COMPLETE WORKOUT'), findsOneWidget);

    await tester.ensureVisible(find.text('RECENT SQUAD ACTIVITY'));
    expect(find.text('RECENT SQUAD ACTIVITY'), findsOneWidget);
    expect(find.textContaining('joined Iron Titans'), findsOneWidget);
  });
}