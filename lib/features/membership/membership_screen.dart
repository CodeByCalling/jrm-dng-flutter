import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:signature/signature.dart';
import 'package:jrm_dng_flutter/controllers/submission_controller.dart';
import 'package:jrm_dng_flutter/models/membership_form_data.dart';

class MembershipScreen extends ConsumerStatefulWidget {
  const MembershipScreen({super.key});

  @override
  ConsumerState<MembershipScreen> createState() => _MembershipScreenState();
}

class _MembershipScreenState extends ConsumerState<MembershipScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _formKey = GlobalKey<FormState>();

  // Form Controllers
  final _fullNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _contactInfoController = TextEditingController();
  final _spiritualHistoryController = TextEditingController();
  final _testimonyController = TextEditingController();

  // Dynamic Household List
  List<MembershipHouseholdMember> _householdMembers = [];

  // Signature
  final SignatureController _signatureController = SignatureController(
    penStrokeWidth: 3,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );

  // Upload
  PlatformFile? _selectedFile;
  Uint8List? _fileBytes;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _fullNameController.dispose();
    _addressController.dispose();
    _contactInfoController.dispose();
    _spiritualHistoryController.dispose();
    _testimonyController.dispose();
    _signatureController.dispose();
    super.dispose();
  }

  void _addHouseholdMember() {
    setState(() {
      if (_householdMembers.length < 10) {
        _householdMembers.add(MembershipHouseholdMember());
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Max 10 household members allowed.')),
        );
      }
    });
  }

  void _removeHouseholdMember(int index) {
    setState(() {
      _householdMembers.removeAt(index);
    });
  }

  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'png', 'jpeg'],
        withData: true, // We need bytes for web/firebase
      );

      if (result != null) {
        setState(() {
          _selectedFile = result.files.first;
          _fileBytes = result.files.first.bytes;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking file: $e')),
      );
    }
  }

  Future<void> _submit() async {
    final isDigital = _tabController.index == 0;
    MembershipFormData? formData;
    Uint8List? signatureBytes;

    if (isDigital) {
      if (!_formKey.currentState!.validate()) return;
      if (_signatureController.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please sign the application.')),
        );
        return;
      }
      
      signatureBytes = await _signatureController.toPngBytes();
      
      formData = MembershipFormData(
        fullName: _fullNameController.text,
        address: _addressController.text,
        contactInfo: _contactInfoController.text,
        spiritualHistory: _spiritualHistoryController.text,
        testimony: _testimonyController.text,
        householdMembers: _householdMembers,
      );
    } else {
      if (_fileBytes == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please upload a file.')),
        );
        return;
      }
    }

    // Call Controller
    await ref.read(membershipSubmissionControllerProvider.notifier).submitApplication(
      isDigital: isDigital,
      formData: formData,
      signatureBytes: signatureBytes,
      fileBytes: _fileBytes,
    );
    
    if (!mounted) return;

    // Check state for success/error (AsyncValue listener logic usually goes here or in build)
    // For simplicity, we can check the state after await if we don't use listen
    final state = ref.read(membershipSubmissionControllerProvider);
    if (state.hasError) {
       ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${state.error}')),
        );
    } else if (!state.isLoading) {
       ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Applications submitted successfully!')),
        );
        // Navigate away or lock screen?
    }
  }

  @override
  Widget build(BuildContext context) {
    final submissionState = ref.watch(membershipSubmissionControllerProvider);
    final isLoading = submissionState.isLoading;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Membership Application'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Digital Form'),
            Tab(text: 'Upload Signed Form'),
          ],
        ),
      ),
      body: isLoading 
        ? const Center(child: CircularProgressIndicator())
        : TabBarView(
          controller: _tabController,
          children: [
            _buildDigitalForm(),
            _buildUploadTab(),
          ],
        ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: isLoading ? null : _submit,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          child: Text(isLoading ? 'Submitting...' : 'Submit Application'),
        ),
      ),
    );
  }

  Widget _buildDigitalForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle('Personal Information'),
            TextFormField(
              controller: _fullNameController,
              decoration: const InputDecoration(labelText: 'Full Name'),
              validator: (v) => v?.isEmpty == true ? 'Required' : null,
            ),
            TextFormField(
              controller: _addressController,
              decoration: const InputDecoration(labelText: 'Address'),
              validator: (v) => v?.isEmpty == true ? 'Required' : null,
            ),
            TextFormField(
              controller: _contactInfoController,
              decoration: const InputDecoration(labelText: 'Contact Info (Phone/Email)'),
              validator: (v) => v?.isEmpty == true ? 'Required' : null,
            ),
            
            const SizedBox(height: 20),
            _sectionTitle('Spiritual History'),
            TextFormField(
              controller: _spiritualHistoryController,
              decoration: const InputDecoration(labelText: 'Spiritual History', alignLabelWithHint: true),
              maxLines: 3,
            ),

            const SizedBox(height: 20),
            _sectionTitle('Testimony'),
            TextFormField(
              controller: _testimonyController,
              decoration: const InputDecoration(labelText: 'Testimony', alignLabelWithHint: true),
              maxLines: 4,
              validator: (v) => v?.isEmpty == true ? 'Required' : null, // Assuming required
            ),

            const SizedBox(height: 20),
            Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: [
                 _sectionTitle('Household Members'),
                 IconButton(icon: const Icon(Icons.add_circle), onPressed: _addHouseholdMember, tooltip: 'Add Member'),
               ],
            ),
            if (_householdMembers.isEmpty)
              const Padding(padding: EdgeInsets.all(8), child: Text('No members added.'))
            else
              ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: _householdMembers.length,
                separatorBuilder: (c, i) => const Divider(),
                itemBuilder: (context, index) {
                  return _buildHouseholdRow(index);
                },
              ),

             const SizedBox(height: 30),
             _sectionTitle('Digital Signature'),
             Container(
               decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
               child: Signature(
                 controller: _signatureController,
                 height: 150,
                 backgroundColor: Colors.white,
               ),
             ),
             TextButton(
               onPressed: () => _signatureController.clear(),
               child: const Text('Clear Signature'),
             ),
             const SizedBox(height: 50), // Spacing for bottom button
          ],
        ),
      ),
    );
  }

  Widget _buildHouseholdRow(int index) {
    final member = _householdMembers[index];
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: TextFormField(
            initialValue: member.name,
            decoration: const InputDecoration(labelText: 'Name'),
            onChanged: (val) => member.name = val,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: TextFormField(
            initialValue: member.relationship,
            decoration: const InputDecoration(labelText: 'Rel.'),
            onChanged: (val) => member.relationship = val,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: TextFormField(
            initialValue: member.age,
            decoration: const InputDecoration(labelText: 'Age'),
             onChanged: (val) => member.age = val,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () => _removeHouseholdMember(index),
        ),
      ],
    );
  }

  Widget _buildUploadTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _sectionTitle('Upload Signed Form'),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: _pickFile,
            icon: const Icon(Icons.upload_file),
            label: const Text('Select PDF or Image'),
          ),
          const SizedBox(height: 20),
          if (_selectedFile != null)
             Text('Selected: ${_selectedFile!.name}', style: const TextStyle(fontWeight: FontWeight.bold))
          else
             const Text('No file selected'),
          const SizedBox(height: 10),
          const Text('Accepted formats: PDF, JPG, PNG', style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
  
  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(title, style: Theme.of(context).textTheme.titleLarge),
    );
  }
}
