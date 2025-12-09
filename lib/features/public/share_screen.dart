import 'package:flutter/material.dart';


class ShareScreen extends StatelessWidget {
  const ShareScreen({super.key});

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
              title: const Text('Go & Make Disciples'),
              background: Container(
                color: Theme.of(context).primaryColor,
                child: Center(
                  child: Icon(
                    Icons.public,
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
                 Text(
                   'The Great Commission',
                   style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                     fontWeight: FontWeight.bold,
                     color: Theme.of(context).primaryColor,
                   ),
                 ),
                 const SizedBox(height: 8),
                 const Text(
                   '"Therefore go and make disciples of all nations..." - Matthew 28:19',
                   style: TextStyle(fontStyle: FontStyle.italic),
                 ),
                 const SizedBox(height: 24),
                _buildResourceCard(
                  context,
                  'Evangelism Tools',
                  'Scripts, tracts, and guides to share your faith.',
                  Icons.chat_bubble_outline,
                ),
                const SizedBox(height: 16),
                _buildResourceCard(
                  context,
                  'Missions Updates',
                  'See what God is doing around the world.',
                  Icons.map_outlined,
                ),
                const SizedBox(height: 16),
                _buildResourceCard(
                  context,
                  'Invite a Friend',
                  'Share the app with someone today.',
                  Icons.share,
                  onTap: () {
                    // TODO: Implement share functionality
                  },
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResourceCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon, {
    VoidCallback? onTap,
  }) {
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
        onTap: onTap ?? () {
          // TODO: Navigate to details
        },
      ),
    );
  }
}
