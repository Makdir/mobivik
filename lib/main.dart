import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:mobivik/screens/goods_screen.dart';
import 'package:mobivik/screens/routescreen.dart';
import 'package:mobivik/screens/settings.dart';
import 'package:mobivik/screens/synchronization.dart';

import 'package:koukicons/engineering.dart';
import 'package:koukicons/synchronize.dart';

void main() {
  runApp(
      new MaterialApp(

        title: 'Mobivik',
        theme: ThemeData(colorScheme: ColorScheme.dark(primary: Colors.amber)),// Colors.black87,),
        home: new MainScreen(),
        routes: <String, WidgetBuilder> {
          //'/logout': (BuildContext context) => new LoginScreen(),
          '/settings': (BuildContext context) => new SettingsScreen(),
          '/route': (BuildContext context) => new RouteScreen(),
          '/sync': (BuildContext context) => new SyncScreen(),
          '/goods': (BuildContext context) => new GoodsScreen(),
        },
      )
  );
}



class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(title: const Text(""), actions: <Widget>[
            IconButton(
              icon: KoukiconsEngineering(),//Icon(Icons.settings_applications),
              onPressed: () {
                Navigator.of(context).pushNamed("/settings");
              },
        ),],),
        body: new Container(
          color: Colors.white,
          child: new ListView(
              padding: const EdgeInsets.all(10.0),
              children: <Widget>[
                button(Icons.sync,'Синхронизация',context,'/sync'),
                button(Icons.list,'Маршрут',context,'/route'),
                button(Icons.settings,'Настройки',context,'/settings'),
                button(Icons.storage,'Товары',context,'/goods'),
              ],
        )

      )
    );
  }
  Widget button(IconData iconData, String title, BuildContext context, String navlink){
    return Padding(
      padding: EdgeInsets.all(5.0),
      child:RaisedButton(

        child: Row(mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(iconData),
            Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        onPressed: () { Navigator.of(context).pushNamed(navlink);},
        color: Colors.orangeAccent,
        padding: EdgeInsets.all(10.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(3.0),
                          bottomRight: Radius.circular(21.0),
                          topLeft: Radius.circular(21.0),
                          topRight: Radius.circular(3.0)),
        ),
        splashColor: Colors.limeAccent,



      ),
    );
  }
}
