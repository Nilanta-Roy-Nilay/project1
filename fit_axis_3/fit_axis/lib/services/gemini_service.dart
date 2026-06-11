import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  static const String _apiKey = 'AQ.Ab8RN6KnS4Ogq399OB3KSFx0qfU9G7IWFnN87xPvevHy-km0eg';
  late final GenerativeModel _model;
  late final ChatSession _chat;

  GeminiService() {
    _model = GenerativeModel(
      model: 'gemini-2.5-flash',
      apiKey: _apiKey,
      generationConfig: GenerationConfig(
        temperature: 0.7,
        topK: 40,
        topP: 0.95,
        maxOutputTokens: 1024,
      ),
    );

    // Initialize chat with fitness-focused context
    _chat = _model.startChat(
      history: [
        Content.text(
          'You are a helpful fitness coach and health advisor. '
          'Provide accurate, motivating, and practical fitness advice. '
          'Focus on exercise routines, nutrition tips, workout plans, and healthy lifestyle habits. '
          'Keep responses concise and actionable. '
          'Always prioritize user safety and recommend consulting professionals for medical concerns.',
        ),
        Content.model([
          TextPart(
            'Understood! I\'m here to help you with your fitness journey. How can I assist you today?',
          ),
        ]),
      ],
    );
  }

  /// Send a message to Gemini and get a response
  Future<String> sendMessage(String message) async {
    try {
      final content = Content.text(message);
      final response = await _chat.sendMessage(content);

      if (response.text != null && response.text!.isNotEmpty) {
        return response.text!;
      } else {
        return 'I apologize, but I couldn\'t generate a response. Please try again.';
      }
    } catch (e) {
      print('Gemini Error: $e');
      if (e.toString().contains('quota') || e.toString().contains('429')) {
        return 'The AI coach is currently busy (limit reached). Please try again in a minute or check back later!';
      }
      return 'Sorry, something went wrong. Please try again later.';
    }
  }

  /// Reset the chat session
  void resetChat() {
    _chat = _model.startChat(
      history: [
        Content.text(
          'You are a helpful fitness coach and health advisor. '
          'Provide accurate, motivating, and practical fitness advice. '
          'Focus on exercise routines, nutrition tips, workout plans, and healthy lifestyle habits. '
          'Keep responses concise and actionable. '
          'Always prioritize user safety and recommend consulting professionals for medical concerns.',
        ),
        Content.model([
          TextPart(
            'Understood! I\'m here to help you with your fitness journey. How can I assist you today?',
          ),
        ]),
      ],
    );
  }

  /// Extracts calorie count for a given food using AI
  Future<double?> getCaloriesForFood(String foodQuery) async {
    try {
      final prompt =
          'Respond strictly with a single number representing the estimated total calories in: "$foodQuery". Do not include any other text, unit names like "kcal", or explanation. Just the number.';
      final content = Content.text(prompt);
      final response = await _model.generateContent([content]);

      if (response.text != null && response.text!.isNotEmpty) {
        final parsed = double.tryParse(
          response.text!.trim().replaceAll(RegExp(r'[^0-9.]'), ''),
        );
        return parsed;
      }
    } catch (e) {
      print('Gemini Nutrition Error: $e');
    }
    return null;
  }
}
