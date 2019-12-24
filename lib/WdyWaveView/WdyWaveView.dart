import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WdyWaveView extends StatefulWidget {
  //WdyWaveView({this.waveCenterY, this.waveHeight, this.color, this.waveFrequency, this.waveMoveSpeed});
  double waveCenterY;
  var waveHeight = 20.0;
  var color = Color.fromRGBO(51, 128, 255, 77);
  var waveFrequency  = .45;
  var waveMoveSpeed = 140.0 + Random(DateTime.now().second).nextInt(40).toDouble();
  @override
  WdyWaveViewState createState() => WdyWaveViewState();
}

class WdyWaveViewState extends State<WdyWaveView> {
  final startTime = DateTime.now().millisecondsSinceEpoch - Random(DateTime.now().second).nextInt(1000);
  double time;
  @override
  Widget build(BuildContext context) {
    time = (DateTime.now().millisecondsSinceEpoch - startTime).toDouble() / 1000.0;
    return CustomPaint(
        painter: Wave(
          waveCenterY: widget.waveCenterY,
          waveHeight: widget.waveHeight,
          color: widget.color,
          waveFrequency: widget.waveFrequency,
          waveMoveSpeed: widget.waveMoveSpeed,
          time: time,
        ),
        size: Size.infinite
    );
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((callback){
      WidgetsBinding.instance.addPersistentFrameCallback((callback){
        if (mounted){
          setState(() {
            time = (DateTime.now().millisecondsSinceEpoch - startTime).toDouble() / 1000.0;
          });
          WidgetsBinding.instance.scheduleFrame();
        }
      });
    });
  }
}


class Wave extends CustomPainter {
  Wave({this.waveCenterY, this.waveHeight, this.color, this.waveFrequency, this.waveMoveSpeed, this.time});
  final double waveCenterY;
  final double waveHeight;
  final Color color;
  final double waveFrequency;
  final double waveMoveSpeed;
  final double time;

  void paint(Canvas canvas, Size size) {
    final centerY = waveCenterY == null ? size.height/2 : waveCenterY;

    for (int i = 0; i < 2; i++) {
      Path path = new Path()
        ..moveTo(size.width, size.height)
        ..lineTo(0, size.height);

      for (double x = 0; x < size.width; x++) {
        final preTime = time - x / (waveMoveSpeed * (0.5 * i.toDouble() + 1.0)) + waveFrequency * 0.1 * i.toDouble();
        final y = size.height - centerY - sin(preTime * pi * 2 * waveFrequency) * waveHeight;
        path.lineTo(x, y);
      }

      var gradient = LinearGradient(
          colors: [color, Color.fromRGBO(color.red, color.green, color.blue, 0.1)],
          begin: Alignment(0.0,  size.height - centerY * 2.0),
          end: Alignment.bottomCenter
      );

      var paint = Paint()
        ..color = color
        ..style = PaintingStyle.fill;

      canvas.drawPath(
        path,
        paint..shader = gradient.createShader(Rect.fromLTRB(0, 0, size.width, size.height)),
      );
    }
  }

  bool shouldRepaint(Wave other) => true;
}