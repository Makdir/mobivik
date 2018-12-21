import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Create a text controller. We will use it to retrieve the current value
  // of the TextField!
  final controllerServerAddress = TextEditingController();
  final controllerApplicationDataPath = TextEditingController();

  @override
  void initState() {
    super.initState();

    // controllerServerAddress.addListener(_printServerAddress);
    getSavedSettings();

  }

  Future<Null> getSavedSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var serverAddress = prefs.getString("serverAddress");
    var applicationDataPath = prefs.getString("applicationDataPath");

    setState(() {
      controllerServerAddress.text = serverAddress;
      controllerApplicationDataPath.text = applicationDataPath;
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
    prefs.setString("serverAddress",       controllerServerAddress.text);
    prefs.setString("applicationDataPath", controllerApplicationDataPath.text);
    //print("saveData: ${controllerServerAddress.text}");
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
              decoration: InputDecoration(labelText: 'Server address:' ),
              controller: controllerServerAddress,
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Application data path:' ),
              controller: controllerApplicationDataPath,
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
