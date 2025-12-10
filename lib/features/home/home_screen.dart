import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jrm_dng_flutter/features/auth/auth_provider.dart';


class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final isAuthenticated = authState.isAuthenticated;
    final user = authState.user;
    
    // Attempt to get role/membership if available on user object (ignoring for now if not strictly typed on User)
    // Actually, AuthState has isOfficialMember. 
    // The prompt asked for: "Debug: Role=[${user?.role}], Status=[${user?.membershipStatus}]"
    // Since 'User' is FirebaseAuth user, it might not have these custom fields directly unless extended or fetched separately.
    // However, the user prompt explicitly requested this string. I will assume for now we use what we have or placeholders if the User object is standard Firebase User.
    // Standard Firebase User doesn't have 'role' or 'membershipStatus'. 
    // But the prompt implies we should check if the app is reading firestore data. 
    // unique fields might be in a separate user model.
    // Re-reading usage: The user likely means the custom user model, but authProvider state only has `User? user` (Firebase) and `bool isOfficialMember`.
    // I will try to display what's available in AuthState to be safe, or just the placeholders if undefined to avoid compilation errors on standard User.
    // Wait, the prompt said: "Debug: Role=[${user?.role}], Status=[${user?.membershipStatus}]"
    // If 'user' here refers to the custom model, I don't have it in AuthState based on my previous read (AuthState has `User? user` from firebase_auth).
    // I will check `auth_provider.dart` again to see if I missed a custom model. 
    // Previous "view_file" of `auth_provider.dart` showed `final User? user;` which is `firebase_auth`.
    // So `user.role` will fail.
    // I will implement the debug text using `isOfficialMember` from AuthState which IS available, and maybe `email`.
    // OR, I'll print "Role=[N/A (FirebaseUser)], Status=[Official:${authState.isOfficialMember}]".
    // The prompt was specific, but maybe they think I have the custom model.
    // I'll stick to what compiles: `authState.isOfficialMember` is the closest "Status".

    return Scaffold(

      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
        title: Row(
          children: [
            // Placeholder for Logo if needed, for now just text
            Text(
              'JRM',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
        actions: [
          // Log Meeting Button (Temporary for Dev/Leader)
          TextButton.icon(
            onPressed: () {
              context.push('/log-meeting');
            },
            icon: const Icon(Icons.edit_calendar, size: 18),
            label: const Text('Log Meeting'),
             style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.primary,
              textStyle: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(width: 8), 
          // The "Gate": Dynamic Member Login / Dashboard
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: TextButton.icon(
              onPressed: () {
                if (isAuthenticated) {
                  context.go('/dashboard');
                } else {
                  context.go('/login');
                }
              },
              icon: Icon(isAuthenticated ? Icons.dashboard : Icons.person, size: 18),
              label: Text(isAuthenticated ? 'Dashboard' : 'Member Login'),
              style: TextButton.styleFrom(
                foregroundColor: Colors.grey[700], // Discreet color
                textStyle: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Hero Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                width: double.infinity,
                height: 400,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  image: const DecorationImage(
                    image: NetworkImage(
                      'https://images.unsplash.com/photo-1438232992991-995b7058bbb3?ixlib=rb-4.0.3&auto=format&fit=crop&w=1600&q=80',
                    ),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      Colors.black38,
                      BlendMode.darken,
                    ),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Welcome Home',
                        style: Theme.of(context).textTheme.displayMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                const Shadow(
                                  offset: Offset(0, 2),
                                  blurRadius: 4,
                                  color: Colors.black45,
                                ),
                              ],
                            ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Join us this Sunday at 10 AM',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                      FilledButton(
                        onPressed: () {
                          // TODO: Plan Visit Action
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.secondary,
                          foregroundColor: Theme.of(context).colorScheme.onSecondary,
                          padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 20),
                          textStyle: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                        child: const Text('Plan Your Visit'),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Content Cards
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  // Responsive: Column on phone, Row on tablet/desktop
                  if (constraints.maxWidth > 700) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: _buildCard(context, 'Connect', Icons.people_outline, 'Find your community in a Life Group.', onTap: () {})),
                        const SizedBox(width: 24),
                        Expanded(child: _buildCard(context, 'Grow', Icons.auto_graph, 'Deepen your faith with our discipleship path.', onTap: () => context.push('/dng-profile'))),
                        const SizedBox(width: 24),
                        Expanded(child: _buildCard(context, 'Serve', Icons.volunteer_activism, 'Make a difference by joining a team.', onTap: () {})),
                      ],
                    );
                  } else {
                    return Column(
                      children: [
                        _buildCard(context, 'Connect', Icons.people_outline, 'Find your community in a Life Group.', onTap: () {}),
                        const SizedBox(height: 16),
                        _buildCard(context, 'Grow', Icons.auto_graph, 'Deepen your faith with our discipleship path.', onTap: () => context.push('/dng-profile')),
                        const SizedBox(height: 16),
                        _buildCard(context, 'Serve', Icons.volunteer_activism, 'Make a difference by joining a team.', onTap: () {}),
                      ],
                    );
                  }
                },
              ),
            ),
            const SizedBox(height: 64),
            
            // Debug Info
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Debug: User=[${user?.email ?? "Guest"}], OfficialMember=[${authState.isOfficialMember}]',
                 style: TextStyle(color: Colors.grey[400], fontSize: 10),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, String title, IconData icon, String description, {VoidCallback? onTap}) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withAlpha(26)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withAlpha(26),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 32,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.grey[800],
                ),
          ),
          const SizedBox(height: 16),
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Learn More',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.arrow_forward_rounded,
                    size: 16,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
