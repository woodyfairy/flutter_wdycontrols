import 'package:flutter/material.dart';
import 'WdyWaveView.dart';

class WdyWaveView_DemoView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("WdyWaveView"),),
      body: Container(
        height: 200,
        child: WdyWaveView(),
      ),
    );
  }
}