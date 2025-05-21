import 'dart:async';
import 'package:canadian_citizenship/libs.dart';
import 'package:canadian_citizenship/main.dart';
import 'package:canadian_citizenship/model/test_result_model.dart';
import 'package:canadian_citizenship/screens/test_result_screen/test_result_screen.dart';
import 'package:canadian_citizenship/services/db_service.dart';

class ChapterPracticeScreen extends StatefulWidget {
  final List<LessonPracticeTestDbModel> questions;
  const ChapterPracticeScreen({super.key, required this.questions});

  @override
  State<ChapterPracticeScreen> createState() => _ChapterPracticeScreenState();
}

class _ChapterPracticeScreenState extends State<ChapterPracticeScreen> {
  int currentQuestion = 0;
  int totalQuestions = 0;
  int _selectedOption = -1;
  late Timer _timer;
  Duration elapsedTime = Duration.zero;
  final TestResultModel _testResults = TestResultModel(questions: []);
  bool _showTimer = true; // To track timer visibility

  @override
  void initState() {
    super.initState();
    totalQuestions = widget.questions.length;
    startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        elapsedTime += Duration(seconds: 1);
      });
    });
  }

  String formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  // Calculate current score percentage
  int getCurrentScore() {
    if (_testResults.questions.isEmpty) return 0;
    int correctAnswers = _testResults.questions.where((q) => q.isCorrect).length;
    return ((correctAnswers / _testResults.questions.length) * 100).round();
  }

  // Calculate progress percentage
  int getProgressPercentage() {
    return (((currentQuestion + 1) / totalQuestions) * 100).round();
  }

  // Show menu dialog
  void _showMenu() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                
                // Progress section
                Row(
                  children: [
                    Text(context.local.progress, style: medium(context, fontSize: 14)),
                    const Spacer(),
                    Text("${getProgressPercentage()}%", style: medium(context, fontSize: 14)),
                  ],
                ),
                const SizedBox(height: 5),
                LinearProgressIndicator(
                  value: (currentQuestion + 1) / totalQuestions,
                  backgroundColor: Colors.red.withOpacity(0.2),
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                  minHeight: 8,
                  borderRadius: BorderRadius.circular(4),
                ),
                const SizedBox(height: 15),
                
                // Current Score section
                Row(
                  children: [
                    Text(context.local.current_score, style: medium(context, fontSize: 14)),
                    const Spacer(),
                    Text("${getCurrentScore()}%", style: medium(context, fontSize: 14)),
                  ],
                ),
                const SizedBox(height: 5),
                LinearProgressIndicator(
                  value: getCurrentScore() / 100,
                  backgroundColor: Colors.grey.withOpacity(0.2),
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
                  minHeight: 8,
                  borderRadius: BorderRadius.circular(4),
                ),
                const SizedBox(height: 25),
                _menuButton(
                  icon: Icons.home,
                  text: context.local.main_menu,
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    // Add navigation to main menu
                  },
                ),
                _menuButton(
                  icon: Icons.refresh,
                  text: context.local.restart_test,
                  onTap: () {
                    Navigator.of(context).pop();
                    _restartTest();
                  },
                ),
                
                _menuButton(
                  icon: Icons.check,
                  text: context.local.finish_test,
                  onTap: () {
                    Navigator.of(context).pop();
                    _finishTest();
                  },
                ),
                
                // _menuButton(
                //   icon: Icons.report_problem_outlined,
                //   text: "Report an Issue",
                //   onTap: () {
                //     Navigator.of(context).pop();
                //     _reportIssue();
                //   },
                // ),
                
                // _menuButton(
                //   icon: _showTimer ? Icons.timer_off : Icons.timer,
                //   text: _showTimer ? "Hide Test Timer" : "Show Test Timer",
                //   onTap: () {
                //     Navigator.of(context).pop();
                //     setState(() {
                //       _showTimer = !_showTimer;
                //     });
                //   },
                // ),
                
                // _menuButton(
                //   icon: Icons.analytics_outlined,
                //   text: "Show All Answer Stats",
                //   onTap: () {
                //     Navigator.of(context).pop();
                //     _showAnswerStats();
                //   },
                // ),
                
                // _menuButton(
                //   icon: Icons.dark_mode,
                //   text: "Dark Mode",
                //   onTap: () {
                //     Navigator.of(context).pop();
                //     _toggleDarkMode();
                //   },
                // ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Menu button widget
  Widget _menuButton({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Icon(icon, color: Colors.red[700], size: 24),
            const SizedBox(width: 15),
            Text(
              text,
              style: medium(context, fontSize: 16, color: Colors.red[700]),
            ),
          ],
        ),
      ),
    );
  }

  // Restart the test
  void _restartTest() {
    setState(() {
      currentQuestion = 0;
      _selectedOption = -1;
      elapsedTime = Duration.zero;
      _testResults.questions.clear();
    });
  }

  // Finish the test early
  void _finishTest() {
    // Add remaining questions as skipped
    for (int i = currentQuestion; i < widget.questions.length; i++) {
      if (i != currentQuestion) { // Skip the current question as it's handled separately
        _testResults.addSkippedAnswer(
          question: widget.questions[i].question,
          correctAnswer: _getCorrectAnswer(i),
        );
      }
    }
    
    // Handle the current question if not answered
    if (_selectedOption == -1) {
      _testResults.addSkippedAnswer(
        question: widget.questions[currentQuestion].question,
        correctAnswer: _getCorrectAnswer(currentQuestion),
      );
    } else {
      getLikelyCorrectOptionIndex(); // Process the current answer
    }
    
    // Navigate to results screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => TestResultScreen(
          isFromPractice: true,
          testResultModel: _testResults,
          questions: widget.questions.map((lesson) {
            return MockTestDbModel(
              questionId: lesson.questionId.toString(),
              question: lesson.question,
              answer: lesson.answer.toString(),
              optionNo: '',
              optionA: lesson.optionA,
              optionB: lesson.optionB,
              optionC: lesson.optionC,
              optionD: lesson.optionD,
              category: lesson.category,
            );
          }).toList(),
        ),
      ),
    );
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: context.responsiveSize(55),
        leading: Align(
          alignment: Alignment.centerRight,
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: SvgPicture.asset(
              AppAssets.backArrow,
              color: AppColors.black,
              height: context.responsiveSize(35),
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert, color: AppColors.accent),
            onPressed: _showMenu,
          ),
        ],
      ),
      body: Container(
        alignment: Alignment.topCenter,
        padding: EdgeInsets.fromLTRB(20, 0, 20, context.bottomPadding),
        child: Column(
          children: [
            Container(
              height: context.responsiveSize(10, min: 10),
              width: context.screenWidth,
              decoration: BoxDecoration(
                color: AppColors.accent.withOpacity(.2),
                borderRadius: BorderRadius.circular(999),
              ),
              alignment: Alignment.centerLeft,
              child: Container(
                height: context.responsiveSize(10, min: 10),
                width:
                    ((context.screenWidth - 40) / widget.questions.length) *
                    (currentQuestion + 1),
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (_showTimer)
                  Text(
                    formatTime(elapsedTime),
                    style: medium(context, fontSize: 14),
                  ),
                if (!_showTimer)
                  SizedBox.shrink(),
                Text(
                  "${currentQuestion + 1} out of $totalQuestions",
                  style: medium(
                    context,
                    fontSize: 12,
                    color: AppColors.black.withOpacity(.7),
                  ),
                ),
              ],
            ),

            // question
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text(
                      widget.questions[currentQuestion].question,
                      style: semiBold(context, fontSize: 16),
                    ),
                    const SizedBox(height: 20),
                    if (widget.questions[currentQuestion].optionA.isNotEmpty)
                      _optionItem(
                        text: widget.questions[currentQuestion].optionA,
                        isSelected: _selectedOption == 0,
                        onTap: () {
                          _selectedOption = 0;
                          setState(() {});
                        },
                      ),
                    if (widget.questions[currentQuestion].optionB.isNotEmpty)
                      _optionItem(
                        text: widget.questions[currentQuestion].optionB,
                        isSelected: _selectedOption == 1,
                        onTap: () {
                          _selectedOption = 1;
                          setState(() {});
                        },
                      ),
                    if (widget.questions[currentQuestion].optionC != "null")
                      _optionItem(
                        text: widget.questions[currentQuestion].optionC,
                        isSelected: _selectedOption == 2,
                        onTap: () {
                          _selectedOption = 2;
                          setState(() {});
                        },
                      ),
                    if (widget.questions[currentQuestion].optionD != "null")
                      _optionItem(
                        text: widget.questions[currentQuestion].optionD,
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
                margin: EdgeInsets.only(bottom: context.bottomPadding),
                alignment: Alignment.center,
                child: Text(
                  context.local.next,
                  style: medium(context, fontSize: 16, color: AppColors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Keep your existing methods...
  void onNextTap() {
    getLikelyCorrectOptionIndex();

    if (currentQuestion < widget.questions.length - 1) {
      setState(() {
        currentQuestion++;
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
                isFromPractice: true,
                testResultModel: _testResults,
                questions:
                    widget.questions.map((lesson) {
                      return MockTestDbModel(
                        questionId: lesson.questionId.toString(),
                        question: lesson.question,
                        answer: lesson.answer.toString(),
                        optionNo:
                            '', 
                        optionA: lesson.optionA,
                        optionB: lesson.optionB,
                        optionC: lesson.optionC,
                        optionD: lesson.optionD,
                        category: lesson.category,
                      );
                    }).toList(),
              ),
        ),
      );
    }
  }

  void getLikelyCorrectOptionIndex() {
    int correctOption = widget.questions[currentQuestion].answer;

    if (_selectedOption != -1) {
      if ((_selectedOption + 1) == correctOption) {
        print(" --- Correct answer selected");
        _testResults.addCorrectAnswer(
          question: widget.questions[currentQuestion].question,
          selectedOption: _getSelectedOption(),
        );
      } else {
        print(" --- Wrong answer selected");
        _testResults.addWrongAnswer(
          question: widget.questions[currentQuestion].question,
          selectedOption: _getSelectedOption(),
          correctAnswer: _getCorrectAnswer(currentQuestion),
        );
      }
    } else {
      print(" --- (no selection made)");
      _testResults.addSkippedAnswer(
        question: widget.questions[currentQuestion].question,
        correctAnswer: _getCorrectAnswer(currentQuestion),
      );
    }
  }

  String _getSelectedOption() {
    if (_selectedOption == 0) {
      return widget.questions[currentQuestion].optionA;
    } else if (_selectedOption == 1) {
      return widget.questions[currentQuestion].optionB;
    } else if (_selectedOption == 2) {
      return widget.questions[currentQuestion].optionC;
    } else {
      return widget.questions[currentQuestion].optionD;
    }
  }

  String _getCorrectAnswer(int index) {
    int correctOption = widget.questions[index].answer;
    if (correctOption == 1) {
      return widget.questions[index].optionA;
    } else if (correctOption == 2) {
      return widget.questions[index].optionB;
    } else if (correctOption == 3) {
      return widget.questions[index].optionC;
    } else {
      return widget.questions[index].optionD;
    }
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

// class _ChapterPracticeScreenState extends State<ChapterPracticeScreen> {
//   int currentQuestion = 0;
//   int totalQuestions = 0;
//   int _selectedOption = -1;
//   late Timer _timer;
//   Duration elapsedTime = Duration.zero;
//   final TestResultModel _testResults = TestResultModel(questions: []);

//   @override
//   void initState() {
//     super.initState();
//     totalQuestions = widget.questions.length;
//     startTimer();
//   }

//   @override
//   void dispose() {
//     _timer.cancel();
//     super.dispose();
//   }

//   void startTimer() {
//     _timer = Timer.periodic(Duration(seconds: 1), (timer) {
//       setState(() {
//         elapsedTime += Duration(seconds: 1);
//       });
//     });
//   }

//   String formatTime(Duration duration) {
//     String twoDigits(int n) => n.toString().padLeft(2, '0');
//     final minutes = twoDigits(duration.inMinutes.remainder(60));
//     final seconds = twoDigits(duration.inSeconds.remainder(60));
//     return "$minutes:$seconds";
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leadingWidth: context.responsiveSize(55),
//         leading: Align(
//           alignment: Alignment.centerRight,
//           child: GestureDetector(
//             onTap: () => Navigator.pop(context),
//             child: SvgPicture.asset(
//               AppAssets.backArrow,
//               color: AppColors.black,
//               height: context.responsiveSize(35),
//             ),
//           ),
//         ),
//       ),
//       body: Container(
//         alignment: Alignment.topCenter,
//         padding: EdgeInsets.fromLTRB(20, 0, 20, context.bottomPadding),
//         child: Column(
//           children: [
//             Container(
//               height: context.responsiveSize(10, min: 10),
//               width: context.screenWidth,
//               decoration: BoxDecoration(
//                 color: AppColors.accent.withOpacity(.2),
//                 borderRadius: BorderRadius.circular(999),
//               ),
//               alignment: Alignment.centerLeft,
//               child: Container(
//                 height: context.responsiveSize(10, min: 10),
//                 width:
//                     ((context.screenWidth - 40) / widget.questions.length) *
//                     (currentQuestion + 1),
//                 decoration: BoxDecoration(
//                   color: AppColors.accent,
//                   borderRadius: BorderRadius.circular(999),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 10),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   formatTime(elapsedTime),
//                   style: medium(context, fontSize: 14),
//                 ),
//                 Text(
//                   "${currentQuestion + 1} out of $totalQuestions",
//                   style: medium(
//                     context,
//                     fontSize: 12,
//                     color: AppColors.black.withOpacity(.7),
//                   ),
//                 ),
//               ],
//             ),

//             // question
//             const SizedBox(height: 20),
//             Expanded(
//               child: SingleChildScrollView(
//                 child: Column(
//                   children: [
//                     Text(
//                       widget.questions[currentQuestion].question,
//                       style: semiBold(context, fontSize: 16),
//                     ),
//                     const SizedBox(height: 20),
//                     // ListView.separated(
//                     //   shrinkWrap: true,
//                     //   physics: const NeverScrollableScrollPhysics(),
//                     //   itemBuilder: (context, index) {
//                     //     return GestureDetector(
//                     //       onTap:
//                     //           () => setState(() {
//                     //             _selectedOption = index;
//                     //           }),
//                     //       child: Container(
//                     //         padding: EdgeInsets.all(15),
//                     //         decoration: BoxDecoration(
//                     //           color: AppColors.white,
//                     //           borderRadius: BorderRadius.circular(10),
//                     //           boxShadow: [
//                     //             BoxShadow(
//                     //               color: AppColors.black.withOpacity(.06),
//                     //               offset: Offset(0, 3),
//                     //               blurRadius: 12,
//                     //             ),
//                     //           ],
//                     //           border: Border.all(
//                     //             color:
//                     //                 _selectedOption == index
//                     //                     ? AppColors.accent
//                     //                     : AppColors.transparent,
//                     //           ),
//                     //         ),
//                     //         alignment: Alignment.centerLeft,
//                     //         child: Text(
//                     //           widget.questions[currentQuestion].[index]
//                     //               .substring(1)
//                     //               .trim(),
//                     //           style: medium(context, fontSize: 14),
//                     //         ),
//                     //       ),
//                     //     );
//                     //   },
//                     //   separatorBuilder: (context, index) => const SizedBox(height: 15),
//                     //   itemCount: widget.questions[currentQuestion].options.length,
//                     // ),
//                     if (widget.questions[currentQuestion].optionA.isNotEmpty)
//                       _optionItem(
//                         text: widget.questions[currentQuestion].optionA,
//                         isSelected: _selectedOption == 0,
//                         onTap: () {
//                           _selectedOption = 0;
//                           setState(() {});
//                         },
//                       ),
//                     if (widget.questions[currentQuestion].optionB.isNotEmpty)
//                       _optionItem(
//                         text: widget.questions[currentQuestion].optionB,
//                         isSelected: _selectedOption == 1,
//                         onTap: () {
//                           _selectedOption = 1;
//                           setState(() {});
//                         },
//                       ),
//                     if (widget.questions[currentQuestion].optionC != "null")
//                       _optionItem(
//                         text: widget.questions[currentQuestion].optionC,
//                         isSelected: _selectedOption == 2,
//                         onTap: () {
//                           _selectedOption = 2;
//                           setState(() {});
//                         },
//                       ),
//                     if (widget.questions[currentQuestion].optionD != "null")
//                       _optionItem(
//                         text: widget.questions[currentQuestion].optionD,
//                         isSelected: _selectedOption == 3,
//                         onTap: () {
//                           _selectedOption = 3;
//                           setState(() {});
//                         },
//                       ),
//                   ],
//                 ),
//               ),
//             ),
//             GestureDetector(
//               onTap: () {
//                 onNextTap();
//               },
//               child: Container(
//                 decoration: BoxDecoration(
//                   color: AppColors.accent,
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 padding: EdgeInsets.symmetric(vertical: 12),
//                 margin: EdgeInsets.only(bottom: context.bottomPadding),
//                 alignment: Alignment.center,
//                 child: Text(
//                   context.local.next,
//                   style: medium(context, fontSize: 16, color: AppColors.white),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void onNextTap() {
//     getLikelyCorrectOptionIndex();

//     if (currentQuestion < widget.questions.length - 1) {
//       setState(() {
//         currentQuestion++;
//         _selectedOption = -1; // Optional: reset selection
//       });
//     } else {
//       // navigate to result screen or show completion dialog
//       print(" --- navigate to result screen");
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(
//           builder:
//               (context) => TestResultScreen(
//                 isFromPractice: true,
//                 testResultModel: _testResults,
//                 questions:
//                     widget.questions.map((lesson) {
//                       return MockTestDbModel(
//                         questionId: lesson.questionId.toString(),
//                         question: lesson.question,
//                         answer: lesson.answer.toString(),
//                         optionNo:
//                             '', // 👈 If you don't have this in LessonPracticeTestDbModel
//                         optionA: lesson.optionA,
//                         optionB: lesson.optionB,
//                         optionC: lesson.optionC,
//                         optionD: lesson.optionD,
//                         category: lesson.category,
//                       );
//                     }).toList(),
//               ),
//         ),
//       );
//     }
//   }

//   void getLikelyCorrectOptionIndex() {
//     int correctOption = widget.questions[currentQuestion].answer;

//     // // Special handling for True/False questions
//     // if (question.options.any(
//     //   (opt) =>
//     //       opt.toLowerCase().contains("true") ||
//     //       opt.toLowerCase().contains("false"),
//     // )) {
//     //   final hasFalseHints =
//     //       feedback.contains("not") || feedback.contains("false");
//     //   final hasTrueHints =
//     //       feedback.contains("true") ||
//     //       feedback.contains("has its own") ||
//     //       feedback.contains("is") ||
//     //       feedback.contains("does");

//     //   if (hasFalseHints) {
//     //     bestIndex = question.options.indexWhere(
//     //       (opt) => opt.toLowerCase().contains("false"),
//     //     );
//     //   } else if (hasTrueHints) {
//     //     bestIndex = question.options.indexWhere(
//     //       (opt) => opt.toLowerCase().contains("true"),
//     //     );
//     //   }
//     // } else {
//     //   // For multiple choice questions
//     //   for (int i = 0; i < question.options.length; i++) {
//     //     final optionText =
//     //         question.options[i]
//     //             .toLowerCase()
//     //             .replaceFirst(RegExp(r'^\d+\s+'), '')
//     //             .trim();

//     //     int matches = 0;

//     //     final optionWords = optionText.split(' ').where((w) => w.length > 2);

//     //     for (var word in optionWords) {
//     //       if (feedback.contains(word)) {
//     //         matches += 1;
//     //       }
//     //     }

//     //     if (matches > maxMatches) {
//     //       maxMatches = matches;
//     //       bestIndex = i;
//     //     }
//     //   }
//     // }

//     if (_selectedOption != -1) {
//       if ((_selectedOption + 1) == correctOption) {
//         print(" --- Correct answer selected");
//         _testResults.addCorrectAnswer(
//           question: widget.questions[currentQuestion].question,
//           selectedOption: _getSelectedOption(),
//         );
//       } else {
//         print(" --- Wrong answer selected");
//         _testResults.addWrongAnswer(
//           question: widget.questions[currentQuestion].question,
//           selectedOption: _getSelectedOption(),
//           correctAnswer: _getCorrectAnswer(currentQuestion),
//         );
//       }
//     } else {
//       print(" --- (no selection made)");
//       _testResults.addSkippedAnswer(
//         question: widget.questions[currentQuestion].question,
//         correctAnswer: _getCorrectAnswer(currentQuestion),
//       );
//     }
//   }

//   String _getSelectedOption() {
//     if (_selectedOption == 0) {
//       return widget.questions[currentQuestion].optionA;
//     } else if (_selectedOption == 1) {
//       return widget.questions[currentQuestion].optionB;
//     } else if (_selectedOption == 2) {
//       return widget.questions[currentQuestion].optionC;
//     } else {
//       return widget.questions[currentQuestion].optionD;
//     }
//   }

//   String _getCorrectAnswer(int index) {
//     int correctOption = widget.questions[index].answer;
//     if (correctOption == 0) {
//       return widget.questions[index].optionA;
//     } else if (correctOption == 1) {
//       return widget.questions[index].optionB;
//     } else if (correctOption == 2) {
//       return widget.questions[index].optionC;
//     } else {
//       return widget.questions[index].optionD;
//     }
//   }

//   _optionItem({
//     required String text,
//     required bool isSelected,
//     required VoidCallback onTap,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         width: double.infinity,
//         margin: const EdgeInsets.only(bottom: 15),
//         decoration: BoxDecoration(
//           color: AppColors.white,
//           borderRadius: BorderRadius.circular(10),
//           boxShadow: [
//             BoxShadow(
//               color: AppColors.black.withOpacity(.06),
//               offset: Offset(0, 3),
//               blurRadius: 12,
//             ),
//           ],
//           border: Border.all(
//             color: isSelected ? AppColors.accent : AppColors.transparent,
//           ),
//         ),
//         padding: EdgeInsets.all(15),
//         child: Text(text, style: medium(context, fontSize: 14)),
//       ),
//     );
//   }
// }
