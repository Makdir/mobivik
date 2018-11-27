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


// SettingsScreen
class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Retrieve Text Input',
      home: SettingsForm(),
    );
  }

}

class SettingsForm extends StatefulWidget {
  @override
  _SettingsFormState createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {
  // Create a text controller. We will use it to retrieve the current value
  // of the TextField!
  final controllerServerAddress = TextEditingController();

  @override
  void initState() {
    super.initState();

    // controllerServerAddress.addListener(_printServerAddress);
    getSharedPrefs();

  }

  Future<Null> getSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var _name = prefs.getString("serverAddress");
    setState(() {
      controllerServerAddress.text = _name;
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is removed from the Widget tree
    // This also removes the _printLatestValue listener
    controllerServerAddress.dispose();
    super.dispose();
  }

  _printServerAddress() async{
    print("Second text field: ${controllerServerAddress.text}");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    controllerServerAddress.text = prefs.getString("serverAddress");
  }

  void saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("serverAddress", controllerServerAddress.text);
    print("saveData: ${controllerServerAddress.text}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Настройки'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              onChanged: (text) {
                print("First text field: $text");
              },
            ),
            TextField(
              controller: controllerServerAddress,
            ),

            RaisedButton(
              onPressed: saveData,
              child: Text('Сохранить'),
            ),
            RaisedButton(
              onPressed: (){Navigator.pop(context);},
              child: Text('Cancel'),
            ),
          ],

        ),

      ),

    );
  }
}
// \SettingsScreen

/*class SettingsScreen extends StatelessWidget {

  TextEditingController _controller;
  String serverAddress;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text("Settings"),),
      body: new Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
           padding: EdgeInsets.all(10.0), 
           child: new TextField(
              decoration: InputDecoration(labelText: 'Server address:' ),
              onChanged: (String str) {serverAddress = str;},
              controller: _controller,
           ),
          ),
          RaisedButton(
            onPressed: saveData,
            child: Text('Сохранить'),
          ),
        ],

      ) ,
    );

  }

  @override
  initState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _controller = new TextEditingController(text: prefs.getString("name"));
  }

  void saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("serverAddress", serverAddress);
    
  }
}*/

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
