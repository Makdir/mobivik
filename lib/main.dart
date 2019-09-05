import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobivik/screens/routescreen.dart';
import 'package:mobivik/screens/settings.dart';
import 'package:mobivik/screens/synchronization.dart';

void main() {
  runApp(
      new MaterialApp(

        title: 'Mobivik',
        theme: ThemeData(primarySwatch: Colors.amber[200],),
        home: new MainScreen(),
        routes: <String, WidgetBuilder> {
          //'/logout': (BuildContext context) => new LoginScreen(),
          '/settings': (BuildContext context) => new SettingsScreen(),
          '/route': (BuildContext context) => new RouteScreen(),
          '/sync': (BuildContext context) => new SyncScreen(),
        },
      )
  );
}

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(),
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



