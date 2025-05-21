// import 'package:canadian_citizenship/libs.dart';
// import 'package:canadian_citizenship/screens/lessons_screen/lesions_details_screen.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final provider = Provider.of<HomeScreenProvider>(context, listen: false);
//       provider.loadAllData();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AnnotatedRegion<SystemUiOverlayStyle>(
//       value: SystemUiOverlayStyle.dark,
//       child: Scaffold(
//         body: Container(
//           padding: EdgeInsets.fromLTRB(
//             20,
//             context.topPadding + 20,
//             20,
//             context.bottomPadding,
//           ),
//           child: Column(
//             children: [
//               HomeScreenAppBar(),
//               const SizedBox(height: 20),
//               ContinueStudyingCard(
//                 onTap: () async {
//                   int lastLesionCategory = PrefService.getLastLesionCategory();
//                   int? lastLesionIndex = PrefService.getLastLesion();
//                   HomeScreenProvider provider = Provider.of<HomeScreenProvider>(
//                     context,
//                     listen: false,
//                   );
//                   LessonMain lesson = provider.allMainData[lastLesionCategory];
//                   List<Lesson> lessons = provider
//                       .getCurrentCategoriesLessons(lastLesionIndex == null ? "1" : (lastLesionIndex+1).toString());
//                   if (lastLesionIndex != null) {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder:
//                             (context) => LesionsDetailsScreen(
//                               data: lessons,
//                               index: lastLesionIndex,
//                               categoryIndex: lastLesionCategory,
//                             ),
//                       ),
//                     );
//                   } else {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder:
//                             (context) => LessonsScreen(
//                               title: lesson.title,
//                               allLessonsData: lessons,
//                               categoryIndex: lastLesionCategory,
//                               // question: lesson.questions,
//                             ),
//                       ),
//                     );
//                   }
//                 },
//               ),
//               const SizedBox(height: 20),
//               Expanded(
//                 child: Consumer<HomeScreenProvider>(
//                   builder: (context, provider, _) {
//                     return provider.dataLoaded
//                         ? provider.allMainData.isEmpty
//                             ? Center(
//                               child: Text(
//                                 "No lessons available",
//                                 style: semiBold(context, fontSize: 16),
//                               ),
//                             )
//                             : MasonryGridView.count(
//                               itemCount: provider.allMainData.length,
//                               padding: EdgeInsets.zero,
//                               crossAxisCount: 2,
//                               mainAxisSpacing: 15,
//                               crossAxisSpacing: 15,
//                               itemBuilder: (context, index) {
//                                 LessonMain lesson = provider.allMainData[index];
//                                 return GestureDetector(
//                                   onTap: () async {
//                                     HomeScreenProvider provider =
//                                         Provider.of<HomeScreenProvider>(
//                                           context,
//                                           listen: false,
//                                         );
//                                     List<Lesson> lessons = await provider
//                                         .getCurrentCategoriesLessons(
//                                           "${index+1}"
//                                         );
//                                     PrefService.saveLastLesionCategory(index);
//                                     Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                         builder:
//                                             (context) => LessonsScreen(
//                                               title: lesson.title,
//                                               allLessonsData: lessons,
//                                               categoryIndex: (index),
//                                               // question: lesson.questions,
//                                             ),
//                                       ),
//                                     );
//                                   },
//                                   child: Container(
//                                     height: context.responsiveSize(200),
//                                     decoration: BoxDecoration(
//                                       color: AppColors.white,
//                                       borderRadius: BorderRadius.circular(10),
//                                       border: Border.all(
//                                         color: const Color(0xffD87B80),
//                                       ),
//                                     ),
//                                     padding: EdgeInsets.symmetric(
//                                       vertical: 10,
//                                       horizontal: 15,
//                                     ),
//                                     alignment: Alignment.center,
//                                     child: Column(
//                                       mainAxisSize: MainAxisSize.min,
//                                       children: [
//                                         Flexible(
//                                           child: Image.asset(
//                                             "assets/images/${lesson.title}.png",
//                                             errorBuilder:
//                                                 (
//                                                   context,
//                                                   error,
//                                                   stackTrace,
//                                                 ) => Container(
//                                                   decoration: BoxDecoration(
//                                                     color: AppColors.black
//                                                         .withOpacity(.1),

