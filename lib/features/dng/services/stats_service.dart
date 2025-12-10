import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/auth_provider.dart';

class DashboardStats {
  final int discipleCount;
  final int meetingCount;

  const DashboardStats({
    required this.discipleCount,
    required this.meetingCount,
  });
}

class StatsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<int> getDiscipleCount(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (!doc.exists) return 0;
      
      final data = doc.data();
      if (data == null || !data.containsKey('discipleIds')) return 0;
      
      final discipleIds = data['discipleIds'];
      if (discipleIds is List) {
        return discipleIds.length;
      }
      return 0;
    } catch (e) {
      // Fail silently or log? Returning 0 is safe for UI.
      return 0;
    }
  }

  Future<int> getMeetingCount(String uid) async {
    try {
      final now = DateTime.now();
      final startOfMonth = DateTime(now.year, now.month, 1);
      final nextMonthStart = DateTime(now.year, now.month + 1, 1);

      // Query: dngMeetings where leaderId == uid AND created this month
      // Assuming 'createdAt' field for creation time. 
      // If 'date' is preferred for meeting date, we might use that. 
      // But 'created this month' usually refers to creation timestamp.
      // However, for stats, usually we want to know meetings HELD this month.
      // I'll stick to 'createdAt' as a safe default for "created".
      // Note: This requires a composite index on leaderId and createdAt.
      final querySnapshot = await _firestore
          .collection('dngMeetings')
          .where('leaderId', isEqualTo: uid)
          .where('createdAt', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfMonth))
          .where('createdAt', isLessThan: Timestamp.fromDate(nextMonthStart))
          .get();

      return querySnapshot.docs.length;
    } catch (e) {
      return 0;
    }
  }
}

final statsServiceProvider = Provider<StatsService>((ref) {
  return StatsService();
});

final dashboardStatsProvider = FutureProvider<DashboardStats>((ref) async {
  final authState = ref.watch(authProvider);
  final user = authState.user;

  if (user == null) {
    return const DashboardStats(discipleCount: 0, meetingCount: 0);
  }

  final service = ref.read(statsServiceProvider);
  
  // Fetch in parallel
  final results = await Future.wait([
    service.getDiscipleCount(user.uid),
    service.getMeetingCount(user.uid),
  ]);

  return DashboardStats(
    discipleCount: results[0],
    meetingCount: results[1],
  );
});
