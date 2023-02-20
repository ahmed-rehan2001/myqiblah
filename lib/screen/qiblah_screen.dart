import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';

class QiblahScreen extends StatefulWidget {
  const QiblahScreen({Key? key}) : super(key: key);

  @override
  State<QiblahScreen> createState() => _QiblahScreenState();
}
Animation <double>? animation;
AnimationController ?animationController;
double begin =0.0;
class _QiblahScreenState extends State<QiblahScreen>  with SingleTickerProviderStateMixin{
  @override
  void initState() {
    animationController = AnimationController(vsync: this,duration: const Duration(milliseconds: 500));
    animation = Tween(begin: 0.0,end: 0.0).animate(animationController!);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 109, 127, 73),
        body: StreamBuilder(
          stream: FlutterQiblah.qiblahStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(alignment: Alignment.center, child: const CircularProgressIndicator(color: Colors.white,));
            }

            final qiblahDirection = snapshot.data;
            animation = Tween(begin: begin, end: (qiblahDirection!.qiblah * (3.14159265359 / 180) * -1)).animate(animationController!);
            begin = (qiblahDirection.qiblah * (3.14159265359 / 180) * -1);
            animationController!.forward(from: 0);

            return Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${qiblahDirection.direction.toInt()}°",
                      style: const TextStyle(color: Colors.white, fontSize: 24),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                        height: 300,
                        child: AnimatedBuilder(
                          animation: animation!,
                          builder: (context, child) => Transform.rotate(
                              angle: animation!.value,
                              child: Image.asset('assets/images/qibla.png')),
                        ))
                  ]),
            );
          },
        ),
      ),
    );
  }
}