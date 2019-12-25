import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'WdyScrollImageCell.dart';

class WdyScrollImageCell_DemoView extends StatelessWidget {
  ScrollController controller = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("WdyScrollImageCell"),),
      body: ListView.builder(
          controller: controller,
          itemCount: 50,
          itemBuilder: (context, i) {
            if (i == 8){
              return WdyScrollImageCell(
                imageUrl: "http://b-ssl.duitang.com/uploads/item/201708/02/20170802140436_2nKfL.png",
                height: 200,
                controller: controller,
              );
            }else if (i == 12){
              return WdyScrollImageCell(
                imageUrl: "http://img.pconline.com.cn/images/upload/upc/tx/wallpaper/1306/29/c2/22740938_1372520348254.jpg",
                height: 200,
                controller: controller,
              );
            }else{
              return ListTile(
                title: Text(WordPair.random().asPascalCase),
              );
            }
          }
      ),
    );
  }
}