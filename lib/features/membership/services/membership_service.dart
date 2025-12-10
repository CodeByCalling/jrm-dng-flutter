import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MembershipService {
  final FirebaseFirestore _firestore;

  MembershipService(this._firestore);

  Future<void> submitApplication(String uid, Map<String, dynamic> data) async {
    await _firestore.collection('users').doc(uid).set(
      {
        'membershipStatus': 'Pending',
        ...data,
      },
      SetOptions(merge: true),
    );
  }
}

final membershipServiceProvider = Provider<MembershipService>((ref) {
  return MembershipService(FirebaseFirestore.instance);
});
