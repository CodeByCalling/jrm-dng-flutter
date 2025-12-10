import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jrm_dng_flutter/features/auth/auth_provider.dart';

class MembershipLockedPage extends ConsumerWidget {
  const MembershipLockedPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final uid = authState.user?.uid ?? 'none';
    final profileFound = authState.profileFound == true ? 'yes' : 'no';
    final membershipStatus = authState.membershipStatus ?? 'unknown';

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const Spacer(),
              Icon(
                Icons.lock_person,
                size: 80,
                color: Colors.amber[800],
              ),
              const SizedBox(height: 24),
              Text(
                "Members Only Access",
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                "The DNG Dashboard is reserved for Official Members. Please complete Class 101 to unlock this feature.",
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.grey,
                    ),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => context.go('/class/101?title=Class%20101:%20Salvation'),
                  child: const Text("Go to Class 101"),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => context.go('/'),
                  child: const Text("Back to Home"),
                ),
              ),
              const SizedBox(height: 24),
              const Divider(),
              const Text(
                "Debug Info:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text("Current Auth UID: $uid"),
              Text("Firestore Profile Found: $profileFound"),
              Text("Status in DB: $membershipStatus"),
            ],
          ),
        ),
      ),
    );
  }
}
