import 'package:canadian_citizenship/provider/test_progress_provider.dart';
import 'package:canadian_citizenship/provider/test_score_history_provider.dart';
import 'package:canadian_citizenship/services/ads_service.dart';
import 'package:canadian_citizenship/services/firebase_push_notification_service.dart';
import 'package:canadian_citizenship/services/notification_servive.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:timezone/data/latest.dart';
import 'libs.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:firebase_core/firebase_core.dart';

ValueNotifier<String> selectedLanguage = ValueNotifier<String>('en');

late AdsController adsController;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // initialize the Firebase app
  await Firebase.initializeApp();

  // initialize the Firebase push notification service
  await FirebasePushService.initialize();

  // initialize google mobile ads
  await MobileAds.instance.initialize();
  adsController = AdsController(
    rewardedId: 'ca-app-pub-3940256099942544/5224354917',
  );

  // initialize the shared preferences
  await PrefService.init();

  // get the selected language from shared preferences
  selectedLanguage.value = PrefService.getSelectedLanguage();

  // initialize the tts service
  TtsService.instance.init();

  // initialize the local notifications timezone
  initializeTimeZones();
  final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
  final safeTimeZone =
      currentTimeZone == "Asia/Calcutta" ? "Asia/Kolkata" : currentTimeZone;
  tz.setLocalLocation(tz.getLocation(safeTimeZone));
  NotificationService.initNotification();

  runApp(
    AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: ListenableBuilder(
        listenable: selectedLanguage,
        builder: (context, _) {
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) => HomeScreenProvider()),
              ChangeNotifierProvider(create: (_) => GlossaryProvider()),
              ChangeNotifierProvider(create: (_) => MockTestProvider()),
              ChangeNotifierProvider(create: (_) => TestProgressProvider()),
              ChangeNotifierProvider(create: (_) => TestScoreHistoryProvider()),
            ],
            child: MaterialApp(
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              locale: Locale(selectedLanguage.value),
              debugShowCheckedModeBanner: false,
              theme: AppTheme.appTheme,
              home: const CanadianCitizenshipTest(),
            ),
          );
        },
      ),
    ),
  );
}

extension LocalizationExtension on BuildContext {
  AppLocalizations get local => AppLocalizations.of(this)!;
}
