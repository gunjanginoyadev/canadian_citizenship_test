class TestResultModel {
  int score;
  int correctAnswers;
  int wrongAnswers;
  List<TestResultQuestion> questions;

  TestResultModel({
    this.score = 0,
    this.correctAnswers = 0,
    this.wrongAnswers = 0,
    required this.questions,
  });

  void addWrongAnswer({
    required String question,
    required String selectedOption,
    required String correctAnswer,
  }) {
    questions.add(
      TestResultQuestion(
        question: question,
        wrongOption: selectedOption,
        correctAnswer: correctAnswer,
        type: TestResultQuestionType.wrong,
      ),
    );
  }

  void addCorrectAnswer({
    required String question,
    required String selectedOption,
  }) {
    questions.add(
      TestResultQuestion(
        question: question,
        wrongOption: "",
        correctAnswer: selectedOption,
        type: TestResultQuestionType.correct,
      ),
    );
  }

  void addSkippedAnswer({
    required String question,
    required String correctAnswer,
  }) {
    questions.add(
      TestResultQuestion(
        question: question,
        wrongOption: "",
        correctAnswer: correctAnswer,
        type: TestResultQuestionType.skipped,
      ),
    );
  }
}

class TestResultQuestion {
  String question;
  String correctAnswer;
  String wrongOption;
  TestResultQuestionType type;

  TestResultQuestion({
    required this.question,
    required this.correctAnswer,
    required this.wrongOption,
    required this.type,
  });

  // Add the missing getters
  bool get isCorrect => type == TestResultQuestionType.correct;
  bool get isSkipped => type == TestResultQuestionType.skipped;
}

enum TestResultQuestionType { correct, wrong, skipped }
