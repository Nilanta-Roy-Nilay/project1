class AppConstants {
  static const String appName = 'Fit Yourself';
  static const String appTagline = 'Your 30-Day Transformation Starts Here';
  static const int totalDays = 30;
  static const int exercisesPerDay = 7;

  static const List<String> motivationalQuotes = [
    "The only bad workout is the one that didn't happen.",
    "Your body can stand almost anything. It's your mind you have to convince.",
    "Sweat is just fat crying.",
    "The pain you feel today will be the strength you feel tomorrow.",
    "Don't stop when you're tired. Stop when you're done.",
    "The hard days are what make you stronger.",
    "If it doesn't challenge you, it won't change you.",
    "Success starts with self-discipline.",
    "Your only limit is you.",
    "Push yourself, because no one else is going to do it for you.",
    "Great things never come from comfort zones.",
    "Dream it. Wish it. Do it.",
    "Wake up with determination. Go to bed with satisfaction.",
    "Do something today that your future self will thank you for.",
    "It's going to be hard, but hard does not mean impossible.",
    "The body achieves what the mind believes.",
    "Train insane or remain the same.",
    "Strive for progress, not perfection.",
    "The difference between try and triumph is a little umph.",
    "Motivation is what gets you started. Habit is what keeps you going.",
    "A one-hour workout is 4% of your day. No excuses.",
    "Sore today, strong tomorrow.",
    "Fall in love with taking care of yourself.",
    "Fitness is not about being better than someone else. It's about being better than you used to be.",
    "You don't have to be extreme, just consistent.",
    "Believe in yourself and all that you are.",
    "What seems impossible today will one day become your warm-up.",
    "No pain, no gain. Shut up and train.",
    "The clock is ticking. Are you becoming the person you want to be?",
    "Doubt kills more dreams than failure ever will.",
    "Your health is an investment, not an expense.",
    "The only place where success comes before work is in the dictionary.",
    "Every workout counts. Every meal matters.",
    "Be stronger than your strongest excuse.",
    "Champions keep playing until they get it right.",
    "Make yourself proud.",
    "Results happen over time, not overnight. Work hard, stay consistent, and be patient.",
    "Discipline is doing what needs to be done, even if you don't want to do it.",
    "You are one workout away from a good mood.",
    "It never gets easier. You just get stronger.",
    "Don't wish for a good body, work for it.",
    "The best project you'll ever work on is you.",
    "Excuses don't burn calories.",
    "A year from now, you'll wish you had started today.",
    "Nothing will work unless you do.",
    "Strength doesn't come from what you can do. It comes from overcoming the things you once thought you couldn't.",
    "Hustle for that muscle.",
    "Respect your body. It's the only one you get.",
    "Today's actions are tomorrow's results.",
    "You're not going to master the rest of your life in one day. Just relax. Master the day.",
  ];

  static String getQuoteForDay(int day) {
    return motivationalQuotes[(day - 1) % motivationalQuotes.length];
  }
}
