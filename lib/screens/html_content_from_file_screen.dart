import 'package:canadian_citizenship/core/constants/app_assets.dart';
import 'package:canadian_citizenship/core/constants/app_colors.dart';
import 'package:canadian_citizenship/core/extensions/context_extensions.dart';
import 'package:canadian_citizenship/libs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/svg.dart';

class HtmlContentFromFileScreen extends StatefulWidget {
  final String filePath;
  const HtmlContentFromFileScreen({super.key, required this.filePath});

  @override
  State<HtmlContentFromFileScreen> createState() =>
      _HtmlContentFromFileScreenState();
}

class _HtmlContentFromFileScreenState extends State<HtmlContentFromFileScreen> {
  String htmlFilePath = "";
  String fileContent = "";
  bool isDataLoaded = false;

  @override
  void initState() {
    super.initState();
    htmlFilePath = widget.filePath;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      isDataLoaded = false;
      loadFileContent();
    });
  }

  Future<void> loadFileContent() async {
    isDataLoaded = false;
    setState(() {});
    fileContent = await rootBundle.loadString(htmlFilePath);
    isDataLoaded = true;
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
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(16, 0, 16, context.bottomPadding),
        child:
            isDataLoaded
                ? SingleChildScrollView(
                  child: Html(
                    data: fileContent,
                    style: {
                      // Apply a larger font size to all elements
                      "body": Style(
                        fontSize: FontSize(18.0), // Increase base font size
                      ),
                      // You can also adjust specific elements if needed
                      "h1": Style(fontSize: FontSize(28.0)),
                      "h2": Style(fontSize: FontSize(24.0)),
                      "p": Style(
                        fontSize: FontSize(18.0),
                        lineHeight: LineHeight(1.5),
                      ),
                      "li": Style(fontSize: FontSize(18.0)),
                    },
                  ),
                )
                : Center(
                  child: CircularProgressIndicator(
                    color: AppColors.accent,
                    strokeCap: StrokeCap.round,
                    backgroundColor: AppColors.transparent,
                  ),
                ),
      ),
    );
  }
}
