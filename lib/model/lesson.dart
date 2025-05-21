class LessonMain {
  final int id;
  final int index;
  final int? parentId;
  final int appId;
  final int audioVersion;
  final String? extra;
  final String title;
  final String data;
  final bool hasAudio;
  final List<Question> questions;

  LessonMain({
    required this.id,
    required this.index,
    this.parentId,
    required this.appId,
    required this.audioVersion,
    this.extra,
    required this.title,
    required this.data,
    required this.hasAudio,
    required this.questions,
  });

  factory LessonMain.fromJson(Map<String, dynamic> json) {
    return LessonMain(
      id: json['id'],
      index: json['index'],
      parentId: json['parentId'],
      appId: json['appId'],
      audioVersion: json['audioVersion'],
      extra: json['extra'],
      title: json['title'],
      data: json['data'],
      hasAudio: json['hasAudio'],
      questions: List<Question>.from(
        json['questions'].map((q) => Question.fromJson(q)),
      ),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'index': index,
    'parentId': parentId,
    'appId': appId,
    'audioVersion': audioVersion,
    'extra': extra,
    'title': title,
    'data': data,
    'hasAudio': hasAudio,
    'questions': questions.map((q) => q.toJson()).toList(),
  };
}

class Question {
  final int id;
  final int lessonId;
  final int hasImage;
  final int? testId;
  final String question;
  final String optionsType;
  final String feedback;
  final String type;
  final List<String> options;

  Question({
    required this.id,
    required this.lessonId,
    required this.hasImage,
    this.testId,
    required this.question,
    required this.optionsType,
    required this.feedback,
    required this.type,
    required this.options,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
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

class Lesson {
  final int chapter;
  final int index;
  final int audioVersion;
  final String title;
  final String data;
  final bool hasAudio;
  final List<dynamic> questions;
  Lesson({
    required this.chapter,
    required this.index,
    required this.audioVersion,
    required this.title,
    required this.data,
    required this.hasAudio,
    required this.questions,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      chapter: json['chapter'],
      index: json['index'],
      audioVersion: json['audioVersion'],
      title: json['title'],
      data: json['data'],
      hasAudio: json['hasAudio'],
      questions: json['questions'] ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chapter': chapter,
      'index': index,
      'audioVersion': audioVersion,
      'title': title,
      'data': data,
      'hasAudio': hasAudio,
      'questions': questions,
    };
  }
}
