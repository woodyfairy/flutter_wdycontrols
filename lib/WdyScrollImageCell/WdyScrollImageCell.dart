import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
class WdyScrollImageCell extends StatelessWidget {
  final String imageUrl;
  final double height;
  final ScrollController controller;
  WdyScrollImageCell({this.imageUrl, this.height, this.controller}) : super(key : GlobalKey());

  final ScrollController _innertController = ScrollController();
  Image image;
  int imageWidth;
  int imageHeight;

  double originY; //初始创建时cell相对于scrollview的坐标

  @override
  Widget build(BuildContext context) {

    if (controller != null){
      //初次的坐标(相对于listView)
      WidgetsBinding.instance.addPostFrameCallback((callback){
        GlobalKey gKey = this.key;
        RenderBox renderBox = gKey.currentContext.findRenderObject();
        originY = renderBox.getTransformTo(renderBox.parent.parent.parent.parent.parent).getTranslation().y + controller.offset;
//        print("----------");
//        var p = renderBox.parent;
//        while (p != null){
//          print(p);
//          p = p.parent;
//        }
//        print(controller.offset);
//        print("originY: $originY");

        //renderBox初始化后才能刷新页面
        _refreshView();
      });
      //变化监听
      controller.addListener(_refreshView);
    }
//    WidgetsBinding.instance.addPostFrameCallback((callback){
//      WidgetsBinding.instance.addPersistentFrameCallback((callback){
//        _refreshView();
//      });
//    });

    image = Image.network(imageUrl);
    image.image.resolve(ImageConfiguration()).addListener(ImageStreamListener((ImageInfo image, bool synchronousCall){
      imageWidth = image.image.width;
      imageHeight = image.image.height;
      //print("size: $imageWidth,$imageHeight");
      _refreshView();
    }));


    return Container(
      height: height,
      child: SingleChildScrollView(
        controller: _innertController,
        child: image,
        physics: NeverScrollableScrollPhysics(), //不可拖动
        padding: EdgeInsets.fromLTRB(0, height, 0, height), //防止回弹效果
      ),
    );
  }

  void _refreshView(){
    if (_innertController.hasClients && imageHeight != null){
      //获取尺寸与位置信息
      GlobalKey gKey = this.key;
      RenderBox renderBox = gKey.currentContext?.findRenderObject();
      if (renderBox != null) {
        //listView可视高度
        var scrollViewHeight = controller.position.viewportDimension;
        //本身cell尺寸
        var cellSize = renderBox.size;
        //image缩放后的高度
        var imageTrueHeight = cellSize.width / imageWidth * imageHeight;
        //cell相对scrollView坐标位置
        var posInListView = originY - controller.offset;
        //var posInListView = renderBox.getTransformTo(renderBox.parent.parent.parent.parent).getTranslation().y;
        //⬆这里为何需要先储存初始坐标再根据offset计算，而不是实时计算相对坐标：
        //因为此时计算的坐标不准确：跟踪源码(ScrollPosition)可知controller发送变化通知(notifyListeners)之后再进行处理布局处理，
        //此时所有父级的RenderObjcet还未发生偏移变化，当处理完计算之后父级RenderObjcet才改变为新坐标，便产生了1帧的误差。
        //所以要以controller.offset为准才可真正同步。而把初始位置的采集放在了初始时。

        //计算
        var offset = posInListView / (scrollViewHeight - cellSize.height) * (imageTrueHeight - cellSize.height);
        if (imageTrueHeight > scrollViewHeight) {
          if (offset < 0){
            offset = posInListView;
          }else if (offset > imageTrueHeight - cellSize.height) {
            offset = posInListView + imageTrueHeight - scrollViewHeight;
          }
        }
        //print(offset);
        _innertController.jumpTo(offset + height); //+padding
      }
    }
  }
}
