import 'package:auth/auth.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('UserProfile journeyChoice', () {
    test('fromJson maps journey_choice column', () {
      final profile = UserProfile.fromJson({
        'id': 'u1',
        'full_name': 'Ada',
        'username': null,
        'avatar_url': null,
        'journey_choice': 'solo',
        'created_at': '2026-01-01T00:00:00.000',
        'updated_at': '2026-01-01T00:00:00.000',
      });

      expect(profile.journeyChoice, 'solo');
    });

    test('fromJson treats missing journey_choice as null', () {
      final profile = UserProfile.fromJson({
        'id': 'u1',
        'full_name': 'Ada',
        'created_at': '2026-01-01T00:00:00.000',
        'updated_at': '2026-01-01T00:00:00.000',
      });

      expect(profile.journeyChoice, isNull);
    });

    test('toJson serializes journey_choice', () {
      final profile = UserProfile(
        id: 'u1',
        fullName: 'Ada',
        journeyChoice: 'squad',
        createdAt: DateTime.utc(2026, 1, 1),
        updatedAt: DateTime.utc(2026, 1, 1),
      );

      expect(profile.toJson()['journey_choice'], 'squad');
    });

    test('round-trips via fromJson/toJson', () {
      const original = <String, dynamic>{
        'id': 'u1',
        'full_name': 'Ada',
        'journey_choice': 'solo',
        'created_at': '2026-01-01T00:00:00.000',
        'updated_at': '2026-01-01T00:00:00.000',
      };

      final fromJson = UserProfile.fromJson(original);
      final toJson = fromJson.toJson();

      expect(toJson['journey_choice'], 'solo');
      expect(toJson['id'], 'u1');
    });
  });
}
