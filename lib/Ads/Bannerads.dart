import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shimmer/shimmer.dart';

class BannerAdWidget extends StatefulWidget {
  final String adId;

  const BannerAdWidget({Key? key, required this.adId}) : super(key: key);

  @override
  _BannerAdWidgetState createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  BannerAd? _anchoredAdaptiveAd;
  bool _isLoaded = false;
  late Orientation _currentOrientation;
  bool failedToLoad = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((callback) {
      _currentOrientation = MediaQuery.of(context).orientation;
      _loadAd();
    });
  }

  Future<void> _loadAd() async {
    await _anchoredAdaptiveAd?.dispose();
    setState(() {
      _anchoredAdaptiveAd = null;
      _isLoaded = false;
    });

    final AnchoredAdaptiveBannerAdSize? size =
    await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
        MediaQuery.of(context).size.width.truncate());

    if (size == null) {
      print('Unable to get height of anchored banner.');
      return;
    }

    _anchoredAdaptiveAd = BannerAd(
      adUnitId: widget.adId,
      size: size,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          setState(() {
            _anchoredAdaptiveAd = ad as BannerAd;
            _isLoaded = true;
          });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          print('Anchored adaptive banner failedToLoad: $error');
          setState(() {
            failedToLoad = true;
          });
          ad.dispose();
        },
      ),
    );

    return _anchoredAdaptiveAd!.load();
  }

  Widget _getAdWidget() {
    return OrientationBuilder(
      builder: (context, orientation) {
        if (_currentOrientation == orientation &&
            _anchoredAdaptiveAd != null &&
            _isLoaded) {
          return Container(
            color: Colors.transparent,
            width: _anchoredAdaptiveAd!.size.width.toDouble(),
            height: _anchoredAdaptiveAd!.size.height.toDouble(),
            child: AdWidget(ad: _anchoredAdaptiveAd!),
          );
        }
        if (_currentOrientation != orientation) {
          _currentOrientation = orientation;
          _loadAd();
        }
        return Container(
          height: MediaQuery.of(context).size.height / 13.5,
          width: double.infinity,
        );
      },
    );
  }

  Widget _getBannerLoaderAd() {
    if (_isLoaded) {
      return _getAdWidget();
    } else {
      return SizedBox(
        height: MediaQuery.of(context).size.height / 13.5,
        width: double.infinity,
        child: Shimmer.fromColors(
          direction: ShimmerDirection.ttb,
          enabled: true,
          baseColor: Colors.grey.shade100,
          highlightColor: Colors.grey.shade500,
          child: Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height / 13.5,
            color:Colors.white38,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return _getBannerLoaderAd();
  }
}
