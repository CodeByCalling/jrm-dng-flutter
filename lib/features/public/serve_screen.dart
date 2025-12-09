import 'package:flutter/material.dart';

class ServeScreen extends StatelessWidget {
  const ServeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ministries = [
      {'name': 'Worship Team', 'icon': Icons.music_note},
      {'name': 'Kids Ministry', 'icon': Icons.child_care},
      {'name': 'Ushers', 'icon': Icons.accessibility_new},
      {'name': 'Media & Tech', 'icon': Icons.computer},
      {'name': 'Prayer Team', 'icon': Icons.volunteer_activism},
      {'name': 'Hospitality', 'icon': Icons.coffee},
    ];

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text('Find Your Purpose'),
              background: Container(
                color: Theme.of(context).primaryColor,
                child: Center(
                  child: Icon(
                    Icons.handshake,
                    size: 80,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16.0,
                crossAxisSpacing: 16.0,
                childAspectRatio: 1.0,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final ministry = ministries[index];
                  return Card(
                    elevation: 2,
                    child: InkWell(
                      onTap: () {
                        // TODO: Navigate to ministry details
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            ministry['icon'] as IconData,
                            size: 48,
                            color: Theme.of(context).primaryColor,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            ministry['name'] as String,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                },
                childCount: ministries.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
