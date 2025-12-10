import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jrm_dng_flutter/features/auth/auth_provider.dart';

// --- Tree Model ---

class TreeModel {
  final String id;
  final String name;
  final String? email;
  final String? profileImage;
  final String? leaderId;
  final List<String> discipleIds;
  final List<TreeModel> children;

  const TreeModel({
    required this.id,
    required this.name,
    this.email,
    this.profileImage,
    this.leaderId,
    this.discipleIds = const [],
    this.children = const [],
  });

  factory TreeModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return TreeModel(
      id: doc.id,
      name: data['fullName'] as String? ?? 'Unknown Member',
      email: data['email'] as String?,
      profileImage: data['profileImage'] as String?,
      leaderId: data['leaderId'] as String?,
      discipleIds: List<String>.from(data['discipleIds'] ?? []),
      // children are not in firestore doc directly
    );
  }

  TreeModel copyWith({
    String? id,
    String? name,
    String? email,
    String? profileImage,
    String? leaderId,
    List<String>? discipleIds,
    List<TreeModel>? children,
  }) {
    return TreeModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      profileImage: profileImage ?? this.profileImage,
      leaderId: leaderId ?? this.leaderId,
      discipleIds: discipleIds ?? this.discipleIds,
      children: children ?? this.children,
    );
  }
}

// --- Tree Service ---

class TreeService {
  final FirebaseFirestore _firestore;

  TreeService(this._firestore);

  /// Fetches the user's downline hierarchy.
  /// 
  /// LOGIC: This uses a recursive-ready structure but currently implements
  /// a 1-level deep fetch (User + Generation 1 Disciples) as requested.
  /// 
  /// Steps:
  /// 1. Fetch the document for [leaderId].
  /// 2. Query 'users' collection where 'leaderId' == [leaderId] to get direct disciples.
  /// 3. Return the loaded TreeModel.
  Future<TreeModel?> fetchDownline(String leaderId) async {
    try {
      // 1. Fetch Root (The Leader)
      final rootDoc = await _firestore.collection('users').doc(leaderId).get();
      if (!rootDoc.exists) return null;

      final rootNode = TreeModel.fromFirestore(rootDoc);

      // 2. Fetch Generation 1 (Direct Disciples)
      final gen1Snapshot = await _firestore
          .collection('users')
          .where('leaderId', isEqualTo: leaderId)
          .get();

      final List<TreeModel> children = gen1Snapshot.docs
          .map((doc) => TreeModel.fromFirestore(doc))
          .toList();

      // 3. Assemble and return
      return rootNode.copyWith(children: children);
    } catch (e) {
      // Ensure we don't crash the UI, but rethrow or let the provider handle loading/error states.
      // For now logging and returning null is safe, but we'll rethrow for Provider to catch.
      print('TreeService Error: $e');
      rethrow;
    }
  }
}

final treeServiceProvider = Provider<TreeService>((ref) {
  return TreeService(FirebaseFirestore.instance);
});

// --- DNG Tree Provider ---

/// Provider that watches the tree service and exposes the tree data to the UI.
/// It automatically fetches the tree for the CURRENT authenticated user.
final dngTreeProvider = FutureProvider.autoDispose<TreeModel?>((ref) async {
  final authState = ref.watch(authProvider);
  final user = authState.user;

  if (user == null) {
    return null;
  }

  final service = ref.watch(treeServiceProvider);
  return service.fetchDownline(user.uid);
});

// If we need to fetch for ARBITRARY users, we can use a family:
final dngTreeFamilyProvider = FutureProvider.family.autoDispose<TreeModel?, String>((ref, leaderId) async {
  final service = ref.watch(treeServiceProvider);
  return service.fetchDownline(leaderId);
});
