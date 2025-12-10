import 'package:cloud_firestore/cloud_firestore.dart';

class SeederService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> seedGen3Hierarchy() async {
    // 1. Create Root User
    final rootRef = _firestore.collection('users').doc();
    final rootId = rootRef.id;

    await rootRef.set({
      'uid': rootId,
      'fullName': 'Root Leader',
      'email': 'root.leader@jrm.test',
      'role': 'pastor',
      'membershipStatus': 'Official',
      'leaderId': null, // Root has no leader
      'discipleIds': [], // Will be updated
      'generationLevel': 0,
      'createdAt': FieldValue.serverTimestamp(),
    });

    List<String> gen1Ids = [];

    // 2. Loop Gen 1 (6 disciples)
    for (int i = 1; i <= 6; i++) {
      final gen1Ref = _firestore.collection('users').doc();
      final gen1Id = gen1Ref.id;
      gen1Ids.add(gen1Id);

      await gen1Ref.set({
        'uid': gen1Id,
        'fullName': 'Disciple 1-$i',
        'email': 'gen1.$i@jrm.test',
        'role': 'member',
        'membershipStatus': 'Official',
        'leaderId': rootId,
        'discipleIds': [], // Will be updated
        'generationLevel': 1,
        'createdAt': FieldValue.serverTimestamp(),
      });

      List<String> gen2Ids = [];

      // 3. Loop Gen 2 (6 disciples per Gen 1)
      for (int j = 1; j <= 6; j++) {
        final gen2Ref = _firestore.collection('users').doc();
        final gen2Id = gen2Ref.id;
        gen2Ids.add(gen2Id);

        await gen2Ref.set({
          'uid': gen2Id,
          'fullName': 'Disciple 2-$i-$j',
          'email': 'gen2.$i.$j@jrm.test',
          'role': 'member',
          'membershipStatus': 'Official',
          'leaderId': gen1Id,
          'discipleIds': [], // Will be updated
          'generationLevel': 2,
          'createdAt': FieldValue.serverTimestamp(),
        });

        List<String> gen3Ids = [];

        // 4. Loop Gen 3 (6 disciples per Gen 2)
        for (int k = 1; k <= 6; k++) {
          final gen3Ref = _firestore.collection('users').doc();
          final gen3Id = gen3Ref.id;
          gen3Ids.add(gen3Id);

          await gen3Ref.set({
            'uid': gen3Id,
            'fullName': 'Disciple 3-$i-$j-$k',
            'email': 'gen3.$i.$j.$k@jrm.test',
            'role': 'member',
            'membershipStatus': 'Official',
            'leaderId': gen2Id,
            'discipleIds': [], // No children for Gen 3
            'generationLevel': 3,
            'createdAt': FieldValue.serverTimestamp(),
          });
        }

        // Update Gen 2's discipleIds with Gen 3
        await gen2Ref.update({'discipleIds': gen3Ids});
      }

      // Update Gen 1's discipleIds with Gen 2
      await gen1Ref.update({'discipleIds': gen2Ids});
    }

    // Update Root's discipleIds with Gen 1
    await rootRef.update({'discipleIds': gen1Ids});

    // print('Seeding Complete: Generated 3-deep hierarchy.');
  }
}
