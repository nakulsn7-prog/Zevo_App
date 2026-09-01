import 'package:flutter_test/flutter_test.dart';
import 'package:zevo_app/core/router/app_router.dart';

void main() {
  group('resolveJourneyRoute', () {
    test('null journeyChoice routes to /journey', () {
      expect(resolveJourneyRoute(null), AppRoutes.journey);
    });

    test('solo routes to /dashboard', () {
      expect(resolveJourneyRoute('solo'), AppRoutes.dashboard);
    });

    test('squad routes to /dashboard', () {
      expect(resolveJourneyRoute('squad'), AppRoutes.dashboard);
    });

    test('unexpected value routes to /journey', () {
      expect(resolveJourneyRoute('gaming'), AppRoutes.journey);
    });

    test('empty string routes to /journey', () {
      expect(resolveJourneyRoute(''), AppRoutes.journey);
    });
  });
}
