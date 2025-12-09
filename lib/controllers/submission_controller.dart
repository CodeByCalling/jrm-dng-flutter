import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:jrm_dng_flutter/models/membership_form_data.dart';
import 'package:jrm_dng_flutter/services/pdf_service.dart';

part 'submission_controller.g.dart';

@riverpod
class MembershipSubmissionController extends _$MembershipSubmissionController {
  @override
  FutureOr<void> build() {
    // Initial state is idle (void)
  }

  Future<void> submitApplication({
    required bool isDigital,
    MembershipFormData? formData,
    Uint8List? signatureBytes,
    Uint8List? fileBytes, // For manual upload
  }) async {
    state = const AsyncLoading();

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('User must be logged in to submit application.');
      }

      Uint8List? pdfBytes;

      if (isDigital) {
        if (formData == null || signatureBytes == null) {
           throw Exception('Missing form data or signature for digital submission.');
        }
        // Step 1: Generate PDF
        final pdfService = PdfService();
        pdfBytes = await pdfService.generateMembershipPdf(formData, signatureBytes);
      } else {
        if (fileBytes == null) {
          throw Exception('No file selected for upload.');
        }
        pdfBytes = fileBytes;
      }

      // Step 2: Upload to Firebase Storage
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('applications/${user.uid}/membership_submission.pdf');
      
      final uploadTask = storageRef.putData(
        pdfBytes,
        SettableMetadata(contentType: 'application/pdf'),
      );
      
      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();

      // Step 3: Trigger Email via Firestore 'mail' collection
      await FirebaseFirestore.instance.collection('mail').add({
        'to': user.email,
        'message': {
          'subject': 'JRM Membership Application Received',
          'html': 'Your membership application has been received/signed. Please see attached.',
           // The Trigger Email extension usually doesn't support direct attachments from URL easily in the 'mail' doc 
           // without specific config, but per instructions we pass attachmentUrl. 
           // We'll put it in top level or message data as instructed.
        },
        'attachmentUrl': downloadUrl, // Per instructions
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Step 4: Update User Profile Status
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'status': 'pending_approval',
        'hasSubmittedMembership': true,
        'membershipSubmissionDate': FieldValue.serverTimestamp(),
      });

      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
