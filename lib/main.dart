import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sequence_animation/amount_slider.dart';

import 'amount_badge.dart';

const sequencePictureCount = 60;

const startImageWidth = 172.0;
const startImageHeight = 300.0;

const endImageWidth = 267.0;
const endImageHeight = 393.0;

const int startRotationPiDivider = 360;
const int endRotationPiDivider = 48;

const sliderMin = 0.0;
const sliderMax = 600.0;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: AppBarTheme(systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: Colors.white)),
        scaffoldBackgroundColor: const Color(0xFF856EE1),
        brightness: Brightness.dark,
      ),
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int amount = 0;
  int imageNumber = 0;
  List<Image> images = [];

  double imageWidthMultiplier = 1;
  double imageHeightMultiplier = 1;

  double actualPiDividerSqrt = math.sqrt(startRotationPiDivider);

  double get actualPiDivider => actualPiDividerSqrt * actualPiDividerSqrt;

  @override
  void initState() {
    super.initState();
    for (int i = 0; i <= 60; i++) {
      images.add(
        Image.asset(
          'images/$i.png',
          gaplessPlayback: true,
          fit: BoxFit.fitWidth,
        ),
      );
    }
  }

  void onSliderValueChanged(double value) {
    setState(() {
      amount = value.round();
      imageNumber = (sequencePictureCount / sliderMax * amount).floor();

      changeImageSize(value);

      rotateImage(value);
    });
  }

  void changeImageSize(double value) {
    imageWidthMultiplier =
        1 + amount / sliderMax * startImageWidth / endImageWidth;
    imageHeightMultiplier =
        1 + amount / sliderMax * startImageHeight / endImageHeight;
  }

  void rotateImage(double value) {
    actualPiDividerSqrt = math.sqrt(360) -
        ((math.sqrt(360) - math.sqrt(48)) *
            (math.sqrt(amount) / math.sqrt(sliderMax)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Expanded(
                child: SizedBox(),
                flex: 3,
              ),
              Text(
                'Set amount',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              const Expanded(
                child: SizedBox(),
                flex: 3,
              ),
              SizedBox(
                height: endImageHeight,
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.bottomCenter,
                  children: [
                    Align(
                      child: SizedBox(
                        width: startImageWidth * startImageWidth,
                        height: startImageHeight * imageHeightMultiplier,
                        child: Transform.rotate(
                          angle: -math.pi / actualPiDivider,
                          child: IndexedStack(
                            alignment: Alignment.center,
                            children: images,
                            index: imageNumber,
                          ),
                        ),
                      ),
                      alignment: Alignment.center,
                    ),
                    Positioned(
                      child: AmountBadge(value: amount),
                      bottom: -35,
                    ),
                  ],
                ),
              ),
              const Expanded(
                child: SizedBox(),
                flex: 4,
              ),
              AmountSlider(
                onChanged: onSliderValueChanged,
                min: sliderMin,
                max: sliderMax,
              ),
              const Expanded(
                child: SizedBox(),
                flex: 4,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
