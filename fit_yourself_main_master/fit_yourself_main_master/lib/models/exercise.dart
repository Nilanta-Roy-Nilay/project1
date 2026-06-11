class Exercise {
  final String name;
  final String description;
  final List<String> instructions;
  final String targetMuscle;
  final String difficulty;
  final int defaultDuration;
  final String emoji;

  const Exercise({
    required this.name,
    required this.description,
    required this.instructions,
    required this.targetMuscle,
    required this.difficulty,
    required this.defaultDuration,
    required this.emoji,
  });
}
