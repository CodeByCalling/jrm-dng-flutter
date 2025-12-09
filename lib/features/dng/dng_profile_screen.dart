import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class DngProfileScreen extends ConsumerWidget {
  const DngProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Mock Data for UI State
    final user = _MockUser(
      name: "Serge",
      avatarUrl: "https://i.pravatar.cc/150?u=serge",
      dngLeaderName: null, // Set to "John Doe" to test assigned state
      progress: {
        "New Believers": StepStatus.completed,
        "Class 101": StepStatus.completed,
        "Class 201": StepStatus.inProgress,
        "Class 301": StepStatus.locked,
        "Class 401": StepStatus.locked,
      },
    );

    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("My DNG Profile", style: GoogleFonts.poppins()),
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildHeader(context, user),
            const SizedBox(height: 32),
            _buildDngStatusCard(context, user),
            const SizedBox(height: 32),
            _buildProgressTracker(context, user.progress),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, _MockUser user) {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage: NetworkImage(user.avatarUrl),
          backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
        ),
        const SizedBox(height: 16),
        Text(
          user.name,
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildDngStatusCard(BuildContext context, _MockUser user) {
    final bool hasLeader = user.dngLeaderName != null;
    final bool canRequest = user.progress["Class 101"] == StepStatus.completed;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Discipleship Network Group",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            if (hasLeader)
              Column(
                children: [
                  const Icon(Icons.people, size: 48, color: Colors.green),
                  const SizedBox(height: 8),
                  Text(
                    "My Leader: ${user.dngLeaderName}",
                    style: GoogleFonts.poppins(fontSize: 16),
                  ),
                ],
              )
            else
              Column(
                children: [
                  const Text(
                    "You are not yet in a DNG.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: canRequest
                        ? () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Request sent!")),
                            );
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      foregroundColor: Colors.black,
                    ),
                    child: const Text("Request to Join DNG"),
                  ),
                  if (!canRequest)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        "Must complete Class 101 first",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.red[300],
                        ),
                      ),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressTracker(
      BuildContext context, Map<String, StepStatus> progress) {
    final steps = progress.keys.toList();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "My Growth Track",
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: steps.length,
          itemBuilder: (context, index) {
            final stepName = steps[index];
            final status = progress[stepName]!;
            final isLast = index == steps.length - 1;

            return IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      _buildStepIcon(context, status),
                      if (!isLast)
                        Expanded(
                          child: Container(
                            width: 2,
                            color: Colors.grey[300],
                            margin: const EdgeInsets.symmetric(vertical: 4),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            stepName,
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: status == StepStatus.locked
                                  ? Colors.grey
                                  : Colors.black,
                            ),
                          ),
                          Text(
                            _getStatusDescription(status),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildStepIcon(BuildContext context, StepStatus status) {
    Color color;
    IconData icon;

    switch (status) {
      case StepStatus.completed:
        color = Colors.green;
        icon = Icons.check;
        break;
      case StepStatus.inProgress:
        color = Colors.blue;
        icon = Icons.circle; // Simplified "in progress" look
        break;
      case StepStatus.locked:
        color = Colors.grey;
        icon = Icons.lock;
        break;
    }

    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: status == StepStatus.inProgress ? Colors.white : color,
        border: status == StepStatus.inProgress
            ? Border.all(color: color, width: 2)
            : null,
        shape: BoxShape.circle,
      ),
      child: status == StepStatus.inProgress
          ? Center(
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
            )
          : Icon(icon, color: Colors.white, size: 16),
    );
  }

  String _getStatusDescription(StepStatus status) {
    switch (status) {
      case StepStatus.completed:
        return "Completed";
      case StepStatus.inProgress:
        return "In Progress";
      case StepStatus.locked:
        return "Locked";
    }
  }
}

// Data Mocks
enum StepStatus { completed, inProgress, locked }

class _MockUser {
  final String name;
  final String avatarUrl;
  final String? dngLeaderName;
  final Map<String, StepStatus> progress;

  _MockUser({
    required this.name,
    required this.avatarUrl,
    this.dngLeaderName,
    required this.progress,
  });
}
