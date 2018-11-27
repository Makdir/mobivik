import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    getSavedSettings();

  }

  Future<Null> getSavedSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var serverAddress = prefs.getString("serverAddress");
    setState(() {
      controllerServerAddress.text = serverAddress;
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is removed from the Widget tree
    // This also removes the _printLatestValue listener
    controllerServerAddress.dispose();
    super.dispose();
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
              decoration: InputDecoration(labelText: 'Server address:' ),
              controller: controllerServerAddress,
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children:[
                  RaisedButton(
                    onPressed: saveData,
                    child: Text('Сохранить'),
                  ),
                  RaisedButton(
                    onPressed: (){Navigator.pop(context);},
                    child: Text('Cancel'),
                  ),
            ]),
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