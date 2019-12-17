import 'package:flutter/material.dart';
import 'WdyScrollImageCell/WdyScrollImageCell_DemoView.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Home()
    );
  }
}

//这里包一层，否则直接用App的context，Navigator报错，要用下层的context。
class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Wdy Contrls Demo"),),
      body: ListView(
          children: ListTile.divideTiles(
              context: context,
              tiles: [
                ListTile(
                  title: Text("Scroll Image Cell"),
                  trailing: Icon(Icons.navigate_next),
                  onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context){
                          return WdyScrollImageCell_DemoView();
                        }
                    ));
                  },
                )
              ]).toList()
      ),
    );
  }
}