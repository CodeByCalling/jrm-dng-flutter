import 'package:firebase_vertexai/firebase_vertexai.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider for the AiService
final aiServiceProvider = Provider<AiService>((ref) {
  return AiService();
});

class AiService {
  late final GenerativeModel _model;
  late final ChatSession _chat;

  AiService() {
    // Initialize the model
    // Note: Ensure you've initialized Firebase in main.dart before using this
    _model = FirebaseVertexAI.instance.generativeModel(
      model: 'gemini-1.5-flash',
    );
    
    // Start a chat session
    _chat = _model.startChat();
  }

  /// Sends a message to the AI and returns a stream of the response chunks.
  Stream<String> sendMessage(String userMessage) async* {
    try {
      final content = Content.text(userMessage);
      final response = _chat.sendMessageStream(content);
      
      await for (final chunk in response) {
        if (chunk.text != null) {
          yield chunk.text!;
        }
      }
    } catch (e) {
      // Fallback/Error handling for now
      yield "I'm having trouble connecting right now. Please try again later. ($e)";
    }
  }
}
