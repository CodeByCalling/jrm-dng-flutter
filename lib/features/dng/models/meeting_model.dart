import 'package:cloud_firestore/cloud_firestore.dart';

class MeetingModel {
  final DateTime date;
  final String topic;
  final List<String> attendeeIds;
  final String notes;
  final String leaderId;

  MeetingModel({
    required this.date,
    required this.topic,
    required this.attendeeIds,
    required this.notes,
    required this.leaderId,
  });

  Map<String, dynamic> toMap() {
    return {
      'date': Timestamp.fromDate(date),
      'topic': topic,
      'attendeeIds': attendeeIds,
      'notes': notes,
      'leaderId': leaderId,
    };
  }

  factory MeetingModel.fromMap(Map<String, dynamic> map) {
    return MeetingModel(
      date: (map['date'] as Timestamp).toDate(),
      topic: map['topic'] ?? '',
      attendeeIds: List<String>.from(map['attendeeIds'] ?? []),
      notes: map['notes'] ?? '',
      leaderId: map['leaderId'] ?? '',
    );
  }
}
