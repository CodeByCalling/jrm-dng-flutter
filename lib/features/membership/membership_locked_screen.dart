import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class MembershipLockedScreen extends StatelessWidget {
  const MembershipLockedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon
                Icon(
                  Icons.church_rounded,
                  size: 80,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 24),

                // HEADLINE
                Text(
                  "Welcome to the Family",
                  style: GoogleFonts.poppins(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),

                // BODY TEXT
                Text(
                  "To access the DNG Discipleship System, you must be an official member of JRM. This ensures spiritual covering and accountability for every disciple.",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.grey[700],
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),

                // PRIMARY BUTTON
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: FilledButton(
                    onPressed: () => context.go('/membership'),
                    style: FilledButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text("Apply for Membership"),
                  ),
                ),
                const SizedBox(height: 16),

                // SECONDARY BUTTON
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton(
                    onPressed: () => context.push('/contact-admin'),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text("I'm already a member"),
                  ),
                ),
                const SizedBox(height: 24),

                // TEXT LINK
                TextButton(
                  onPressed: () => context.go('/'),
                  child: const Text("Back to Home"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