//                                                     borderRadius:
//                                                         BorderRadius.circular(
//                                                           10,
//                                                         ),
//                                                   ),
//                                                 ),
//                                           ),
//                                         ),
//                                         const SizedBox(height: 10),
//                                         Text(
//                                           lesson.title,
//                                           textAlign: TextAlign.center,
//                                           style: semiBold(
//                                             context,
//                                             fontSize: 14,
//                                           ),
//                                         ),
//                                         Consumer<HomeScreenProvider>(
//                                           builder: (context, provider, _) {
//                                             return Text(
//                                               "0/${provider.getCurrentCategoriesLessons((index+1).toString()).length} Completed",
//                                               textAlign: TextAlign.center,
//                                               style: regular(
//                                                 context,
//                                                 fontSize: 12,
//                                                 color: AppColors.black.withOpacity(
//                                                   .6,
//                                                 ),
//                                               ),
//                                             );
//                                           }
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 );
//                               },
//                             )
//                         : Center(
//                           child: CircularProgressIndicator(
//                             color: AppColors.accent,
//                           ),
//                         );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// home_screen.dart
import 'package:canadian_citizenship/libs.dart';
import 'package:canadian_citizenship/main.dart';
import 'package:canadian_citizenship/core/widgets/premium_strip.dart';
import 'package:canadian_citizenship/screens/lessons_screen/lesions_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<HomeScreenProvider>(context, listen: false);
      provider.loadAllData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        body: Container(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(
                  20,
                  context.topPadding + 20,
                  20,
                  0,
                ),
                child: HomeScreenAppBar(),
              ),
              const SizedBox(height: 20),
              PremiumStrip(),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    20,
                    0,
                    20,
                    context.bottomPadding,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 20),
                      ContinueStudyingCard(
                        onTap: () async {
                          int lastLesionCategory =
                              PrefService.getLastLesionCategory();
                          int? lastLesionIndex = PrefService.getLastLesion();
                          HomeScreenProvider provider =
                              Provider.of<HomeScreenProvider>(
                                context,
                                listen: false,
                              );
                          LessonMain lesson =
                              provider.allMainData[lastLesionCategory];
                          List<Lesson> lessons = provider
                              .getCurrentCategoriesLessons(
                                lastLesionIndex == null
                                    ? "1"
                                    : (lastLesionIndex + 1).toString(),
                              );
                          if (lastLesionIndex != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => LesionsDetailsScreen(
                                      data: lessons,
                                      index: lastLesionIndex,
                                      categoryIndex: lastLesionCategory,
                                    ),
                              ),
                            );
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => LessonsScreen(
                                      title: lesson.title,
                                      allLessonsData: lessons,
                                      categoryIndex: lastLesionCategory,
                                    ),
                              ),
                            );
                          }
                        },
                      ),
                      const SizedBox(height: 20),
                      Expanded(
                        child: Consumer<HomeScreenProvider>(
                          builder: (context, provider, _) {
                            return provider.dataLoaded
                                ? provider.allMainData.isEmpty
                                    ? Center(
                                      child: Text(
                                        context.local.no_lesson_available,
                                        style: semiBold(context, fontSize: 16),
                                      ),
                                    )
                                    : MasonryGridView.count(
                                      itemCount: provider.allMainData.length,
                                      padding: EdgeInsets.zero,
                                      crossAxisCount: 2,
                                      mainAxisSpacing: 15,
                                      crossAxisSpacing: 15,
                                      itemBuilder: (context, index) {
                                        LessonMain lesson =
                                            provider.allMainData[index];
                                            
                                        List<Lesson> lessons = provider
                                            .getCurrentCategoriesLessons(
                                              "${index + 1}",
                                            );
                                        int completedCount = provider
                                            .getCategoryProgress(
                                              index,
                                              lessons,
                                            );

                                        return GestureDetector(
                                          onTap: () async {
                                            PrefService.saveLastLesionCategory(
                                              index,
                                            );
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder:
                                                    (context) => LessonsScreen(
                                                      title: lesson.title,
                                                      allLessonsData: lessons,
                                                      categoryIndex: index,
                                                    ),
                                              ),
                                            );
                                          },
                                          child: Container(
                                            height: context.responsiveSize(200),
                                            decoration: BoxDecoration(
                                              color: AppColors.white,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                color: const Color(0xffD87B80),
                                              ),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 10,
                                              horizontal: 15,
                                            ),
                                            alignment: Alignment.center,
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Flexible(
                                                  child: Image.asset(
                                                    "assets/images/${lesson.title}.png",
                                                    errorBuilder:
                                                        (
                                                          context,
                                                          error,
                                                          stackTrace,
                                                        ) => Container(
                                                          decoration: BoxDecoration(
                                                            color: AppColors
                                                                .black
                                                                .withOpacity(
                                                                  .1,
                                                                ),
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  10,
                                                                ),
                                                          ),
                                                        ),
                                                  ),
                                                ),
                                                const SizedBox(height: 10),
                                                Text(
                                                  lesson.title,
                                                  textAlign: TextAlign.center,
                                                  style: semiBold(
                                                    context,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  "$completedCount/${lessons.length} ${context.local.completed}",
                                                  textAlign: TextAlign.center,
                                                  style: regular(
                                                    context,
                                                    fontSize: 12,
                                                    color: AppColors.black
                                                        .withOpacity(.6),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    )
                                : Center(
                                  child: CircularProgressIndicator(
                                    color: AppColors.accent,
                                  ),
                                );
                          },
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
}
