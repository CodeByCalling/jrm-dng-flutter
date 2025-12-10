
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// Feature Imports
import 'features/home/home_screen.dart';
import 'features/auth/login_screen.dart';
import 'features/auth/register_screen.dart';
import 'features/membership/membership_screen.dart';
import 'features/dng/dng_dashboard_screen.dart';
import 'features/dng/dng_profile_screen.dart';
import 'features/dng/leader_request_screen.dart';
import 'features/classes/class_viewer_screen.dart';
import 'features/meetings/log_meeting_screen.dart';
import 'features/dng/widgets/discipleship_tree_widget.dart';
import 'features/auth/auth_provider.dart';
import 'features/membership/pages/membership_locked_page.dart';

// Models


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

// Color Constants
const Color _primaryColor = Color(0xFF191970); // Deep Midnight Blue
const Color _accentColor = Color(0xFFFFD700); // Warm Gold

// GoRouter Configuration Provider
final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final isLoading = authState.isLoading;
      final isAuthenticated = authState.isAuthenticated;
      final isOfficialMember = authState.isOfficialMember;
      final path = state.uri.path;

      // 1. Loading
      // Only redirect to splash if we are NOT on a login/register page.
      // We want to keep the user on the login page while the auth request is processing.
      if (isLoading) {
        if (path == '/login' || path == '/register') return null; 
        if (path != '/splash') return '/splash';
        return null;
      }

      // 2. Auth Guard
      // If NOT authenticated
      if (!isAuthenticated) {
        // If on a protected path (or dashboard), send to login logic or home
        // For this app, let's say unknown users go to Login if they try to access Dashboard
        if (path.startsWith('/dashboard') || 
            path == '/profile' || 
            path == '/tree' ||
            path == '/requests' ||
            path == '/log-meeting') {
             return '/login';
        }
        
        // If just finished loading and was on splash -> go home
        if (path == '/splash') return '/';
        
        return null;
      }

      // 3. Authenticated
      if (isAuthenticated) {
        // If user is on an auth page, splash, or root -> Force correct destination
        final isAuthPage = path == '/login' || path == '/register';
        final isSplash = path == '/splash';
        final isRoot = path == '/';

        if (isAuthPage || isSplash) {
           return isOfficialMember ? '/dashboard' : '/membership-locked';
        }

        // 4. Membership Guard for Dashboard
        if (path.startsWith('/dashboard') && !isOfficialMember) {
           return '/membership-locked';
        }
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      ),
      GoRoute(
        path: '/membership-locked',
        builder: (context, state) => const MembershipLockedPage(),
      ),
      ShellRoute(
        builder: (context, state, child) {
          return child;
        },
        routes: [
           GoRoute(
            path: '/',
            builder: (context, state) => const DevScaffold(
              body: HomeScreen(),
            ),
          ),
          GoRoute(
            path: '/login',
            builder: (context, state) => const LoginScreen(),
          ),
          GoRoute(
            path: '/register',
            builder: (context, state) => const RegisterScreen(),
          ),
          GoRoute(
            path: '/membership',
            builder: (context, state) => const MembershipScreen(),
          ),
          GoRoute(
            path: '/dashboard',
            builder: (context, state) => const DngDashboardScreen(),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const DngProfileScreen(),
          ),
          GoRoute(
            path: '/requests',
            builder: (context, state) => const LeaderRequestScreen(),
          ),
          GoRoute(
            path: '/class/:id',
            builder: (context, state) {
               final classId = state.pathParameters['id']!;
               final title = state.uri.queryParameters['title'] ?? 'Class Details';
               return ClassViewerScreen(classId: classId, title: title);
            },
          ),
          GoRoute(
            path: '/log-meeting',
            builder: (context, state) => const LogMeetingScreen(),
          ),
          GoRoute(
            path: '/tree',
            builder: (context, state) {
              return Scaffold(
                appBar: AppBar(title: const Text('Discipleship Tree')),
                body: const DiscipleshipTreeWidget(),
              );
            },
          ),
        ]
      ),
    ],
  );
});

// Dev Scaffold to wrap HomeScreen
class DevScaffold extends StatelessWidget {
  final Widget body;
  const DevScaffold({super.key, required this.body});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DevDrawer(),
      body: body,
    );
  }
}

// THE DEV DRAWER
class DevDrawer extends ConsumerWidget {
  const DevDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'JRM Dev Tools',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Quick Navigation',
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Visitor Home (/)'),
            onTap: () => context.go('/'),
          ),
          ListTile(
            leading: const Icon(Icons.login),
            title: const Text('Login (/login)'),
            onTap: () => context.push('/login'),
          ),
          ListTile(
            leading: const Icon(Icons.person_add),
            title: const Text('Register (/register)'),
            onTap: () => context.push('/register'),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.card_membership),
            title: const Text('The Gate (/membership)'),
            onTap: () => context.push('/membership'),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text('Leader Dashboard (/dashboard)'),
            onTap: () => context.push('/dashboard'),
          ),
          ListTile(
            leading: const Icon(Icons.person_pin),
            title: const Text('My Profile (/profile)'),
            onTap: () => context.push('/profile'),
          ),
          ListTile(
            leading: const Icon(Icons.group_add),
            title: const Text('Leader Requests (/requests)'),
            onTap: () => context.push('/requests'),
          ),
          ListTile(
            leading: const Icon(Icons.edit_calendar),
            title: const Text('Log Meeting (/log-meeting)'),
            onTap: () => context.push('/log-meeting'),
          ),
           ListTile(
            leading: const Icon(Icons.account_tree),
            title: const Text('Discipleship Tree (/tree)'),
            onTap: () => context.push('/tree'),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.school),
            title: const Text('Jump to Class 101'),
            onTap: () => context.push('/class/101?title=Class%20101:%20Salvation'),
          ),
          ListTile(
            leading: const Icon(Icons.school),
            title: const Text('Jump to Class 201'),
            onTap: () => context.push('/class/201?title=Class%20201:%20Foundations'),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Force Logout', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
            onTap: () async {
              await ref.read(authProvider.notifier).logout();
              if (context.mounted) {
                context.go('/');
              }
            },
          ),
        ],
      ),
    );
  }
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the router provider
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'JRM Members Portal',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(
          seedColor: _primaryColor,
          primary: _primaryColor,
          secondary: _accentColor,
          surface: Colors.white,
          onPrimary: Colors.white,
          onSecondary: Colors.black,
        ),
        // Apply Google Fonts (Poppins)
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: _primaryColor,
          centerTitle: false,
          elevation: 0,
          scrolledUnderElevation: 0,
        ),
        // Drawer Theme
        drawerTheme: const DrawerThemeData(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
        ),
      ),
      routerConfig: router,
    );
  }
}
