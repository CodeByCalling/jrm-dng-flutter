import 'package:flutter/material.dart';

// 1. DATA MODEL
class Lesson {
  final String title;
  final int phase;
  final String description;
  final String pdfUrl;

  const Lesson({
    required this.title,
    required this.phase,
    required this.description,
    required this.pdfUrl,
  });
}

// Dummy Data
final List<Lesson> dummyLessons = [
  // Phase 1
  const Lesson(
    title: 'Called to Grow',
    phase: 1,
    description: 'Foundational teachings for spiritual growth.',
    pdfUrl: 'https://example.com/called_to_grow.pdf',
  ),
  const Lesson(
    title: 'Called to Joy',
    phase: 1,
    description: 'Discovering true joy in your walk of faith.',
    pdfUrl: 'https://example.com/called_to_joy.pdf',
  ),
  // Phase 2
  const Lesson(
    title: 'Leadership 101',
    phase: 2,
    description: 'Essential principles for effective Christian leadership.',
    pdfUrl: 'https://example.com/leadership_101.pdf',
  ),
  // Phase 3
  const Lesson(
    title: 'Multiplication Strategy',
    phase: 3,
    description: 'Strategies for multiplying disciples and leaders.',
    pdfUrl: 'https://example.com/multiplication_strategy.pdf',
  ),
];

class LessonLibraryScreen extends StatefulWidget {
  const LessonLibraryScreen({super.key});

  @override
  State<LessonLibraryScreen> createState() => _LessonLibraryScreenState();
}

class _LessonLibraryScreenState extends State<LessonLibraryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<Lesson> _getFilteredLessons(int phase) {
    return dummyLessons.where((lesson) {
      final matchesPhase = lesson.phase == phase;
      final matchesSearch =
          lesson.title.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesPhase && matchesSearch;
    }).toList();
  }

  Widget _buildLessonList(int phase) {
    final lessons = _getFilteredLessons(phase);

    if (lessons.isEmpty) {
      return Center(
        child: Text(
          _searchQuery.isEmpty
              ? 'No lessons found for Phase $phase.'
              : 'No results found.',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: lessons.length,
      itemBuilder: (context, index) {
        final lesson = lessons[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16.0),
          child: ListTile(
            title: Text(
              lesson.title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(lesson.description),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.description, color: Colors.blue),
              tooltip: 'Download/View',
              onPressed: () {
                // Placeholder action
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Opening ${lesson.title}...'),
                  ),
                );
              },
            ),
            contentPadding: const EdgeInsets.all(16.0),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lesson Library'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Phase 1'),
            Tab(text: 'Phase 2'),
            Tab(text: 'Phase 3'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SearchBar(
              controller: _searchController,
              hintText: 'Search lessons by title...',
              leading: const Icon(Icons.search),
              trailing: [
                if (_searchQuery.isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                    },
                  ),
              ],
            ),
          ),
          // Tab Views
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildLessonList(1),
                _buildLessonList(2),
                _buildLessonList(3),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
