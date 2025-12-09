import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LeaderRequestScreen extends StatefulWidget {
  const LeaderRequestScreen({super.key});

  @override
  State<LeaderRequestScreen> createState() => _LeaderRequestScreenState();
}

class _LeaderRequestScreenState extends State<LeaderRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();
  String? _selectedGender;

  // Mock Data for Requests
  final List<Map<String, dynamic>> _pastRequests = [
    {
      "name": "Johanan Doe",
      "date": "2023-11-01",
      "status": "Rejected",
    },
    {
      "name": "Sarah Smith",
      "date": "2024-01-15",
      "status": "Pending",
    },
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  void _submitRequest() {
    if (_formKey.currentState!.validate()) {
      // Simulate submission
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Request for ${_nameController.text} submitted!'),
          backgroundColor: Colors.green,
        ),
      );
      
      // In a real app, this would add to the list and clear the form
      setState(() {
        _pastRequests.insert(0, {
          "name": _nameController.text,
          "date": DateTime.now().toString().split(' ')[0],
          "status": "Pending",
        });
        _nameController.clear();
        _reasonController.clear();
        _selectedGender = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Leader Requests", style: GoogleFonts.poppins()),
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildNewRequestForm(context),
            const SizedBox(height: 32),
            _buildRequestHistory(context),
          ],
        ),
      ),
    );
  }

  Widget _buildNewRequestForm(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "New Request",
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: "Prospective Disciple Name",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedGender,
                decoration: const InputDecoration(
                  labelText: "Gender",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.wc),
                ),
                items: const [
                  DropdownMenuItem(value: "Male", child: Text("Male")),
                  DropdownMenuItem(value: "Female", child: Text("Female")),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedGender = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select a gender';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _reasonController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: "Reason / Notes",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.note),
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitRequest,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text("Submit Request"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRequestHistory(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Request History",
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        if (_pastRequests.isEmpty)
          const Text("No requests found.")
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _pastRequests.length,
            itemBuilder: (context, index) {
              final request = _pastRequests[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.grey[200],
                    child: Text(request["name"][0]),
                  ),
                  title: Text(request["name"]),
                  subtitle: Text("Date: ${request["date"]}"),
                  trailing: _buildStatusBadge(request["status"]),
                ),
              );
            },
          ),
      ],
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    switch (status) {
      case "Approved":
        color = Colors.green;
        break;
      case "Rejected":
        color = Colors.red;
        break;
      default:
        color = Colors.orange;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}
