import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class AIService {
  // Using the API key from your project's firebase_options.dart
  static const String _apiKey = 'AQ.Ab8RN6IJvr6wnpJu6Un8agwcaTDMcRhcUARRy8m-LL5vZnempw';
  GenerativeModel? _model;

  AIService() {
    _initializeModel();
  }

  void _initializeModel() {
    if (_apiKey.isNotEmpty) {
      try {
        _model = GenerativeModel(
          model: 'gemini-2.5-flash',
          apiKey: _apiKey,
        );
      } catch (e) {
        debugPrint('Gemini Initialization Error: $e');
        _model = null;
      }
    }
  }

  Future<String> getResponse(String userMessage, {List<DataPart>? files}) async {
    final userContext = await _getUserContext();
    
    if (_model == null) {
      return "AI service is not initialized. Please check your API key.";
    }

    try {
      final systemInstruction = """
      You are an expert AI Fitness Coach and assistant for the "Fit Yourself" app. Your name is "Fit AI".
      User Profile context: ${userContext.toString()}
      Instructions:
      1. Provide professional fitness, nutrition, and health advice.
      2. Relate general questions to a healthy lifestyle if possible.
      3. If a file/image is provided, analyze it thoroughly as a coach.
      4. Be encouraging, friendly, and concise.
      """;

      final List<Content> content = [];
      if (files != null && files.isNotEmpty) {
        // Multi-modal content: Instructions + User Message + Files
        content.add(Content.multi([
          TextPart(systemInstruction),
          TextPart("User Message: $userMessage"),
          ...files,
        ]));
      } else {
        content.add(Content.text("$systemInstruction\nUser Message: $userMessage"));
      }

      final response = await _model!.generateContent(content);
      
      return response.text ?? "I'm sorry, I couldn't generate a response.";
    } catch (e) {
      debugPrint('Gemini Error: $e');
      if (e.toString().contains('API_KEY_INVALID')) {
        return "Error: Invalid API Key. Please get a valid key from https://aistudio.google.com/app/apikey";
      } else if (e.toString().contains('PERMISSION_DENIED')) {
        return "Error: Permission Denied. Ensure 'Generative Language API' is enabled in your Google Cloud Console.";
      }
      return "Sorry, I'm having trouble connecting (Error: ${e.toString().split(':').last.trim()}). Please try again later.";
    }
  }

  Future<Map<String, dynamic>> _getUserContext() async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId != null) {
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .get();
        return doc.data() ?? {};
      }
    } catch (e) {}
    return {};
  }
}
