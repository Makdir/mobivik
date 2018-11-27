import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:sqflite/sqflite.dart';
import 'package:mobivik/screens/settings.dart';
import 'package:mobivik/screens/synchronization.dart';

void main() {
  runApp(
      new MaterialApp(
        title: 'Mobivik',
        home: new MainScreen(),
        routes: <String, WidgetBuilder> {
          '/logout': (BuildContext context) => new LoginScreen(),
          '/settings': (BuildContext context) => new SettingsScreen(),
          '/route': (BuildContext context) => new RouteScreen(),
          '/sync': (BuildContext context) => new SyncScreen(),
        },
      )
  );
}



class LoginScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new Scaffold( // 1
      appBar: new AppBar(
        title: new Text("Please, login"), // screen title

      ),
      body: new Center(
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Container(
              padding: const EdgeInsets.all(16.0),
              child: new TextField(
                keyboardType: TextInputType.number,
                //controller: _controller,
                decoration: new InputDecoration(
                  hintText: 'Zip Code',
                ),
                onSubmitted: (string) {
                  return string;
                },
              ),
            ),

            new RaisedButton(onPressed:(){
              button1(context);
              } ,child: new Text("Go to Screen 2"),
            )
          ],
        ),
      ) ,
    );
  }

  void button1(BuildContext context){
    print("Button 1");
    Navigator.of(context).pushNamed('/screen2');
  }
}


class Screen3 extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Screen 3"),

      ),
      body: new Center(
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new RaisedButton(onPressed:(){
              button3(context);
            } ,child: new Text("Back to Screen 1"),)
          ],
        ),
      ) ,
    );

  }

  void button3(BuildContext context){
    print("Button 3");
    Navigator.of(context).pop(true);
  }
}

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(backgroundColor: Colors.brown),
        body: new Container(
        color: Colors.white,
        child: new ListView(
            padding: const EdgeInsets.all(10.0),
            children: <Widget>[
              button(Icons.import_export,'Синхронизация',context,'/sync'),
              button(Icons.list,'Маршрут',context,'/route'),
              button(Icons.settings,'Настройки',context,'/settings'),
            ],
        )

      )
    );
  }
  Widget button(IconData iconData, String title, BuildContext context, String navlink){
    return Padding(
      padding: EdgeInsets.all(5.0),
      child:RaisedButton(
        onPressed: () { Navigator.of(context).pushNamed(navlink);},
        color: Colors.orangeAccent,
        padding: EdgeInsets.all(10.0),
        shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
        splashColor: Colors.limeAccent,
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[Icon(iconData),Text(title)],),
      ),
    );
  }
}



class RouteScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(title: new Text("Маршрут"),),
        body: new Container(         )
    );
  }

}
