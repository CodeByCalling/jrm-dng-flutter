import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ClassViewerScreen extends StatefulWidget {
  final String classId;
  final String title;

  const ClassViewerScreen({
    super.key,
    required this.classId,
    required this.title,
  });

  @override
  State<ClassViewerScreen> createState() => _ClassViewerScreenState();
}

class _ClassViewerScreenState extends State<ClassViewerScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _markAsComplete() {
    // In a real app, this would call a provider to update backend status
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            Text(
              '🎉 ${widget.title} Completed!',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 200.0,
              pinned: true,
              stretch: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  widget.title,
                  style: GoogleFonts.outfit(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ),
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Theme.of(context).primaryColor,
                            Theme.of(context).primaryColor.withOpacity(0.7),
                          ],
                        ),
                      ),
                    ),
                    const Center(
                      child: Icon(
                        Icons.school_outlined,
                        size: 80,
                        color: Colors.white24,
                      ),
                    ),
                  ],
                ),
              ),
              bottom: TabBar(
                controller: _tabController,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white70,
                indicatorColor: Colors.amber,
                indicatorWeight: 3,
                tabs: const [
                  Tab(icon: Icon(Icons.play_circle_outline), text: "Video"),
                  Tab(icon: Icon(Icons.book_outlined), text: "Guide"),
                  Tab(icon: Icon(Icons.quiz_outlined), text: "Quiz"),
                ],
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildVideoTab(),
            _buildStudyGuideTab(),
            _buildQuizTab(),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FilledButton.icon(
            onPressed: _markAsComplete,
            icon: const Icon(Icons.check),
            label: const Text('Mark as Complete'),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              textStyle:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVideoTab() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(
                child: Icon(Icons.play_circle_fill,
                    size: 64, color: Colors.black26),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Video Session',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Watch the teaching session for ${widget.title}.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStudyGuideTab() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.picture_as_pdf,
                size: 80, color: Colors.deepOrangeAccent),
            const SizedBox(height: 24),
            Text(
              'Study Guide',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Download and read the study materials for this class.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 24),
            OutlinedButton.icon(
              onPressed: () {
                // Placeholder for download action
              },
              icon: const Icon(Icons.download),
              label: const Text('Download PDF'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuizTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Reflection & Quiz',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          const Text('Take a moment to reflect on what you learned.'),
          const SizedBox(height: 24),
          TextField(
            controller: _notesController,
            maxLines: 8,
            decoration: InputDecoration(
              hintText: 'Type your notes or answers here...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.grey[50],
            ),
          ),
          const SizedBox(height: 24),
          FilledButton.tonal(
            onPressed: () {
               ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Notes saved!')),
              );
            },
            child: const Text('Save Notes'),
          ),
        ],
      ),
    );
  }
}
