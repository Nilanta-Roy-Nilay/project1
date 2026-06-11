import 'package:flutter/material.dart';

class ChatbotService extends ChangeNotifier {
  List<ChatMessage> _messages = [];

  List<ChatMessage> get messages => _messages;

  // Predefined responses
  final Map<String, List<String>> _responses = {
    'workout': [
      '💪 For effective workouts, try mixing cardio and strength training. Aim for 30-45 minutes daily!',
      '🏋️‍♂️ Here\'s a great home workout: 20 push-ups, 30 squats, 40 lunges, and 1-minute plank. Repeat 3 times!',
      '🏃‍♂️ Running is excellent for cardiovascular health. Start with 15 minutes and gradually increase.',
      '🧘‍♀️ Don\'t forget to stretch before and after workouts to prevent injuries!',
    ],
    'nutrition': [
      '🥗 Eat protein-rich foods like eggs, chicken, and lentils for muscle recovery.',
      '🍎 Stay hydrated! Drink at least 8 glasses of water daily.',
      '🥑 Healthy fats from avocados and nuts are essential for your body.',
      '🥦 Eat a rainbow of vegetables for maximum nutrients!',
    ],
    'motivation': [
      '🌟 You\'re doing great! Every small step counts towards your goal.',
      '💫 Remember: Progress, not perfection! Keep going!',
      '🎯 Set small achievable goals. You can do this!',
      '🔥 The only bad workout is the one that didn\'t happen!',
    ],
    'progress': [
      '📊 Track your daily steps, calories, and water intake in the Dashboard.',
      '📈 Consistency is key! Try to improve by 5% each week.',
      '🏆 Celebrate small victories - they lead to big achievements!',
    ],
    'greeting': [
      'Hello! 👋 I\'m your fitness assistant. How can I help you today?',
      'Hi there! 💪 Ready to crush your fitness goals?',
      'Welcome back! 🌟 What fitness question can I answer for you?',
    ],
    'help': [
      '🤖 I can help you with:\n• Workout tips\n• Nutrition advice\n• Motivation\n• Progress tracking\n• Fitness FAQs',
    ],
    'default': [
      'Great question! 💪 For personalized advice, try being more specific about your fitness goals.',
      'I\'m here to help! 🎯 Could you tell me more about what you\'re looking for?',
      'That\'s a good topic! 🌟 Let me give you some general fitness advice...',
    ],
  };

  void addWelcomeMessage() {
    _messages = [];
    _messages.add(
      ChatMessage(
        text: _responses['greeting']![0],
        isUser: false,
        timestamp: DateTime.now(),
      ),
    );
    notifyListeners();
  }

  Future<void> addUserMessage(String message) async {
    _messages.add(
      ChatMessage(text: message, isUser: true, timestamp: DateTime.now()),
    );
    notifyListeners();
  }

  Future<void> getBotResponse(String userMessage, String userName) async {
    String response = _generateResponse(userMessage.toLowerCase(), userName);

    _messages.add(
      ChatMessage(text: response, isUser: false, timestamp: DateTime.now()),
    );
    notifyListeners();
  }

  String _generateResponse(String message, String userName) {
    // Check for greetings
    if (message.contains('hi') ||
        message.contains('hello') ||
        message.contains('hey')) {
      return _getRandomResponse('greeting');
    }

    // Check for help
    if (message.contains('help') || message.contains('what can you do')) {
      return _getRandomResponse('help');
    }

    // Check for workout related
    if (message.contains('workout') ||
        message.contains('exercise') ||
        message.contains('gym') ||
        message.contains('training')) {
      return _getRandomResponse('workout');
    }

    // Check for nutrition related
    if (message.contains('food') ||
        message.contains('eat') ||
        message.contains('diet') ||
        message.contains('nutrition') ||
        message.contains('meal') ||
        message.contains('protein') ||
        message.contains('calories') ||
        message.contains('weight loss')) {
      return _getRandomResponse('nutrition');
    }

    // Check for motivation
    if (message.contains('motivation') ||
        message.contains('encouragement') ||
        message.contains('tired') ||
        message.contains('give up') ||
        message.contains('hard')) {
      return _getMotivationalResponse(userName);
    }

    // Check for progress
    if (message.contains('progress') ||
        message.contains('track') ||
        message.contains('stats') ||
        message.contains('improve')) {
      return _getRandomResponse('progress');
    }

    // Check for specific questions
    if (message.contains('how many steps')) {
      return '👟 Track your daily steps in the Dashboard. Aim for 10,000 steps per day for optimal health!';
    }

    if (message.contains('water') || message.contains('hydrate')) {
      return '💧 Drink water regularly! Aim for 8 glasses (2 liters) per day. Use the +Add Water button in Dashboard to track!';
    }

    if (message.contains('sleep')) {
      return '😴 Quality sleep is crucial for recovery. Aim for 7-9 hours of sleep each night.';
    }

    if (message.contains('heart rate')) {
      return '❤️ Normal resting heart rate is 60-100 BPM. Regular exercise helps improve heart health!';
    }

    // Default response
    return _getRandomResponse('default');
  }

  String _getRandomResponse(String category) {
    final responses = _responses[category] ?? _responses['default']!;
    return responses[DateTime.now().millisecondsSinceEpoch % responses.length];
  }

  String _getMotivationalResponse(String userName) {
    List<String> motivationalQuotes = [
      '🌟 $userName, you are stronger than you think! Keep pushing forward!',
      '💪 Every champion was once a beginner. You\'ve got this, $userName!',
      '🔥 Your only limit is your mind. Stay focused and keep grinding!',
      '🎯 Success doesn\'t come from comfort zones. You\'re making progress, $userName!',
      '🏆 Believe in yourself! Small daily improvements lead to amazing results.',
      '💫 $userName, remember why you started. Don\'t stop now!',
    ];
    return motivationalQuotes[
        DateTime.now().millisecondsSinceEpoch % motivationalQuotes.length];
  }

  void clearChat() {
    _messages = [];
    addWelcomeMessage();
    notifyListeners();
  }
}

// Chat Message Model
class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}
