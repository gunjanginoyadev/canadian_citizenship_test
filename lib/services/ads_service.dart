import 'package:flutter/cupertino.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

late AdsController adsController;

class AdsController {
  String rewardedId;
  bool _showAd = true;

  set showAd(bool value) => _showAd = value;

  AdsController({required this.rewardedId}) {
    _showAd = true;
    // _getUserConsent();
    _loadRewardedAd();
  }

  RewardedAd? _rewardedAd;

  bool adShowed = true;
  bool isRewardedAdActive = false;

  void _route(BuildContext context, {VoidCallback? onRoute}) {
    if (onRoute != null) {
      onRoute();
    } else {
      Navigator.pop(context);
    }
  }

  _loadRewardedAd() {
    RewardedAd.load(
      adUnitId: rewardedId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
        },
        onAdFailedToLoad: (error) {
          _rewardedAd = null;
        },
      ),
    );
  }

  void showRewardedAd(
    BuildContext context, {
    required VoidCallback onRewardGranted,
  }) {
    if (_rewardedAd != null) {
      isRewardedAdActive = true;
      _rewardedAd!.show(
        onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
          // This callback is called when the user earns a reward.
        },
      );

      _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (ad) {},
        onAdDismissedFullScreenContent: (ad) {
          isRewardedAdActive = false;
          onRewardGranted();
          _loadRewardedAd();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          isRewardedAdActive = false;
          print('Failed to show rewarded ad: $error');
          _loadRewardedAd();
        },
      );
    } else {
      _loadRewardedAd();
    }
  }
}

// class BannerAdWidget extends StatefulWidget {
//   const BannerAdWidget({Key? key}) : super(key: key);

//   /// This Widget is For display BannerAd Without any mathods

//   @override
//   State<BannerAdWidget> createState() => _BannerAdWidgetState();
// }

// class _BannerAdWidgetState extends State<BannerAdWidget> {
//   @override
//   Widget build(BuildContext context) {
//     return ListenableBuilder(
//       listenable: appData,
//       builder: (context, child) {
//         if (_bannerAd == null || appData.premiumUser) return const SizedBox();
//         return SafeArea(
//           child: SizedBox(
//             height: _bannerAd!.size.height.toDouble(),
//             width: _bannerAd!.size.width.toDouble(),
//             child: AdWidget(ad: _bannerAd!),
//           ),
//         );
//       },
//     );
//   }

//   BannerAd? _bannerAd;

//   @override
//   void initState() {
//     super.initState();
//     adsController._loadBannerAd(listener: _bannerAdlistner);
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     if (_bannerAd != null) {
//       _bannerAd!.dispose();
//     }
//   }

//   late final _bannerAdlistner = BannerAdListener(
//     onAdLoaded: (ad) {
//       setState(() {
//         _bannerAd = ad as BannerAd;
//       });
//     },
//     onAdFailedToLoad: (ad, error) {
//       setState(() {
//         _bannerAd = null;
//       });
//     },
//   );
// }

// class BannerAdWidgetWithoutSafeArea extends StatefulWidget {
//   const BannerAdWidgetWithoutSafeArea({Key? key}) : super(key: key);

//   @override
//   State<BannerAdWidgetWithoutSafeArea> createState() =>
//       _BannerAdWidgetWithoutSafeAreaState();
// }

// class _BannerAdWidgetWithoutSafeAreaState
//     extends State<BannerAdWidgetWithoutSafeArea> {
//   @override
//   Widget build(BuildContext context) {
//     return ListenableBuilder(
//       listenable: appData,
//       builder: (context, child) {
//         if (_bannerAd == null || appData.premiumUser) return const SizedBox();
//         return SizedBox(
//           height: _bannerAd!.size.height.toDouble(),
//           width: _bannerAd!.size.width.toDouble(),
//           child: AdWidget(ad: _bannerAd!),
//         );
//       },
//     );
//   }

//   BannerAd? _bannerAd;

//   @override
//   void initState() {
//     super.initState();
//     adsController._loadBannerAd(listener: _bannerAdlistner);
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     if (_bannerAd != null) {
//       _bannerAd!.dispose();
//     }
//   }

//   late final _bannerAdlistner = BannerAdListener(
//     onAdLoaded: (ad) {
//       setState(() {
//         _bannerAd = ad as BannerAd;
//       });
//     },
//     onAdFailedToLoad: (ad, error) {
//       setState(() {
//         _bannerAd = null;
//       });
//     },
//   );
// }

AppData appData = AppData();

class AppData extends ChangeNotifier {
  bool _premiumUser = false;
  bool get premiumUser => _premiumUser;

  set premiumUser(bool value) {
    _premiumUser = value;
    notifyListeners();
  }

  void setPremiumUser(bool value) {
    _premiumUser = value;
    notifyListeners();
  }
}
