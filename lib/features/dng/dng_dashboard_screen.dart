import 'package:flutter/material.dart';
import 'package:jrm_dng_flutter/features/ai/ai_assistant_fab.dart';

class DngDashboardScreen extends StatelessWidget {
  const DngDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Hardcoded for now as per requirements
    const userName = "DNG Leader"; 
    const activeDisciplesCount = 5;

    return Scaffold(
      floatingActionButton: const AiAssistantFab(),
      appBar: AppBar(
        title: const Text('DNG Dashboard'),
        centerTitle: false,
      ),
      body: CustomScrollView(
        slivers: [
          // 1. Header Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                   Text(
                    'Welcome, $userName',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        children: [
                          Text(
                            '$activeDisciplesCount',
                            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          Text(
                            'Active Disciples',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 2. Action Grid Section
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            sliver: SliverGrid.count(
              crossAxisCount: 2,
              mainAxisSpacing: 16.0,
              crossAxisSpacing: 16.0,
              children: [
                _ActionCard(
                  icon: Icons.group,
                  label: "My Disciples",
                  onTap: () {},
                ),
                _ActionCard(
                  icon: Icons.edit_calendar,
                  label: "Log Meeting",
                  onTap: () {},
                ),
                _ActionCard(
                  icon: Icons.account_tree,
                  label: "Discipleship Tree",
                  onTap: () {},
                ),
                _ActionCard(
                  icon: Icons.library_books,
                  label: "Lesson Library",
                  onTap: () {},
                ),
              ],
            ),
          ),

          // 3. Recent Activity Section Header
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 32.0, 16.0, 8.0),
              child: Text(
                'Recent Activity',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          ),

          // 4. Recent Activity List
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.calendar_today, size: 20),
                  ),
                  title: Text('Meeting with Disciple ${index + 1}'),
                  subtitle: Text('Recorded on ${DateTime.now().toString().split(' ')[0]}'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {},
                );
              },
              childCount: 10, // Placeholder count
            ),
          ),
          
          // Bottom padding for scroll
          const SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: Theme.of(context).colorScheme.primary),
              const SizedBox(height: 12),
              Text(
                label,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
