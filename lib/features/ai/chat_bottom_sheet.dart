import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'ai_service.dart';

// Model for chat messages
class ChatMessage {
  final String text;
  final bool isUser;

  ChatMessage({required this.text, required this.isUser});
}

// Local provider for the list of messages in the current session
final chatMessagesProvider = StateProvider.autoDispose<List<ChatMessage>>((ref) => []);

// Local provider to track if AI is typing (streaming)
final isAiTypingProvider = StateProvider.autoDispose<bool>((ref) => false);

class ChatBottomSheet extends ConsumerStatefulWidget {
  const ChatBottomSheet({super.key});

  @override
  ConsumerState<ChatBottomSheet> createState() => _ChatBottomSheetState();
}

class _ChatBottomSheetState extends ConsumerState<ChatBottomSheet> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage() async {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    _textController.clear();

    // 1. Add User Message
    ref.read(chatMessagesProvider.notifier).update((state) => [
          ...state,
          ChatMessage(text: text, isUser: true),
        ]);
    
    _scrollToBottom();
    ref.read(isAiTypingProvider.notifier).state = true;

    // 2. Prepare AI Message Placeholder
    // We will append chunks to the last message as they arrive.
    // First, add an empty AI message that we will mutate/replace.
    ref.read(chatMessagesProvider.notifier).update((state) => [
          ...state,
          ChatMessage(text: "", isUser: false),
        ]);

    final aiService = ref.read(aiServiceProvider);

    try {
      final stream = aiService.sendMessage(text);
      String fullResponse = "";

      await for (final chunk in stream) {
        fullResponse += chunk;
        
        // Update the last message (which is the AI's) with the accumulating text
        ref.read(chatMessagesProvider.notifier).update((state) {
          final newState = List<ChatMessage>.from(state);
          if (newState.isNotEmpty && !newState.last.isUser) {
             newState.removeLast();
          }
           newState.add(ChatMessage(text: fullResponse, isUser: false));
           return newState;
        });
        _scrollToBottom();
      }
    } catch (e) {
       ref.read(chatMessagesProvider.notifier).update((state) => [
          ...state,
          ChatMessage(text: "Error: $e", isUser: false),
        ]);
    } finally {
      ref.read(isAiTypingProvider.notifier).state = false;
      _scrollToBottom();
    }
  }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(chatMessagesProvider);
    final isTyping = ref.watch(isAiTypingProvider);

    return Container(
      height: MediaQuery.of(context).size.height * 0.85, // 85% of screen height
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle Bar
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              children: [
                Icon(Icons.auto_awesome, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Lesson Assistant',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          const Divider(),

          // Chat Area
          Expanded(
            child: messages.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.chat_bubble_outline, 
                             size: 48, 
                             color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        Text(
                          "Ask me anything about your lessons!",
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final msg = messages[index];
                      return Align(
                        alignment: msg.isUser 
                            ? Alignment.centerRight 
                            : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width * 0.75),
                          decoration: BoxDecoration(
                            color: msg.isUser
                                ? Theme.of(context).colorScheme.primary
                                : Colors.grey[100],
                            borderRadius: BorderRadius.circular(16).copyWith(
                              bottomRight: msg.isUser ? const Radius.circular(0) : null,
                              bottomLeft: !msg.isUser ? const Radius.circular(0) : null,
                            ),
                          ),
                          child: Text(
                            msg.text,
                            style: TextStyle(
                              color: msg.isUser ? Colors.white : Colors.black87,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
          
          if (isTyping && messages.isEmpty)
             const LinearProgressIndicator(),

          // Input Area
          Divider(height: 1, color: Colors.grey[200]),
          Padding(
            padding: EdgeInsets.fromLTRB(
                16, 
                16, 
                16, 
                16 + MediaQuery.of(context).viewInsets.bottom),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                    ),
                    textCapitalization: TextCapitalization.sentences,
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                FloatingActionButton.small(
                  onPressed: _sendMessage,
                  elevation: 0,
                  child: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
