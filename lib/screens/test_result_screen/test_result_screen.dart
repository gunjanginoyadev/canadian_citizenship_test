import 'package:canadian_citizenship/libs.dart';
import 'package:canadian_citizenship/main.dart';
import 'package:canadian_citizenship/model/test_result_model.dart';
import 'package:canadian_citizenship/provider/test_score_history_provider.dart';
import 'package:canadian_citizenship/screens/mock_test_screen/test_screen.dart';
import 'package:canadian_citizenship/services/db_service.dart';

class TestResultScreen extends StatefulWidget {
  final TestResultModel testResultModel;
  final List<MockTestDbModel> questions;
  final bool isFromPractice;
  const TestResultScreen({
    super.key,
    required this.testResultModel,
    required this.questions,
    this.isFromPractice = false,
  });

  @override
  State<TestResultScreen> createState() => _TestResultScreenState();
}

class _TestResultScreenState extends State<TestResultScreen> {
  double totalScore = 0;
  int correctAnswers = 0;
  int wrongAnswers = 0;
  int skippedAnswers = 0;
  int totalQuestions = 0;
  int selectedReviewIndex = 0;

  @override
  void initState() {
    super.initState();
    correctAnswers =
        widget.testResultModel.questions
            .where((element) => element.type == TestResultQuestionType.correct)
            .length;
    wrongAnswers =
        widget.testResultModel.questions
            .where((element) => element.type == TestResultQuestionType.wrong)
            .length;

    skippedAnswers =
        widget.testResultModel.questions
            .where((element) => element.type == TestResultQuestionType.skipped)
            .length;

    totalQuestions = widget.testResultModel.questions.length;
    totalScore = correctAnswers / totalQuestions;

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<TestScoreHistoryProvider>(
        context,
        listen: false,
      ).addScore((totalScore * 100).floor());
    });
  }

  void selectReviewIndex(int index) {
    selectedReviewIndex = index;
    setState(() {});
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
        centerTitle: true,
        title: Text(
          context.local.test_results,
          style: semiBold(context, fontSize: 18, color: AppColors.accent),
        ),
      ),
      body: Container(
        alignment: Alignment.topCenter,
        padding: EdgeInsets.fromLTRB(20, 15, 20, 0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: CircularPercentIndicator(
                  radius: 65,
                  center: Text(
                    "${(totalScore * 100).floor()}%",
                    style: semiBold(context),
                  ),
                  circularStrokeCap: CircularStrokeCap.round,
                  percent: totalScore,
                  animation: true,
                  lineWidth: 12,
                  progressColor: AppColors.accent,
                  backgroundColor: AppColors.black.withOpacity(.1),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.black.withOpacity(.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                correctAnswers.toString(),
                                style: semiBold(
                                  context,
                                  fontSize: 24,
                                  color: const Color(0xff227504),
                                ),
                              ),
                              Text(
                                context.local.correct,
                                style: medium(context, fontSize: 16),
                              ),
                            ],
                          ),
                          Container(
                            width: 1,
                            height: context.responsiveSize(60),
                            decoration: BoxDecoration(
                              color: AppColors.accent.withOpacity(.1),
                              borderRadius: BorderRadius.circular(99),
                            ),
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                wrongAnswers.toString(),
                                style: semiBold(
                                  context,
                                  fontSize: 24,
                                  color: const Color(0xffC21F20),
                                ),
                              ),
                              Text(
                                context.local.wrong,
                                style: medium(context, fontSize: 16),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (!widget.isFromPractice) const SizedBox(height: 20),
                    if (!widget.isFromPractice)
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) =>
                                      TestScreen(questions: widget.questions),
                            ),
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: AppColors.accent,
                                borderRadius: BorderRadius.circular(99),
                              ),
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(
                                vertical: context.responsiveSize(12),
                                horizontal: context.responsiveSize(50),
                              ),
                              child: Text(
                                context.local.try_again_acpt,
                                style: semiBold(
                                  context,
                                  fontSize: 16,
                                  color: AppColors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              Text(
                context.local.review_your_answers,
                style: semiBold(context, fontSize: 16),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => selectReviewIndex(0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            context.local.all,
                            style: regular(context, fontSize: 14),
                          ),
                          Text(
                            "$totalQuestions",
                            style: semiBold(context, fontSize: 24),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => selectReviewIndex(1),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            context.local.correct,
                            style: regular(context, fontSize: 14),
                          ),
                          Text(
                            "$correctAnswers",
                            style: semiBold(context, fontSize: 24),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => selectReviewIndex(2),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            context.local.wrong,
                            style: regular(context, fontSize: 14),
                          ),
                          Text(
                            "$wrongAnswers",
                            style: semiBold(context, fontSize: 24),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => selectReviewIndex(3),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            context.local.skipped,
                            style: regular(context, fontSize: 14),
                          ),
                          Text(
                            "$skippedAnswers",
                            style: semiBold(context, fontSize: 24),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder:
                    (context, index) => _reviewQuestionCard(
                      question:
                          widget.testResultModel.questions[index].question,
                      wrongAnswers:
                          widget.testResultModel.questions[index].wrongOption,
                      correctAnswers:
                          widget.testResultModel.questions[index].correctAnswer,
                      questionType:
                          widget.testResultModel.questions[index].type,
                    ),
                separatorBuilder:
                    (context, index) => const SizedBox(height: 15),
                itemCount: widget.testResultModel.questions.length,
              ),
            ],
          ),
        ),
      ),
    );
  }

  _reviewQuestionCard({
    required String question,
    required String wrongAnswers,
    required String correctAnswers,
    required TestResultQuestionType questionType,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Text(question, style: semiBold(context, fontSize: 14)),
          const SizedBox(height: 10),
          Column(
            children: [
              if (questionType == TestResultQuestionType.skipped)
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFF2A70AA)),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.all(15),
                  child: Text(
                    "$correctAnswers",
                    style: semiBold(context, fontSize: 14),
                  ),
                ),
              if (questionType == TestResultQuestionType.correct)
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.correct),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.all(15),
                  child: Text(
                    "$correctAnswers",
                    style: semiBold(context, fontSize: 14),
                  ),
                ),
              if (questionType == TestResultQuestionType.wrong)
                Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.accent),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.all(15),
                      child: Text(
                        "$correctAnswers",
                        style: semiBold(context, fontSize: 14),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.correct),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.all(15),
                      child: Text(
                        "$wrongAnswers",
                        style: semiBold(context, fontSize: 14),
                      ),
                    ),
                  ],
                ),
            ],
          ),
          // const SizedBox(height: 10),
          // Text(
          //   feedback,
          //   style: regular(
          //     context,
          //     fontSize: 14,
          //     color: AppColors.black.withOpacity(.5),
          //   ),
          // ),
        ],
      ),
    );
  }
}
