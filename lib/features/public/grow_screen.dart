import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GrowScreen extends StatelessWidget {
  const GrowScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text('Spiritual Maturity'),
              background: Container(
                color: Theme.of(context).primaryColor,
                child: Center(
                  child: Icon(
                    Icons.trending_up,
                    size: 80,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const Text(
                  'Your Discipleship Journey',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                _buildTimelineItem(context, 'Class 101', 'Salvation & Baptism', true),
                _buildTimelineItem(context, 'Class 201', 'Membership', false),
                _buildTimelineItem(context, 'Class 301', 'Discovery', false),
                _buildTimelineItem(context, 'Class 401', 'Leadership', false),
                const SizedBox(height: 32),
                Center(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      context.push('/dashboard');
                    },
                    icon: const Icon(Icons.dashboard),
                    label: const Text('Access DNG Dashboard'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    ),
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(
    BuildContext context,
    String title,
    String description,
    bool isCompleted,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          Column(
            children: [
              Container(
                width: 2,
                height: 20,
                color: Colors.grey.shade300,
              ),
              Icon(
                isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
                color: isCompleted ? Colors.green : Colors.grey,
              ),
              Container(
                width: 2,
                height: 20,
                color: Colors.grey.shade300,
              ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(description),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
