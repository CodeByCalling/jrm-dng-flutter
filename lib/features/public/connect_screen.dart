import 'package:flutter/material.dart';

class ConnectScreen extends StatelessWidget {
  const ConnectScreen({super.key});

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
              title: const Text('Join the Family'),
              background: Container(
                color: Theme.of(context).primaryColor,
                child: Center(
                  child: Icon(
                    Icons.people_outline,
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
                _buildActionCard(
                  context,
                  'New Believers Class',
                  'Start your journey with strong foundations.',
                  Icons.favorite,
                ),
                const SizedBox(height: 16),
                _buildActionCard(
                  context,
                  'Join a Small Group',
                  'Connect with others and grow together.',
                  Icons.groups,
                ),
                const SizedBox(height: 16),
                _buildActionCard(
                  context,
                  'Baptism',
                  'Publicly declare your faith.',
                  Icons.water_drop,
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
  ) {
    return Card(
      elevation: 2,
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).primaryColor, size: 32),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          // TODO: Navigate to details
        },
      ),
    );
  }
}
