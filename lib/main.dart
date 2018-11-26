import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

void main() {
  runApp(
      new MaterialApp(
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

class SettingsScreen extends StatelessWidget {

  TextField serverInputField;
  
  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      appBar: new AppBar(title: new Text("Settings"),),
      body: new Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
           serverInputField = new TextField(
                                            decoration: InputDecoration(
                                                labelText: 'Server address:'
                                            ),
          ),
          // ignore: argument_type_not_assignable
          RaisedButton(onPressed: saveData,

          ),
        ],

      ) ,
    );

  }

  void saveData() {
    print(serverInputField.toString());
    
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
        color: Colors.black38,
        child: new ListView(
            padding: const EdgeInsets.all(10.0),
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.all(5.0),
                  child:RaisedButton(
                    onPressed: () { Navigator.of(context).pushNamed('/sync');},
                    color: Colors.orange,
                    padding: EdgeInsets.all(10.0),
                    child: Row(children: <Widget>[Icon(Icons.import_export),Text("Выполнить синхронизацию")],),
                  ),
              ),
              Padding(
                  padding: EdgeInsets.all(5.0),
                  child: OutlineButton(
                    onPressed: () { Navigator.of(context).pushNamed('/route');},
                    color: Colors.orange,
                    padding: EdgeInsets.all(10.0),
                    child: Row(children: <Widget>[Icon(Icons.list),Text("Маршрут")],),
                ),
              ),
              OutlineButton(
                onPressed: () { Navigator.of(context).pushNamed('/settings');},
                color: Colors.orange,
                padding: EdgeInsets.all(5.0),
                child: Row(children: <Widget>[Icon(Icons.settings),Text("Настройки")],),),
            ],
        )

      )
    );
  }

}

class SyncScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(title: new Text("Синхронизация"),),
        body: new Container(
            color: Colors.deepPurple,
            child: new RaisedButton(onPressed:(){ Navigator.of(context).pushNamed('/screen3'); }),

            )
        );
     }
  void syncButton(){

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
