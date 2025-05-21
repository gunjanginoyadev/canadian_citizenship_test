import 'dart:io';

import 'package:canadian_citizenship/model/glossary_model.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBService {
  static final DBService _instance = DBService._internal();
  static Database? _db;

  factory DBService() {
    return _instance;
  }

  DBService._internal();

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDatabase();
    return _db!;
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, "glossary.db");

    final exists = await databaseExists(path);
    if (!exists) {
      ByteData data = await rootBundle.load("assets/data/canadacity.db");
      List<int> bytes = data.buffer.asUint8List(
        data.offsetInBytes,
        data.lengthInBytes,
      );

      await File(path).writeAsBytes(bytes, flush: true);
    }

    return openDatabase(path);
  }

  /// Get all glossary items
  Future<List<GlossaryModel>> getAllGlossaryItems() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('glossary');
    return maps.map((json) => GlossaryModel.fromJson(json)).toList();
  }

  /// Get all mock test questions
  Future<List<MockTestDbModel>> getAllMockTestQuestions() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('mock_test');
    return maps.map((json) => MockTestDbModel.fromJson(json)).toList();
  }

  Future<List<MockTestDbModel>> getSpecificMockTestQuestions(
    String category,
  ) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'mock_test',
      where: 'category = ?',
      whereArgs: [category],
    );
    return maps
        .map(
          (json) => MockTestDbModel(
            questionId: json["questionId"].toString(),
            question: json["question"].toString(),
            answer: json["answer"].toString(),
            optionNo: json["optionNo"].toString(),
            optionA: json["optionA"].toString(),
            optionB: json["optionB"].toString(),
            optionC: json["optionC"].toString(),
            optionD: json["optionD"].toString(),
            category: json["category"].toString(),
          ),
        )
        .toList();
  }

  /// Get all lesson test questions
  Future<List<LessonPracticeTestDbModel>> getAllLessonTestQuestions() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('lesson_test');
    return maps.map((json) => LessonPracticeTestDbModel.fromJson(json)).toList();
  }

  Future<List<LessonPracticeTestDbModel>> getSpecificLessonTestQuestions(
    String category,
  ) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'lesson_test',
      where: 'category = ?',
      whereArgs: [category],
    );
    return maps.map((json) => LessonPracticeTestDbModel.fromJson(json)).toList();
  }
}

class MockTestDbModel {
  final String questionId;
  final String question;
  final String answer;
  final String optionNo;
  final String optionA;
  final String optionB;
  final String optionC;
  final String optionD;
  final String category;

  MockTestDbModel({
    required this.questionId,
    required this.question,
    required this.answer,
    required this.optionNo,
    required this.optionA,
    required this.optionB,
    required this.optionC,
    required this.optionD,
    required this.category,
  });

  factory MockTestDbModel.fromJson(Map<String, dynamic> json) {
    return MockTestDbModel(
      questionId: json['questionId'].toString(),
      question: json['question'].toString(),
      answer: json['answer'.toString()],
      optionNo: json['optionNo'].toString(),
      optionA: json['optionA'].toString(),
      optionB: json['optionB'].toString(),
      optionC: json['optionC'].toString(),
      optionD: json['optionD'].toString(),
      category: json['category'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'questionId': questionId,
      'question': question,
      'answer': answer,
      'optionNo': optionNo,
      'optionA': optionA,
      'optionB': optionB,
      'optionC': optionC,
      'optionD': optionD,
      'category': category,
    };
  }
}

class LessonPracticeTestDbModel {
  final int questionId;
  final String question;
  final int answer;
  final String optionA;
  final String optionB;
  final String optionC;
  final String optionD;
  final int bookmark;
  final String category;

  LessonPracticeTestDbModel({
    required this.questionId,
    required this.question,
    required this.answer,
    required this.optionA,
    required this.optionB,
    required this.optionC,
    required this.optionD,
    required this.bookmark,
    required this.category,
  });

  factory LessonPracticeTestDbModel.fromJson(Map<String, dynamic> json) {
    return LessonPracticeTestDbModel(
      questionId: json['questionId'] as int,
      question: json['question'] ?? '',
      answer: json['answer'] as int,
      optionA: json['optionA'] ?? '',
      optionB: json['optionB'] ?? '',
      optionC: json['optionC'] ?? '',
      optionD: json['optionD'] ?? '',
      bookmark: json['bookmark'] as int,
      category: json['category'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'questionId': questionId,
      'question': question,
      'answer': answer,
      'optionA': optionA,
      'optionB': optionB,
      'optionC': optionC,
      'optionD': optionD,
      'bookmark': bookmark,
      'category': category,
    };
  }
}
