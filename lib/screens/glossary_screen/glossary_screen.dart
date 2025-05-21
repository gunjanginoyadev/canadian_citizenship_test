import 'package:canadian_citizenship/core/widgets/premium_strip.dart';
import 'package:canadian_citizenship/libs.dart';
import 'package:canadian_citizenship/main.dart';

class GlossaryScreen extends StatefulWidget {
  const GlossaryScreen({super.key});

  @override
  State<GlossaryScreen> createState() => _GlossaryScreenState();
}

class _GlossaryScreenState extends State<GlossaryScreen> {
  TextEditingController searchController = TextEditingController();
  FocusNode searchFN = FocusNode();

  late TTSHelper tts;

  @override
  void initState() {
    super.initState();
    tts = TTSHelper();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<GlossaryProvider>(context, listen: false).loadGlossaryData();
    });
  }

  void handleSpeak(String text) async {
    if (tts.isSpeaking) {
      await tts.stop();
    } else {
      await tts.speak(text);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        searchFN.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "Glossary",
            style: semiBold(context, fontSize: 16, color: AppColors.accent),
          ),
        ),
        body: Column(
          children: [
            PremiumStrip(),
            const SizedBox(height: 10),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    SearchBox(
                      controller: searchController,
                      focusNode: searchFN,
                      onChange: (value) {
                        Provider.of<GlossaryProvider>(
                          context,
                          listen: false,
                        ).searchGlossary(value);
                      },
                    ),
                    const SizedBox(height: 15),
                    Expanded(
                      child: Consumer<GlossaryProvider>(
                        builder: (context, provider, _) {
                          return provider.isDataLoaded
                              ? provider.data.isEmpty
                                  ? Center(
                                    child: Text(
                                      context.local.no_data_found,
                                      style: regular(context, fontSize: 16),
                                    ),
                                  )
                                  : ListView.separated(
                                    padding: EdgeInsets.only(bottom: 20),
                                    itemBuilder: (context, index) {
                                      final item = provider.data[index];
                                      return Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          color: AppColors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color: AppColors.black
                                                  .withOpacity(0.06),
                                              offset: Offset(0, 3),
                                              blurRadius: 20,
                                            ),
                                          ],
                                        ),
                                        padding: EdgeInsets.all(12),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Flexible(
                                                  child: Text(
                                                    item.word,
                                                    style: semiBold(
                                                      context,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
                                                GestureDetector(
                                                  onTap: () {
                                                    handleSpeak(
                                                      item.definition,
                                                    );
                                                  },
                                                  child: SvgPicture.asset(
                                                    AppAssets.speak,
                                                    height: context
                                                        .responsiveSize(30),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              item.definition.trim(),
                                              style: regular(
                                                context,
                                                fontSize: 12,
                                                color: AppColors.black
                                                    .withOpacity(.7),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    separatorBuilder:
                                        (context, index) =>
                                            const SizedBox(height: 15),
                                    itemCount: provider.data.length,
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
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    searchFN.dispose();
    tts.dispose();
    super.dispose();
  }
}
