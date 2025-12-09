import 'package:flutter/material.dart';
import 'chat_bottom_sheet.dart';

class AiAssistantFab extends StatelessWidget {
  const AiAssistantFab({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => const ChatBottomSheet(),
        );
      },
      icon: const Icon(Icons.auto_awesome),
      label: const Text('Ask AI'),
      backgroundColor: Theme.of(context).colorScheme.secondary,
      foregroundColor: Theme.of(context).colorScheme.onSecondary,
    );
  }
}
