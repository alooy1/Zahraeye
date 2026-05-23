class Question {
  final String id;
  final String questionEn;
  final String questionAr;
  final String answer;
  final String? answerAr;
  final String puzzleType;
  final int difficulty;
  final List<String> hintsEn;
  final List<String> hintsAr;
  final int timeLimit;
  final int starsReward;
  final int coinsReward;

  const Question({
    required this.id,
    required this.questionEn,
    required this.questionAr,
    required this.answer,
    this.answerAr,
    required this.puzzleType,
    required this.difficulty,
    this.hintsEn = const [],
    this.hintsAr = const [],
    this.timeLimit = 120,
    this.starsReward = 3,
    this.coinsReward = 100,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id']?.toString() ?? '',
      questionEn: json['question_en'] ?? json['question'] ?? '',
      questionAr: json['question_ar'] ?? '',
      answer: json['answer'] ?? '',
      answerAr: json['answer_ar'],
      puzzleType: json['puzzle_type'] ?? 'swipe_connect',
      difficulty: json['difficulty'] ?? 1,
      hintsEn: List<String>.from(json['hints_en'] ?? json['hints'] ?? []),
      hintsAr: List<String>.from(json['hints_ar'] ?? []),
      timeLimit: json['time_limit'] ?? 120,
      starsReward: json['stars_reward'] ?? json['rewards']?['stars'] ?? 3,
      coinsReward: json['coins_reward'] ?? json['rewards']?['coins'] ?? 100,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question_en': questionEn,
      'question_ar': questionAr,
      'answer': answer,
      'answer_ar': answerAr,
      'puzzle_type': puzzleType,
      'difficulty': difficulty,
      'hints_en': hintsEn,
      'hints_ar': hintsAr,
      'time_limit': timeLimit,
      'stars_reward': starsReward,
      'coins_reward': coinsReward,
    };
  }
}

class QuestionPack {
  final String locationId;
  final String locationNameEn;
  final String locationNameAr;
  final List<Question> questions;

  const QuestionPack({
    required this.locationId,
    required this.locationNameEn,
    required this.locationNameAr,
    required this.questions,
  });

  factory QuestionPack.fromJson(Map<String, dynamic> json) {
    return QuestionPack(
      locationId: json['location_id'] ?? '',
      locationNameEn: json['location_name_en'] ?? '',
      locationNameAr: json['location_name_ar'] ?? '',
      questions: (json['questions'] as List<dynamic>?)
              ?.map((q) => Question.fromJson(q))
              .toList() ??
          [],
    );
  }
}