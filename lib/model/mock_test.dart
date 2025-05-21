class MockTest {
  final int id;
  final int index;
  final int appId;
  final int time;
  final String title;
  final String data;
  final String? extra;
  final List<MockTestQuestion> questions;

  MockTest({
    required this.id,
    required this.index,
    required this.appId,
    required this.time,
    required this.title,
    required this.data,
    this.extra,
    required this.questions,
  });

  factory MockTest.fromJson(Map<String, dynamic> json) {
    return MockTest(
      id: json['id'],
      index: json['index'],
      appId: json['appId'],
      time: json['time'],
      title: json['title'],
      data: json['data'],
      extra: json['extra'],
      questions: (json['questions'] as List)
          .map((q) => MockTestQuestion.fromJson(q))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'index': index,
        'appId': appId,
        'time': time,
        'title': title,
        'data': data,
        'extra': extra,
        'questions': questions.map((q) => q.toJson()).toList(),
      };
}

class MockTestQuestion {
  final int id;
  final int? lessonId;
  final int hasImage;
  final int testId;
  final String question;
  final String optionsType;
  final String feedback;
  final String type;
  final List<String> options;

  MockTestQuestion({
    required this.id,
    this.lessonId,
    required this.hasImage,
    required this.testId,
    required this.question,
    required this.optionsType,
    required this.feedback,
    required this.type,
    required this.options,
  });

  factory MockTestQuestion.fromJson(Map<String, dynamic> json) {
    return MockTestQuestion(
      id: json['id'],
      lessonId: json['lessonId'],
      hasImage: json['hasImage'],
      testId: json['testId'],
      question: json['question'],
      optionsType: json['optionsType'],
      feedback: json['feedback'],
      type: json['type'],
      options: List<String>.from(json['options']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'lessonId': lessonId,
        'hasImage': hasImage,
        'testId': testId,
        'question': question,
        'optionsType': optionsType,
        'feedback': feedback,
        'type': type,
        'options': options,
      };
}
