import 'dart:ui';


import 'package:animationtesting/providers/scrollStatusNotifier.dart';
import 'package:animationtesting/scroll_video.dart';
import 'package:animationtesting/siteAppbar.dart';
import 'package:animationtesting/test_animation.dart';
import 'package:animationtesting/utils/animCalculator.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:provider/provider.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'SFPro'),
      home: ChangeNotifierProvider.value(
          value: scrollStatusNotifier,
          child: const MyHomePage(title: 'Flutter Demo Home Page')),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with AnimCalculator {
  late final ScrollController _scrollController;
  Size? _size;
  double? scrollHeight;
  bool scrolling = false;
  Color backgroundColor = Colors.white;
  bool fadeIn = false;

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      scrollStatusNotifier.setScrollPos(_scrollController.offset); //scroll에 대해 offset 을 읽어서 조절,얼마나 스크롤이 되었는지
      changeBackgroundColor(); //배경 색을 바꾸기
    }); //_scrollController listen을 한다

    Future.delayed(const Duration(milliseconds: 500)).then((value) {
      setState(() {
        fadeIn = true;
      });
    }); //처음에는 scroll이 안되도록 한다 (animation을 주기 위해서)
    super.initState();
  }

  void changeBackgroundColor() {
    if (backgroundColor == Colors.white &&
        scrollStatusNotifier.scrollPercentage > 6.3) {
      backgroundColor = Colors.black;
      setState(() {});
    } else if (backgroundColor == Colors.black &&
        scrollStatusNotifier.scrollPercentage < 6.1) {
      backgroundColor = Colors.white;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, constraints) {
        _size = MediaQuery.of(context).size;
        scrollStatusNotifier.size = _size!;
        // scrollHeight = _size!.height * 5;
        scrollHeight = _size!.height * 7.3;
        return Scaffold(
          backgroundColor: backgroundColor,
          floatingActionButton: scrolling
              ? null
              : FloatingActionButton.small(
                  onPressed: () {
                    setState(() {
                      scrolling = true;
                    });
                    animateToEnd().then((value) => goBackToTop().then((value) { //scroll이 다 끝나면 goBackToTop으로 다시 올라감. srolling을 false로 바꾼다
                          setState(() {
                            scrolling = false;
                          });
                        }));
                  },
                  child: const Icon(Icons.play_arrow),
                ),
          body: AnimatedOpacity(
            opacity: fadeIn ? 1 : 0,
            duration: const Duration(seconds: 1),
            child: Center(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  const ScrollVideo(),
                  const TestAnimation(),

                 // buildTitle(),
                  //RevealIPhones(size: _size!),
                  //Emergency(size: _size!),
                  //BetteryCharging(size: _size!),
                  //BigNBigger(size: _size!),
                 // ScrollVideoPlayer(size: _size!),
                  SingleChildScrollView(
                    controller: _scrollController,
                    physics:
                        fadeIn ? null : const NeverScrollableScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(
                          height: scrollHeight,
                        ),
                        /*SalesSection(
                          size: _size!,
                        ),*/
                        // SizedBox(
                        //   height: scrollStatusNotifier.percentageToHeight(0.5),
                        // ),
                      ],
                    ),
                  ),
                  //const SiteAppbar(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Consumer<ScrollStatusNotifier> buildTitle() {
    return Consumer<ScrollStatusNotifier>(
      builder: (context, ssn, child) {
        final portionValue = AnimCalculator.convertToZeroToOne(
            scrollPercentage: ssn.scrollPercentage, from: 0, to: 0.45);

        final opacity = -pow(portionValue, 6) + 1;
        return Transform.translate(
            offset:
                Offset(0, -ssn.scrollPos + ssn.scrollPos * 0.3 * portionValue),
            child: Center(
              child: Opacity(
                  opacity: opacity.toDouble(),
                  child: SizedBox(
                    width: _size!.width,
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: _size!.width * 0.2),
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: GradientText(
                          'iPhone 14',
                          colors: const [
                            Color(0xff4ea0b4),
                            Color(0xff6994e3),
                            Color(0xff9283eb),
                            Color(0xffe668a5),
                            Color(0xffdd514a),
                          ],
                          style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontFamily: 'SFPro',
                              color: Colors.black),
                          maxLines: 1,
                        ),
                      ),
                    ),
                  )),
            ));
      },
    );
  }

  Future<void> animateToEnd() { //스크롤을 내릴때
    final leftScroll = scrollHeight! - scrollStatusNotifier.scrollPos;
    double seconds = leftScroll / scrollHeight! * 7;
    if (seconds <= 0) {
      seconds = 0.1;
    }
    return _scrollController.animateTo(scrollHeight!,
        duration: Duration(milliseconds: (seconds * 1000).toInt()),
        curve: Curves.linear);
  }

  Future<void> goBackToTop() { //다시 위로 스크롤할때!
    return _scrollController.animateTo(0,
        duration: const Duration(seconds: 2), curve: Curves.easeInOutCubic);
  }
}


