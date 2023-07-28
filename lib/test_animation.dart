import 'package:animationtesting/providers/scrollStatusNotifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class TestAnimation extends StatefulWidget {
  const TestAnimation({
    super.key,
  });

  @override
  State<TestAnimation> createState() => _TestAnimationState();
}

class _TestAnimationState extends State<TestAnimation>
    with SingleTickerProviderStateMixin {
  //1초에 60개의 frame이 바뀐다.
  late final Ticker _ticker;

  @override
  void initState() {
    // TODO: implement initState
    _ticker = createTicker((elapsed) {
      //1초에 60번이 실행
      setState(() {

      });
    });
    _ticker.start();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final zeroOne=zeroToOne();
    final curveApplied=applyCurves(zeroOne);
    final opacity=opacity2(curveApplied);
    final scale=applySize(zeroOne);
    final rotX=rotateX(zeroOne);


    /*return Positioned.fill( //stack 의 모든 자리를 다 차지하게 된다
      child:Transform(//scrolling percentage 높이가 1로 갈때 animation은 0으로 가도록 해준다(0->1, 1->0)
          transform: Matrix4.translationValues( //scroll 할 때 animation도 같이 이동한다.
             0, scrollStatusNotifier.percentageToHeight(animate()), 0),
          child:  Center(
            child:  Opacity(
              opacity: opacity,
              child:  GradientText(
                "Cash Walk",
                colors: const [
                  Color(0xff4ea0b4),
                  Color(0xff6994e3),
                  Color(0xff9283eb),
                  Color(0xffe668a5),
                  Color(0xffdd514a),
                ],
                style: const TextStyle(fontSize: 60,fontWeight: FontWeight.bold,),
              ),
            ),
          )),
    );*/
    return Positioned.fill( //stack 의 모든 자리를 다 차지하게 된다
      child:Transform(//scrolling percentage 높이가 1로 갈때 animation은 0으로 가도록 해준다(0->1, 1->0)
          transform: Matrix4.identity()..setEntry(3, 2, 0.001)..scale(scale, scale, 1)..rotateX(rotX)..rotateY(rotX), //x,y축 모두 2배로 키워준다
          //4*4 matrix에서 (3,2) 위치에 0.001 값 perspective(원근법) 깊이를 준다, x 축으로 rotate 0.9->0으로 가도록
          alignment: Alignment.center,//가운데로 오도록
          child:  Center(
            child:  Opacity(
              opacity: opacity,
              child:  GradientText(
                "Cash Walk",
                colors: const [
                  Color(0xff4ea0b4),
                  Color(0xff6994e3),
                  Color(0xff9283eb),
                  Color(0xffe668a5),
                  Color(0xffdd514a),
                ],
                style: const TextStyle(fontSize: 100,fontWeight: FontWeight.bold,),
              ),
            ),
          )),
    );
  }
  double rotateX(double curved){
    return -0.9*curved+0.9;
  }
  double animate(){
    return -1*scrollStatusNotifier.scrollPercentage; //y=-x 으로 scroll 할때마다 text도 같이 움직일 수 있도록
  }//0~-0.5  사이로 y값이 이동한다 (center에서 위로 이동 하는 것이기 때문)
  double opacity(){
    if(scrollStatusNotifier.scrollPercentage<0)
      {return 1;} //default 값}
    else if(scrollStatusNotifier.scrollPercentage>0.5)
     { return 0;}
     return -2*scrollStatusNotifier.scrollPercentage+1; //scroll이 0->0.5로 이동시에 opacity 는 1->0으로 이동
  }
  double zeroToOne(){
    if(scrollStatusNotifier.scrollPercentage<0)
    {return 0;} //default 값}
    else if(scrollStatusNotifier.scrollPercentage>0.5)
    { return 1;}
    return 2*scrollStatusNotifier.scrollPercentage; //0~0.5 이동시 0~1 로 바뀜
  }

  double applyCurves(double zeroToOneValue){
    return Curves.easeInQuint.transform(zeroToOneValue); //여기서 가져오는 값으로 해당 curve가 적용이 된다
  }
  double opacity2(double curveAppliedValue){
    return -1*curveAppliedValue+1;
  }
  double applySize(double zeroToOne){
    return zeroToOne+1; //0~1로 이동할때 1~2로 커지도록 세팅한다
  }
}
