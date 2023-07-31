import 'package:animationtesting/providers/scrollStatusNotifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:format/format.dart';

class ScrollVideo extends StatefulWidget {
  const ScrollVideo({super.key});

  @override
  State<ScrollVideo> createState() => _ScrollVideoState();
}

class _ScrollVideoState extends State<ScrollVideo> with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  List<Image> imgs=<Image>[];
  @override
  void initState() {
    for(int i=0;i<=120;i++){
      final formatted=format('{:04d}',i);
      imgs.add(Image.asset('imgs/iphonePlay/$formatted.jpg'));
    }
    _ticker = createTicker((elapsed) {
      //1초에 60번이 실행
      setState(() {

      });
    });
    _ticker.start();
    super.initState();
  }
  @override
  void didChangeDependencies() { //image들을 미리 만들어줘야한다
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    for(Image image in imgs){
      precacheImage(image.image, context);//imgs[i] 하나씩 가져와서 실제 image를 cache에 저장한다
    }
  }
  @override
  Widget build(BuildContext context) {
    final imageNum=scrollStatusNotifier.scrollPos~/10>=120?120:scrollStatusNotifier.scrollPos~/10; //scroll 속도가 빨라서 10으로 나눠 준다

    return  Positioned.fill(child: IndexedStack(
      index: imageNum,
      children:imgs, //image 를 미리 stack에 띄워놓고 하나씩 보여주면 image가 커도 끊기지 않게 할 수 있을 수 있다
    ));
     // Positioned.fill(child: imgs[imageNum]);
  }
}
