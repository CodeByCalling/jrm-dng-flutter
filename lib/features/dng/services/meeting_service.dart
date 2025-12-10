import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/meeting_model.dart';

class MeetingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> logMeeting(MeetingModel meeting) async {
    try {
      await _firestore.collection('dng_meetings').add(meeting.toMap());
    } catch (e) {
      throw Exception('Failed to log meeting: $e');
    }
  }
}
