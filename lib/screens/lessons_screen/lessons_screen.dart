import 'package:canadian_citizenship/libs.dart';
import 'package:canadian_citizenship/main.dart';
import 'package:canadian_citizenship/screens/chapter_prectice_screen/chapter_practice_screen.dart';
import 'package:canadian_citizenship/screens/lessons_screen/lesions_details_screen.dart';
import 'package:canadian_citizenship/services/db_service.dart';

class LessonsScreen extends StatefulWidget {
  final String title;
  final List<Lesson> allLessonsData;
  // final List<Question> question;
  final int categoryIndex;
  const LessonsScreen({
    super.key,
    required this.title,
    required this.allLessonsData,
    required this.categoryIndex,
    // required this.question,
  });

  @override
  State<LessonsScreen> createState() => _LessonsScreenState();
}

class _LessonsScreenState extends State<LessonsScreen> {
  @override
  void initState() {
    super.initState();
    print(" --- title: ${widget.title}");
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
          context.local.lesson_list,
          style: bold(context, color: AppColors.secondary),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(20, 0, 20, context.bottomPadding),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                    image: AssetImage(AppAssets.lesionTitleCardBg),
                    fit: BoxFit.cover,
                  ),
                ),
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(vertical: 30, horizontal: 16),
                child: Text(
                  widget.title,
                  style: semiBold(
                    context,
                    fontSize: 16,
                    color: AppColors.white,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.allLessonsData.length,
                separatorBuilder:
                    (context, index) => const SizedBox(height: 15),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      PrefService.saveLastLesion(index);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => LesionsDetailsScreen(
                                data: widget.allLessonsData,
                                index: index,
                                categoryIndex: widget.categoryIndex,
                              ),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.secondary),
                      ),
                      padding: EdgeInsets.all(15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${context.local.lesson} ${index + 1}",
                                  style: regular(
                                    context,
                                    fontSize: 14,
                                    color: const Color(0xff666666),
                                  ),
                                ),
                                Text(
                                  widget.allLessonsData[index].title,
                                  style: semiBold(context, fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                          SvgPicture.asset(
                            AppAssets.arrowRight,
                            height: context.responsiveSize(20),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () async {
                  List<LessonPracticeTestDbModel> questions = await DBService()
                      .getSpecificLessonTestQuestions(getLessonTypeFromTitle(widget.title));

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) =>
                              ChapterPracticeScreen(questions: questions),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.secondary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.all(15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          context.local.start_chapter_practice,
                          style: medium(
                            context,
                            fontSize: 16,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                      Container(
                        height: context.responsiveSize(30),
                        width: context.responsiveSize(30),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: AppColors.white.withOpacity(.5),
                        ),
                        padding: EdgeInsets.all(5),
                        child: SvgPicture.asset(
                          AppAssets.arrowRight,
                          height: context.responsiveSize(20),
                          color: AppColors.white,
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

  String getLessonTypeFromTitle(String title) {
    if (title == "The Citizenship Test") {
      return "L1";
    } else if (title == "Rights and Responsibilities") {
      return "L2";
    } else if (title == "Who We Are") {
      return "L3";
    } else if (title == "Canada's History I") {
      return "L4";
    } else if (title == "Canada's History II") {
      return "L5";
    } else if (title == "Canada's History III") {
      return "L6";
    } else if (title == "Modern Canada") {
      return "L7";
    } else if (title == "Government") {
      return "L8";
    } else if (title == "Elections") {
      return "L9";
    } else if (title == "The Justice System") {
      return "L10";
    } else if (title == "Canadian Symbols") {
      return "L11";
    } else if (title == "Canada's Economy") {
      return "L12";
    } else if (title == "Canada's Regions I") {
      return "L13";
    } else {
      return "L14";
    }
  }
}
