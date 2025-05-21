import 'dart:async';
import 'package:canadian_citizenship/main.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:html/parser.dart' as html_parser;
import '../../libs.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LesionsDetailsScreen extends StatefulWidget {
  final List<Lesson> data;
  final int index;
  final int categoryIndex;

  const LesionsDetailsScreen({
    super.key,
    required this.data,
    required this.index,
    required this.categoryIndex,
  });

  @override
  State<LesionsDetailsScreen> createState() => _LesionsDetailsScreenState();
}

class _LesionsDetailsScreenState extends State<LesionsDetailsScreen>
    with WidgetsBindingObserver {
  String htmlData = "";
  int currentIndex = 0;
  bool isSpeaking = false;
  bool isPause = false;
  bool isDarkMode = false;
  double fontSize = 18.0; // Default font size
  WebViewController? webViewController;

  // Scroll progress tracking
  double scrollProgress = 0.0;

  // TTS variables
  double currentPosition = 0;
  double totalDuration = 100;
  String highlightedHtml = "";
  List<String> wordList = [];
  int currentWordIndex = -1;
  int lastMatchedWordIndex = -1;
  double speechRate = .5;

  // Keys for shared preferences
  static const String fontSizeKey = 'lesson_font_size';

  Timer? _scrollCheckTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    TtsService.instance.init(initialRate: speechRate);
    currentIndex = widget.index;
    _loadSavedFontSize();
    loadHtmlText();

    // Set up a periodic timer to check scroll position as a fallback
    _scrollCheckTimer = Timer.periodic(const Duration(milliseconds: 500), (
      timer,
    ) {
      if (mounted) {
        _checkScrollPosition();
      }
    });
  }
  Future<void> sendEmail() async {
    final Email email = Email(
      body: 'Describe your issue here...',
      subject: 'Issue Report',
      recipients: ['contact@canadianjobbank.org'],
      isHTML: false,
    );

    try {
      await FlutterEmailSender.send(email);
    } catch (error) {
      debugPrint('Error sending email: $error');
    }
  }
  void _showMenu() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: isDarkMode ? AppColors.black : AppColors.white,
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
                    Text(
                      "${context.local.lesson} ${context.local.progress}",
                      style: medium(
                        context,
                        fontSize: 14,
                        color: isDarkMode ? AppColors.white : AppColors.black,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      "${getLessonProgressPercentage()}%",
                      style: medium(
                        context,
                        fontSize: 14,
                        color: isDarkMode ? AppColors.white : AppColors.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                LinearProgressIndicator(
                  value: (currentIndex + 1) / widget.data.length,
                  backgroundColor:
                      isDarkMode
                          ? AppColors.white.withOpacity(.2)
                          : AppColors.black.withOpacity(.2),
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.accent),
                  minHeight: 8,
                  borderRadius: BorderRadius.circular(4),
                ),
                const SizedBox(height: 20),

                // Menu options
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
                  icon: Icons.report_problem,
                  text: context.local.report_an_issue,
                  onTap: () async {
                    Navigator.of(context).pop();
                    sendEmail();
                  },
                ),

                _menuButton(
                  icon: isDarkMode ? Icons.light_mode : Icons.dark_mode,
                  text: isDarkMode ? context.local.light_mode : context.local.dark_mode,
                  onTap: () {
                    Navigator.of(context).pop();
                    isDarkMode = !isDarkMode;
                    _updateWebViewContent();
                    setState(() {});
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  int getLessonProgressPercentage() {
    return (((currentIndex + 1) / widget.data.length) * 100).round();
  }

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
            Icon(icon, color: AppColors.accent, size: 24),
            const SizedBox(width: 15),
            Text(
              text,
              style: medium(context, fontSize: 16, color: AppColors.accent),
            ),
          ],
        ),
      ),
    );
  }

  // Load the saved font size from shared preferences
  Future<void> _loadSavedFontSize() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        fontSize =
            prefs.getDouble(fontSizeKey) ??
            18.0; // Default to 18.0 if not found
      });
      _initWebViewController();
    } catch (e) {
      print("Error loading saved font size: $e");
      fontSize = 18.0; // Use default if there's an error
      _initWebViewController();
    }
  }

  // Save the font size to shared preferences
  Future<void> _saveFontSize(double value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble(fontSizeKey, value);
    } catch (e) {
      print("Error saving font size: $e");
    }
  }

  void _initWebViewController() {
    webViewController =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setBackgroundColor(const Color.fromARGB(0, 0, 0, 0))
          ..enableZoom(false) // Disable zoom functionality
          ..setNavigationDelegate(
            NavigationDelegate(
              onPageFinished: (String url) {
                // Execute in sequence to ensure proper initialization
                _updateWebViewContent();
              },
            ),
          );

    _loadCurrentLesson();
  }

  void _loadCurrentLesson() {
    if (webViewController != null) {
      final lessonPath =
          'assets/data/content/chapter${widget.categoryIndex + 1}/lesson${currentIndex + 1}.html';
      webViewController!.loadFlutterAsset(lessonPath);
    }
  }

  void _updateWebViewContent() {
    if (webViewController == null) return;

    // Apply styling based on user preferences
    final textColor = isDarkMode ? '#FFFFFF' : '#000000';
    final backgroundColor = isDarkMode ? '#000000' : '#FFFFFF';

    // Add CSS to disable horizontal scrolling and ensure text wrapping
    webViewController!.runJavaScript('''
    // First, remove any existing spacer that might have been added previously
    var existingSpacers = document.querySelectorAll('.bottom-spacer');
    for (var i = 0; i < existingSpacers.length; i++) {
      existingSpacers[i].remove();
    }

    // Set base styles for the body
    document.body.style.color = '${textColor}';
    document.body.style.backgroundColor = '${backgroundColor}';
    document.body.style.fontSize = '${fontSize}px';
    document.body.style.padding = '0 0 20px 0'; // Top, Right, Bottom, Left - with padding at bottom
    document.body.style.margin = '0px';
    document.body.style.width = '100%';
    document.body.style.overflowX = 'hidden'; // Prevent horizontal scrolling

    // Add meta viewport for better mobile display
    if (!document.querySelector('meta[name="viewport"]')) {
      var meta = document.createElement('meta');
      meta.name = 'viewport';
      meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no';
      document.head.appendChild(meta);
    }

    // Apply word-wrap to all text elements
    var allElements = document.querySelectorAll('*');
    for (var i = 0; i < allElements.length; i++) {
      allElements[i].style.wordWrap = 'break-word';
      allElements[i].style.overflowWrap = 'break-word';
      allElements[i].style.whiteSpace = 'normal';
      allElements[i].style.maxWidth = '100%';
    }

    // Apply font size to all text elements
    var textElements = document.querySelectorAll('p, h1, h2, h3, h4, h5, h6, span, div, li, td, th, a, button, input, textarea, label');
    for (var i = 0; i < textElements.length; i++) {
      textElements[i].style.fontSize = '${fontSize}px';
    }

    // Fix tables if present
    var tables = document.querySelectorAll('table');
    for (var i = 0; i < tables.length; i++) {
      tables[i].style.width = '100%';
      tables[i].style.tableLayout = 'fixed';
    }

    // Fix images if present
    var images = document.querySelectorAll('img');
    for (var i = 0; i < images.length; i++) {
      images[i].style.maxWidth = '100%';
      images[i].style.height = 'auto';
    }

    // Clean up any excessive whitespace at the end of the body
    var bodyContent = document.body.innerHTML;
    document.body.innerHTML = bodyContent.trim();

    // Add bottom spacer for better scrolling past floating buttons, with a class for easy identification
    var spacer = document.createElement('div');
    spacer.className = 'bottom-spacer';
    spacer.style.height = '100px';
    spacer.style.width = '100%';
    spacer.style.clear = 'both';
    document.body.appendChild(spacer);
  ''');
  }

  // void _updateWebViewContent() {
  //   if (webViewController == null) return;

  //   // Apply styling based on user preferences
  //   final textColor = isDarkMode ? '#FFFFFF' : '#000000';
  //   final backgroundColor = isDarkMode ? '#000000' : '#FFFFFF';

  //   // Reset progress on content update
  //   setState(() {
  //     scrollProgress = 0.0;
  //   });

  //   // Add CSS to disable horizontal scrolling and ensure text wrapping
  //   webViewController!.runJavaScript('''
  //   // First, remove any existing spacer that might have been added previously
  //   var existingSpacers = document.querySelectorAll('.bottom-spacer');
  //   for (var i = 0; i < existingSpacers.length; i++) {
  //     existingSpacers[i].remove();
  //   }

  //   // Set base styles for the body
  //   document.body.style.color = '${textColor}';
  //   document.body.style.backgroundColor = '${backgroundColor}';
  //   document.body.style.fontSize = '${fontSize}px';
  //   document.body.style.padding = '0 0 20px 0'; // Top, Right, Bottom, Left - with padding at bottom
  //   document.body.style.margin = '0px';
  //   document.body.style.width = '100%';
  //   document.body.style.overflowX = 'hidden'; // Prevent horizontal scrolling

  //   // Add meta viewport for better mobile display
  //   if (!document.querySelector('meta[name="viewport"]')) {
  //     var meta = document.createElement('meta');
  //     meta.name = 'viewport';
  //     meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no';
  //     document.head.appendChild(meta);
  //   }

  //   // Apply word-wrap to all text elements
  //   var allElements = document.querySelectorAll('*');
  //   for (var i = 0; i < allElements.length; i++) {
  //     allElements[i].style.wordWrap = 'break-word';
  //     allElements[i].style.overflowWrap = 'break-word';
  //     allElements[i].style.whiteSpace = 'normal';
  //     allElements[i].style.maxWidth = '100%';
  //   }

  //   // Apply font size to all text elements
  //   var textElements = document.querySelectorAll('p, h1, h2, h3, h4, h5, h6, span, div, li, td, th, a, button, input, textarea, label');
  //   for (var i = 0; i < textElements.length; i++) {
  //     textElements[i].style.fontSize = '${fontSize}px';
  //   }

  //   // Fix tables if present
  //   var tables = document.querySelectorAll('table');
  //   for (var i = 0; i < tables.length; i++) {
  //     tables[i].style.width = '100%';
  //     tables[i].style.tableLayout = 'fixed';
  //   }

  //   // Fix images if present
  //   var images = document.querySelectorAll('img');
  //   for (var i = 0; i < images.length; i++) {
  //     images[i].style.maxWidth = '100%';
  //     images[i].style.height = 'auto';
  //   }

  //   // Clean up any excessive whitespace at the end of the body
  //   var bodyContent = document.body.innerHTML;
  //   document.body.innerHTML = bodyContent.trim();

  //   // Add bottom spacer for better scrolling past floating buttons, with a class for easy identification
  //   var spacer = document.createElement('div');
  //   spacer.className = 'bottom-spacer';
  //   spacer.style.height = '100px';
  //   spacer.style.width = '100%';
  //   spacer.style.clear = 'both';
  //   document.body.appendChild(spacer);
  // ''');
  // }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    stopTTS();
    _scrollCheckTimer?.cancel();
    super.dispose();
  }

  void loadHtmlText() {
    try {
      final xmlDoc = XmlDocument.parse(widget.data[currentIndex].data);
      final textNode = xmlDoc.findAllElements('text').first;
      htmlData = textNode.innerXml;

      final plainText = htmlToPlainText(htmlData);
      wordList = plainText.split(RegExp(r'\s+'));
      highlightedHtml = _generateHighlightedHtml();
      setState(() {});
    } catch (e) {
      print("Error parsing XML: $e");
      htmlData = widget.data[currentIndex].data;
    }
  }

  String htmlToPlainText(String htmlString) {
    final document = html_parser.parse(htmlString);
    return document.body?.text ?? '';
  }

  String _generateHighlightedHtml() {
    return wordList
        .asMap()
        .entries
        .map((entry) {
          final word = entry.value;
          final index = entry.key;
          final opacity = index == currentWordIndex ? 1.0 : 0.3;
          return '<span style="opacity:$opacity">$word</span>';
        })
        .join(' ');
  }

  int estimatedDurationOfTTS(String text) {
    int wordCount = text.split(RegExp(r'\s+')).length;
    return (wordCount * 600).toInt(); // 600ms per word estimate
  }

  String estimatedDurationOfTTSFormatted(double milliseconds) {
    int totalSeconds = (milliseconds / 1000).floor();
    int minutes = totalSeconds ~/ 60;
    int seconds = totalSeconds % 60;
    return '$minutes min ${seconds.toString().padLeft(2, '0')} sec';
  }

  Future<void> startTTS() async {
    final plainText = htmlToPlainText(htmlData);

    setState(() {
      isSpeaking = true;
      currentWordIndex = -1;
      highlightedHtml = _generateHighlightedHtml();
      totalDuration = estimatedDurationOfTTS(plainText).toDouble();
      currentPosition = 0;
    });

    TtsService.instance.speakWithOnProgress(
      text: plainText,
      onComplete: () {
        setState(() {
          isSpeaking = false;
          currentWordIndex = -1;
          totalDuration = 0;
          currentPosition = 0;
          lastMatchedWordIndex = -1;
          highlightedHtml = _generateHighlightedHtml();
        });
      },
      onProgress: (String word) {
        final cleanedWord = word.toLowerCase().replaceAll(RegExp(r'[^\w]'), '');
        final searchIndex = wordList.indexWhere(
          (w) =>
              w.toLowerCase().replaceAll(RegExp(r'[^\w]'), '') == cleanedWord,
          lastMatchedWordIndex + 1,
        );

        if (searchIndex != -1) {
          setState(() {
            currentWordIndex = searchIndex;
            lastMatchedWordIndex = searchIndex;
            highlightedHtml = _generateHighlightedHtml();
            currentPosition = (searchIndex / wordList.length) * totalDuration;
          });
        }
      },
    );
  }

  void stopTTS() {
    TtsService.instance.stop();
    setState(() {
      isSpeaking = false;
      isPause = false;
      currentWordIndex = -1;
      totalDuration = 0;
      currentPosition = 0;
      lastMatchedWordIndex = -1;
      highlightedHtml = _generateHighlightedHtml();
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      stopTTS();
    }
  }

  void goToNextLesson() {
    if (currentIndex < widget.data.length - 1) {
      Provider.of<HomeScreenProvider>(context, listen: false).updateProgress(
        widget.categoryIndex.toString(),
        widget.data[currentIndex].index.toString(),
      );

      setState(() {
        stopTTS();
        currentIndex++;
        loadHtmlText();
        _loadCurrentLesson();
        PrefService.saveLastLesion(currentIndex);
      });
    } else {
      Provider.of<HomeScreenProvider>(context, listen: false).updateProgress(
        widget.categoryIndex.toString(),
        widget.data[currentIndex].index.toString(),
      );
      stopTTS();
      PrefService.clearLastSavedLesion();
      int catIndex = PrefService.getLastLesionCategory();
      PrefService.saveLastLesionCategory(catIndex + 1);
      Navigator.pop(context);
    }
  }

  // Method to manually check scroll position if JS listener fails
  Future<void> _checkScrollPosition() async {
    if (webViewController == null) return;

    try {
      final result = await webViewController!.runJavaScriptReturningResult('''
        (function() {
          var scrollPosition = window.scrollY || document.documentElement.scrollTop;
          var totalHeight = document.documentElement.scrollHeight - document.documentElement.clientHeight;
          var progress = totalHeight > 0 ? (scrollPosition / totalHeight) : 0;
          return Math.max(0, Math.min(1, progress));
        })()
      ''');

      double progress = 0.0;
      if (result is double) {
        progress = result;
      } else if (result is int) {
        progress = result.toDouble();
      } else if (result is String) {
        progress = double.tryParse(result) ?? 0.0;
      }

      setState(() {
        scrollProgress = progress;
      });
        } catch (e) {
      print("Error checking scroll position: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    double sliderValue = 0.0;

    if (wordList.isNotEmpty && totalDuration > 0) {
      sliderValue = (currentPosition / wordList.length) * totalDuration;
      sliderValue = sliderValue.clamp(0.0, totalDuration);
    }

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      appBar: AppBar(
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            stopTTS();
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.format_size,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                backgroundColor: isDarkMode ? Colors.black : Colors.white,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (context) {
                  return StatefulBuilder(
                    builder: (context, setModalState) {
                      return Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              context.local.adjust_font_size,
                              style: TextStyle(
                                fontSize: 18,
                                color: isDarkMode ? Colors.white : Colors.black,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Slider(
                              value: fontSize,
                              min: 12,
                              max: 30,
                              activeColor: AppColors.accent,
                              label: fontSize.round().toString(),
                              onChanged: (value) {
                                setModalState(() {
                                  fontSize = value;
                                });
                                setState(() {
                                  fontSize = value;
                                  _saveFontSize(
                                    value,
                                  ); // Save font size when changed
                                  _updateWebViewContent();
                                });
                              },
                            ),
                            Text(
                              "${fontSize.toStringAsFixed(0)} px",
                              style: TextStyle(
                                fontSize: 14,
                                color:
                                    isDarkMode
                                        ? Colors.white70
                                        : Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),

          IconButton(
            icon: Icon(
              Icons.more_vert,
              color: isDarkMode ? Colors.white70 : Colors.black87,
            ),
            onPressed: _showMenu,
          ),
          // IconButton(
          //   icon: Icon(
          //     isDarkMode ? Icons.dark_mode : Icons.light_mode,
          //     color: isDarkMode ? Colors.white : Colors.black,
          //   ),
          //   onPressed: () {
          //     setState(() {
          //       isDarkMode = !isDarkMode;
          //       _updateWebViewContent();
          //     });
          //   },
          // ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child:
                webViewController != null
                    ? Padding(
                      padding: EdgeInsets.fromLTRB(
                        20,
                        0,
                        20,
                        0,
                      ), // Reduced horizontal padding
                      child: WebViewWidget(controller: webViewController!),
                    )
                    : const Center(child: CircularProgressIndicator()),
          ),
        ],
      ),
      floatingActionButton: GestureDetector(
        onTap: () {
          if (isSpeaking) {
            stopTTS();
          } else {
            startTTS();
          }
        },
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            gradient: const LinearGradient(
              colors: [Color(0xffF24A33), Color(0xffEE8C8C)],
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.volume_up, color: Colors.white),
              const SizedBox(width: 8),
              Text(
                isSpeaking ? context.local.stop : context.local.listen,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildNextLessonButton(),
    );
  }

  Widget _buildNextLessonButton() {
    return GestureDetector(
      onTap: goToNextLesson,
      child: Container(
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: const Color(0xffF24A33),
        ),
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Text(
          currentIndex < widget.data.length - 1
              ? context.local.next_lesson
              : context.local.finish,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white, fontSize: 16),
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

// Keep TtsService implementation as is
class TtsService {
  static final TtsService instance = TtsService._();
  final FlutterTts _tts = FlutterTts();
  String? _lastText;
  int _currentPosition = 0;

  TtsService._();

  Future<void> init({double initialRate = 0.5}) async {
    await _tts.setLanguage("en-US");
    await setSpeechRate(initialRate);
    await _tts.setPitch(1);
  }

  Future<void> setSpeechRate(double rate) async {
    await _tts.setSpeechRate(rate);
  }

  void speakWithOnProgress({
    required String text,
    required Function(String) onProgress,
    required Function() onComplete,
  }) {
    _lastText = text;

    _tts.setProgressHandler((String text, int start, int end, String word) {
      onProgress(word);
      _currentPosition = end;
    });

    _tts.setCompletionHandler(() {
      onComplete();
    });

    _tts.speak(text);
  }

  Future<void> stop() async {
    await _tts.stop();
    _lastText = null;
    _currentPosition = 0;
  }

  Future<void> pause() async {
    await _tts.pause();
  }

  Future<void> resume() async {
    if (_lastText != null) {
      await _tts.speak(_lastText!);
    }
  }

  Future<void> forward() async {
    if (_lastText != null && _currentPosition < _lastText!.split(' ').length) {
      final words = _lastText!.split(' ');
      final newPosition = (_currentPosition + 10).clamp(0, words.length);
      String nextText = words.sublist(newPosition).join(' ');
      _currentPosition = newPosition;
      await _tts.speak(nextText);
    }
  }

  Future<void> rewind() async {
    if (_lastText == null || _currentPosition <= 0) return;

    final words = _lastText!.split(' ');
    final newPosition = (_currentPosition - 10).clamp(0, words.length);

    _currentPosition = newPosition;
    await _tts.stop();

    if (_currentPosition == 0) {
      await _tts.speak(_lastText!);
    } else {
      String nextText = words.sublist(_currentPosition).join(' ');
      await _tts.speak(nextText);
    }
  }
}
