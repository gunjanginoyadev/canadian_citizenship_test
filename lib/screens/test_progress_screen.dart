// import 'package:canadian_citizenship/core/widgets/premium_strip.dart';
// import 'package:canadian_citizenship/libs.dart';
// import 'package:canadian_citizenship/provider/test_progress_provider.dart';
// import 'package:circle_progress_bar/circle_progress_bar.dart';

// class TestProgressScreen extends StatefulWidget {
//   const TestProgressScreen({super.key});

//   @override
//   State<TestProgressScreen> createState() => _TestProgressScreenState();
// }

// class _TestProgressScreenState extends State<TestProgressScreen> {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       Provider.of<TestProgressProvider>(context, listen: false).init(context);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         titleSpacing: 20,
//         title: Text(
//           "Progress",
//           style: semiBold(context, color: AppColors.accent, fontSize: 18),
//         ),
//       ),
//       body: Column(
//         children: [
//           PremiumStrip(),
//           Expanded(
//             child: Padding(
//               padding: EdgeInsets.fromLTRB(20, 15, 20, 20),
//               child: Column(
//                 children: [
//                   Container(
//                     child: Row(
//                       children: [
//                         Consumer<HomeScreenProvider>(
//                           builder: (context, provider, _) {
//                             return SizedBox(
//                               width: context.responsiveSize(100),
//                               child: CircleProgressBar(
//                                 foregroundColor: AppColors.accent,
//                                 backgroundColor: Colors.black12,
//                                 value:
//                                     (provider.currentProgress /
//                                         (provider.allLessonsData.length)),
//                                 child: Center(
//                                   child: AnimatedCount(
//                                     count:
//                                         (provider.currentProgress /
//                                             (provider.allLessonsData.length)) *
//                                         100,
//                                     unit: '%',
//                                     duration: Duration(milliseconds: 500),
//                                   ),
//                                 ),
//                               ),
//                             );
//                           },
//                         ),
//                         const SizedBox(width: 15),
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               "Reading Progress",
//                               style: semiBold(
//                                 context,
//                                 fontSize: 18,
//                                 color: AppColors.black,
//                               ),
//                             ),
//                             Consumer<HomeScreenProvider>(
//                               builder: (context, provider, _) {
//                                 return provider.dataLoaded
//                                     ? Text(
//                                       "${((provider.currentProgress / (provider.allLessonsData.length)) * 100).floor()}% Progress",
//                                       style: medium(
//                                         context,
//                                         fontSize: 16,
//                                         color: AppColors.black.withOpacity(.5),
//                                       ),
//                                     )
//                                     : const SizedBox();
//                               },
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   Container(
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       children: [
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               "Test Progress",
//                               style: semiBold(
//                                 context,
//                                 fontSize: 18,
//                                 color: AppColors.black,
//                               ),
//                             ),
//                             Consumer<TestProgressProvider>(
//                               builder: (context, provider, _) {
//                                 return Text(
//                                   "${provider.totalProgress == 0 ? 0 : ((provider.currentTestProgress / provider.totalProgress) * 100).floor()}% Progress",
//                                   style: medium(
//                                     context,
//                                     fontSize: 16,
//                                     color: AppColors.black.withOpacity(.5),
//                                   ),
//                                 );
//                               },
//                             ),
//                           ],
//                         ),
//                         const SizedBox(width: 15),
//                         Consumer<TestProgressProvider>(
//                           builder: (context, provider, _) {
//                             return SizedBox(
//                               width: context.responsiveSize(100),
//                               child: CircleProgressBar(
//                                 foregroundColor: AppColors.accent,
//                                 backgroundColor: Colors.black12,
//                                 value:
//                                     provider.totalProgress == 0
//                                         ? 0
//                                         : (provider.currentTestProgress /
//                                             provider.totalProgress),
//                                 child: Center(
//                                   child: AnimatedCount(
//                                     count:
//                                         provider.totalProgress == 0
//                                             ? 0
//                                             : (provider.currentTestProgress /
//                                                 provider.totalProgress),
//                                     unit: '%',
//                                     duration: Duration(milliseconds: 500),
//                                   ),
//                                 ),
//                               ),
//                             );
//                           },
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
