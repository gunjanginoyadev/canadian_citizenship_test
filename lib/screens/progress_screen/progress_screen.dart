import 'package:canadian_citizenship/core/widgets/premium_strip.dart';
import 'package:canadian_citizenship/libs.dart';
import 'package:canadian_citizenship/main.dart';
import 'package:canadian_citizenship/provider/test_score_history_provider.dart';

class ProgressScreen extends StatefulWidget {
  final VoidCallback onTap;
  const ProgressScreen({super.key, required this.onTap});

  @override
  State<ProgressScreen> createState() => ProgressScreenState();
}

class ProgressScreenState extends State<ProgressScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<TestScoreHistoryProvider>(context, listen: false).loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.local.progress,
          style: medium(context, fontSize: 22),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            PremiumStrip(),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Consumer<HomeScreenProvider>(
                        builder: (context, provider, _) {
                          return CircularPercentIndicator(
                            lineWidth: 8,
                            percent:
                                (provider.currentProgress /
                                    (provider.allLessonsData.length)),
                            radius: context.responsiveSize(50),
                            circularStrokeCap: CircularStrokeCap.round,
                            progressColor: AppColors.accent,
                            center: Text(
                              "${((provider.currentProgress / (provider.allLessonsData.length)) * 100).floor()}%",
                              style: medium(context, fontSize: 16),
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
        
                        children: [
                          Text(
                            "${context.local.lesson} ${context.local.progress}",
                            style: medium(context, fontSize: 18),
                          ),
                          Consumer<HomeScreenProvider>(
                            builder: (context, provider, _) {
                              return Text(
                                "${((provider.currentProgress / (provider.allLessonsData.length)) * 100).floor()}% ${context.local.progress}",
                                style: medium(
                                  context,
                                  fontSize: 16,
                                  color: AppColors.black.withOpacity(.5),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            context.local.test_progress,
                            style: semiBold(
                              context,
                              fontSize: 18,
                              color: AppColors.black,
                            ),
                          ),
                          Consumer<MockTestProvider>(
                            builder: (context, provider, _) {
                              return Text(
                                "${provider.currentProgress == 0 ? 0 : ((provider.currentProgress / provider.totalQuestions) * 100).floor()}% ${context.local.progress}",
                                style: medium(
                                  context,
                                  fontSize: 16,
                                  color: AppColors.black.withOpacity(.5),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(width: 15),
        
                      Consumer<MockTestProvider>(
                        builder: (context, provider, _) {
                          return CircularPercentIndicator(
                            radius: context.responsiveSize(50),
                            lineWidth: 8,
                            progressColor: AppColors.accent,
                            circularStrokeCap: CircularStrokeCap.round,
                            percent:
                                provider.totalQuestions == 0
                                    ? 0
                                    : (provider.currentProgress /
                                        provider.totalQuestions),
                            center: Text(
                              "${provider.currentProgress == 0 ? 0 : ((provider.currentProgress / provider.totalQuestions) * 100).floor()}%",
                              style: medium(
                                context,
                                fontSize: 18,
                                color: AppColors.black,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
        
                  const SizedBox(height: 20),
                  ScoreStatisticsWidget(),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: Container(
                      width: context.screenWidth,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.black.withOpacity(.06),
                            offset: Offset(0, 3),
                            blurRadius: 18,
                          ),
                        ],
                      ),
                      padding: EdgeInsets.all(12),
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                            
                        children: [
                          Text(
                            context.local.improve_your_score,
                            style: medium(context, fontSize: 18),
                          ),
                          const SizedBox(height: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _infoItem(
                                AppAssets.tick,
                                context.local.continue_taking_prectice_test,
                              ),
                              const SizedBox(height: 8),
                              _infoItem(
                                AppAssets.tick,
                                context.local.continue_readding_official_handbook,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _infoItem(String icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SvgPicture.asset(
          icon,
          height: context.responsiveSize(25),
          color: AppColors.accent,
        ),
        const SizedBox(width: 12),
        Flexible(
          child: Text(
            text,
            style: regular(context, fontSize: 16, color: AppColors.accent),
          ),
        ),
      ],
    );
  }
}

class ScoreStatisticsWidget extends StatelessWidget {
  const ScoreStatisticsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<TestScoreHistoryProvider>(
      builder: (context, scoreProvider, _) {
        if (!scoreProvider.dataLoaded) {
          return const Center(child: CircularProgressIndicator());
        }

        return Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withOpacity(.06),
                offset: Offset(0, 3),
                blurRadius: 18,
              ),
            ],
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.local.score_statistics,
                style: medium(context, fontSize: 18),
              ),
              const SizedBox(height: 16),
              _buildScoreRow(
                context,
                context.local.last_test,
                scoreProvider.scoreHistory,
                1,
              ),
              const SizedBox(height: 12),
              _buildScoreRow(
                context,
                "${context.local.last} 5 ${context.local.tests}",
                scoreProvider.scoreHistory,
                5,
              ),
              const SizedBox(height: 12),
              _buildScoreRow(
                context,
                "${context.local.last} 10 ${context.local.tests}",
                scoreProvider.scoreHistory,
                10,
              ),
              const SizedBox(height: 12),
              _buildScoreRow(
                context,
                "${context.local.last} 20 ${context.local.tests}",
                scoreProvider.scoreHistory,
                20,
              ),
              const SizedBox(height: 12),
              _buildScoreRow(
                context,
                context.local.all_test,
                scoreProvider.scoreHistory,
                scoreProvider.scoreHistory.length,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildScoreRow(
    BuildContext context,
    String label,
    List<int> scores,
    int count,
  ) {
    // Calculate the average score for the specified count
    double averageScore = 0;
    String displayText = "-";

    if (scores.isNotEmpty && scores.length >= count) {
      int sum = 0;
      for (int i = 0; i < count; i++) {
        sum += scores[i];
      }
      averageScore = sum / count;
      displayText = "${averageScore.toStringAsFixed(1)}%";
    }

    return Row(
      children: [
        SizedBox(
          width: 100,
          child: Text(label, style: medium(context, fontSize: 16)),
        ),
        Expanded(
          child: LinearProgressIndicator(
            value:
                scores.isNotEmpty && scores.length >= count
                    ? averageScore / 100
                    : 0,
            backgroundColor: Colors.grey[200],
            color: _getColorForScore(averageScore),
            minHeight: 10,
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        const SizedBox(width: 16),
        Text(
          displayText,
          style: medium(context, fontSize: 16),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Color _getColorForScore(double score) {
    if (score >= 80) {
      return Colors.green;
    } else if (score >= 60) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }
}
