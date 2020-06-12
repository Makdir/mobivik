import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobivik/screens/buyorders_journal.dart';
import 'package:mobivik/screens/goods_screen.dart';
import 'package:mobivik/screens/payments_journal.dart';
import 'package:mobivik/screens/route_screen.dart';
import 'package:mobivik/screens/settings.dart';
import 'package:mobivik/screens/synchronization.dart';

import 'common/project_icons.dart';

//import 'package:flutter/services.dart' show rootBundle;

void main() {
  runApp(
      MaterialApp(

        title: 'Mobivik',
        theme:  new ThemeData(
          primarySwatch: Colors.lime,
          backgroundColor: Colors.black38,

        ),
        home: new MainScreen(),
        routes: <String, WidgetBuilder> {
          //'/logout': (BuildContext context) => new LoginScreen(),
          '/settings': (BuildContext context) => new SettingsScreen(),
          '/route': (BuildContext context) => new RouteScreen(),
          '/sync': (BuildContext context) => new SyncScreen(),
          '/goods': (BuildContext context) => new GoodsScreen(),
          '/buyorders': (BuildContext context) => new BuyordersJournal(),
          '/payments': (BuildContext context) => new PaymentsJournal(),
         },
      )
  );
}

class MainScreen extends StatelessWidget {

//  final Widget settingsIcon = SvgPicture.asset(
//    'assets/svg/settings.svg',
//    semanticsLabel: 'Settings',
//  );

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        //backgroundColor: Colors.black54,
        appBar: AppBar(title: const Text(""),
          actions: <Widget>[
              IconButton(
                //icon: KoukiconsEngineering(),//Icon(Icons.settings_applications),
                icon: ProjectIcons.settingsIcon,
                onPressed: () {
                  Navigator.of(context).pushNamed("/settings");
                },
              ),
            ],
        ),
        body: Container(
          child: ListView(
              padding: const EdgeInsets.all(10.0),
              children: <Widget>[
                button(Icons.sync,' Синхронизация',context,'/sync'),
                button(Icons.storage,' Товары',context,'/goods'),
                button(Icons.people_outline,' Маршрут',context,'/route'),
                button(Icons.settings,' Журнал заказов',context,'/buyorders'),
                button(Icons.payment,' Принятые оплаты',context,'/payments'),
              ],
        )

      )
    );
  }

  Widget button(IconData iconData, String title, BuildContext context, String navlink){
    return Padding(
      padding: EdgeInsets.all(5.0),
      child:RaisedButton(
        textTheme: ButtonTextTheme.primary,
        child: Row(mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(iconData),
            Text(title, style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold)),
          ],
        ),
        onPressed: () { Navigator.of(context).pushNamed(navlink);},
        elevation: 5,
        color: Colors.orangeAccent,
        padding: EdgeInsets.fromLTRB(10, 30, 10, 30),
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
