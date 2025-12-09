import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:jrm_dng_flutter/models/membership_form_data.dart';

class PdfService {
  Future<Uint8List> generateMembershipPdf(
    MembershipFormData data,
    Uint8List? signatureBytes,
  ) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return [
            _buildHeader(),
            pw.SizedBox(height: 20),
            _buildSectionTitle('Personal Information'),
            _buildInfoRow('Full Name', data.fullName),
            _buildInfoRow('Address', data.address),
            _buildInfoRow('Contact Info', data.contactInfo),
            pw.SizedBox(height: 10),
            _buildSectionTitle('Spiritual History'),
            pw.Text(data.spiritualHistory),
            pw.SizedBox(height: 10),
            _buildSectionTitle('Testimony'),
            pw.Text(data.testimony),
            pw.SizedBox(height: 20),
            _buildSectionTitle('Household Members'),
            _buildHouseholdTable(data.householdMembers),
            pw.SizedBox(height: 30),
            if (signatureBytes != null) _buildSignatureSection(signatureBytes),
          ];
        },
      ),
    );

    return pdf.save();
  }

  pw.Widget _buildHeader() {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: [
        pw.Text('JRM Membership Application',
            style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
        pw.Text('rev.Nov2025', style: const pw.TextStyle(fontSize: 10)),
        pw.Divider(),
      ],
    );
  }

  pw.Widget _buildSectionTitle(String title) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 8),
      child: pw.Text(
        title,
        style: pw.TextStyle(
          fontSize: 16,
          fontWeight: pw.FontWeight.bold,
          decoration: pw.TextDecoration.underline,
        ),
      ),
    );
  }

  pw.Widget _buildInfoRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 4),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.SizedBox(
            width: 100,
            child: pw.Text('$label:',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          ),
          pw.Expanded(child: pw.Text(value)),
        ],
      ),
    );
  }

  pw.Widget _buildHouseholdTable(List<MembershipHouseholdMember> members) {
    if (members.isEmpty) {
      return pw.Text('No other household members listed.');
    }

    return pw.Table.fromTextArray(
      headerDecoration: pw.BoxDecoration(color: PdfColors.grey300),
      headerHeight: 25,
      cellHeight: 30,
      cellAlignments: {
        0: pw.Alignment.centerLeft,
        1: pw.Alignment.centerLeft,
        2: pw.Alignment.center,
      },
      headers: ['Name', 'Relationship', 'Age'],
      data: members
          .map((m) => [m.name, m.relationship, m.age])
          .toList(),
    );
  }

  pw.Widget _buildSignatureSection(Uint8List signatureBytes) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text('Signature:',
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(height: 5),
        pw.Container(
          height: 80,
          width: 200,
          decoration: pw.BoxDecoration(border: pw.Border.all()),
          child: pw.Center(
            child: pw.Image(pw.MemoryImage(signatureBytes)),
          ),
        ),
        pw.SizedBox(height: 5),
        pw.Text('Signed Electronically on ${DateTime.now().toIso8601String().split('T').first}', style: const pw.TextStyle(fontSize: 10)),
      ],
    );
  }
}
