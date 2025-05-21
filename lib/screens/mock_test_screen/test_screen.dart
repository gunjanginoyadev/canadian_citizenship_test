import 'dart:async';
import 'package:canadian_citizenship/libs.dart';
import 'package:canadian_citizenship/main.dart';
import 'package:canadian_citizenship/model/test_result_model.dart';
import 'package:canadian_citizenship/screens/test_result_screen/test_result_screen.dart';
import 'package:canadian_citizenship/services/db_service.dart';

class TestScreen extends StatefulWidget {
  final List<MockTestDbModel> questions;
  const TestScreen({super.key, required this.questions});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  static const int _totalTimeInSeconds = 30 * 60;
  late int _remainingSeconds;
  Timer? _timer;
  int _currentQuestionIndex = 0;
  int _selectedOption = -1;
  final TestResultModel _testResults = TestResultModel(questions: []);

  @override
  void initState() {
    super.initState();
    _remainingSeconds = _totalTimeInSeconds;
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds == 0) {
        timer.cancel();
        onTimerEnd(context);
      } else {
        setState(() {
          _remainingSeconds--;
        });
      }
    });
  }

  void onTimerEnd(BuildContext context) {
    for (int i = _currentQuestionIndex; i < widget.questions.length; i++) {
      _testResults.addSkippedAnswer(
        question: widget.questions[i].question,
        correctAnswer: _getCorrectAnswer(i),
      );
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder:
            (context) => TestResultScreen(
              testResultModel: _testResults,
              questions: widget.questions,
            ),
      ),
    );
  }

  String _formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$secs';
  }

  double get _progress => (_currentQuestionIndex + 1) / widget.questions.length;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void onNextTap() {
    getLikelyCorrectOptionIndex();

    if (_currentQuestionIndex < widget.questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _selectedOption = -1; // Optional: reset selection
      });
    } else {
      // navigate to result screen or show completion dialog
      print(" --- navigate to result screen");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder:
              (context) => TestResultScreen(
                testResultModel: _testResults,
                questions: widget.questions,
              ),
        ),
      );
    }
  }

  void getLikelyCorrectOptionIndex() {
    int correctOption = int.parse(
      widget.questions[_currentQuestionIndex].answer,
    );

    // // Special handling for True/False questions
    // if (question.options.any(
    //   (opt) =>
    //       opt.toLowerCase().contains("true") ||
    //       opt.toLowerCase().contains("false"),
    // )) {
    //   final hasFalseHints =
    //       feedback.contains("not") || feedback.contains("false");
    //   final hasTrueHints =
    //       feedback.contains("true") ||
    //       feedback.contains("has its own") ||
    //       feedback.contains("is") ||
    //       feedback.contains("does");

    //   if (hasFalseHints) {
    //     bestIndex = question.options.indexWhere(
    //       (opt) => opt.toLowerCase().contains("false"),
    //     );
    //   } else if (hasTrueHints) {
    //     bestIndex = question.options.indexWhere(
    //       (opt) => opt.toLowerCase().contains("true"),
    //     );
    //   }
    // } else {
    //   // For multiple choice questions
    //   for (int i = 0; i < question.options.length; i++) {
    //     final optionText =
    //         question.options[i]
    //             .toLowerCase()
    //             .replaceFirst(RegExp(r'^\d+\s+'), '')
    //             .trim();

    //     int matches = 0;

    //     final optionWords = optionText.split(' ').where((w) => w.length > 2);

    //     for (var word in optionWords) {
    //       if (feedback.contains(word)) {
    //         matches += 1;
    //       }
    //     }

    //     if (matches > maxMatches) {
    //       maxMatches = matches;
    //       bestIndex = i;
    //     }
    //   }
    // }

    if (_selectedOption != -1) {
      if ((_selectedOption + 1) == correctOption) {
        PrefService.increaseTestProgress(
          widget.questions[_currentQuestionIndex].questionId,
        ).then((value) {
          Provider.of<MockTestProvider>(
            context,
            listen: false,
          ).updateTestProgress();
        });
        print(" --- Correct answer selected");
        _testResults.addCorrectAnswer(
          question: widget.questions[_currentQuestionIndex].question,
          selectedOption: _getSelectedOption(),
        );
      } else {
        print(" --- Wrong answer selected");
        _testResults.addWrongAnswer(
          question: widget.questions[_currentQuestionIndex].question,
          selectedOption: _getSelectedOption(),
          correctAnswer: _getCorrectAnswer(_currentQuestionIndex),
        );
      }
    } else {
      print(" --- (no selection made)");
      _testResults.addSkippedAnswer(
        question: widget.questions[_currentQuestionIndex].question,
        correctAnswer: _getCorrectAnswer(_currentQuestionIndex),
      );
    }
  }

  String _getSelectedOption() {
    if (_selectedOption == 0) {
      return widget.questions[_currentQuestionIndex].optionA;
    } else if (_selectedOption == 1) {
      return widget.questions[_currentQuestionIndex].optionB;
    } else if (_selectedOption == 2) {
      return widget.questions[_currentQuestionIndex].optionC;
    } else {
      return widget.questions[_currentQuestionIndex].optionD;
    }
  }

  String _getCorrectAnswer(int index) {
    int correctOption = int.parse(widget.questions[index].answer);
    if (correctOption == 0) {
      return widget.questions[index].optionA;
    } else if (correctOption == 1) {
      return widget.questions[index].optionB;
    } else if (correctOption == 2) {
      return widget.questions[index].optionC;
    } else {
      return widget.questions[index].optionD;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppColors.onboardingGradient()),
      child: Scaffold(
        backgroundColor: AppColors.transparent,
        appBar: AppBar(
          leadingWidth: context.responsiveSize(55),
          leading: Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: SvgPicture.asset(
                AppAssets.backArrowWhite,
                height: context.responsiveSize(35),
              ),
            ),
          ),
          centerTitle: true,
          title: Text(
            context.local.question_progress,
            style: semiBold(context, fontSize: 18, color: AppColors.white),
          ),
        ),
        body: Container(
          alignment: Alignment.topCenter,
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Timer & Question Tracker
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        AppAssets.clock,
                        height: context.responsiveSize(18),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        _formatTime(_remainingSeconds),
                        style: medium(
                          context,
                          fontSize: 14,
                          color: AppColors.white,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    "${_currentQuestionIndex + 1} ${context.local.out_of} ${widget.questions.length}",
                    style: medium(
                      context,
                      fontSize: 14,
                      color: AppColors.white,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // Progress Bar
              LinearProgressIndicator(
                value: _progress,
                minHeight: 10,
                borderRadius: BorderRadius.circular(999),
                backgroundColor: AppColors.white.withOpacity(0.2),
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
              ),

              const SizedBox(height: 20),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Text(
                                widget
                                    .questions[_currentQuestionIndex]
                                    .question,
                                style: semiBold(context, fontSize: 16),
                              ),
                              const SizedBox(height: 20),
                              if (widget
                                  .questions[_currentQuestionIndex]
                                  .optionA
                                  .isNotEmpty)
                                _optionItem(
                                  text:
                                      widget
                                          .questions[_currentQuestionIndex]
                                          .optionA,
                                  isSelected: _selectedOption == 0,
                                  onTap: () {
                                    _selectedOption = 0;
                                    setState(() {});
                                  },
                                ),
                              if (widget
                                  .questions[_currentQuestionIndex]
                                  .optionB
                                  .isNotEmpty)
                                _optionItem(
                                  text:
                                      widget
                                          .questions[_currentQuestionIndex]
                                          .optionB,
                                  isSelected: _selectedOption == 1,
                                  onTap: () {
                                    _selectedOption = 1;
                                    setState(() {});
                                  },
                                ),
                              if (widget
                                      .questions[_currentQuestionIndex]
                                      .optionC !=
                                  "null")
                                _optionItem(
                                  text:
                                      widget
                                          .questions[_currentQuestionIndex]
                                          .optionC,
                                  isSelected: _selectedOption == 2,
                                  onTap: () {
                                    _selectedOption = 2;
                                    setState(() {});
                                  },
                                ),
                              if (widget
                                      .questions[_currentQuestionIndex]
                                      .optionD !=
                                  "null")
                                _optionItem(
                                  text:
                                      widget
                                          .questions[_currentQuestionIndex]
                                          .optionD,
                                  isSelected: _selectedOption == 3,
                                  onTap: () {
                                    _selectedOption = 3;
                                    setState(() {});
                                  },
                                ),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          onNextTap();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.accent,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 12),
                          margin: EdgeInsets.only(
                            bottom: context.bottomPadding,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            context.local.next,
                            style: medium(
                              context,
                              fontSize: 16,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _optionItem({
    required String text,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 15),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withOpacity(.06),
              offset: Offset(0, 3),
              blurRadius: 12,
            ),
          ],
          border: Border.all(
            color: isSelected ? AppColors.accent : AppColors.transparent,
          ),
        ),
        padding: EdgeInsets.all(15),
        child: Text(text, style: medium(context, fontSize: 14)),
      ),
    );
  }
}
