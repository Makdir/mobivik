import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobivik/common/user_interface.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Create a text controller. We will use it to retrieve the current value
  // of the TextField!
  final controllerServerAddress = TextEditingController();
  final controllerAgentCode = TextEditingController();

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    // controllerServerAddress.addListener(_printServerAddress);
    getSavedSettings();

  }

  Future<Null> getSavedSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final _serverAddress = prefs.getString("serverAddress");
    final _agentCode = prefs.getString("agentCode");

    setState(() {
      controllerServerAddress.text = _serverAddress;
      controllerAgentCode.text = _agentCode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
            RaisedButton(
              onPressed: _testConnection,
              child: Text('Test connection'),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Agent code:' ),
              controller: controllerAgentCode,
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children:[
                  RaisedButton(
                    onPressed: _saveData,
                    child: Text('Save'),
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

  _testConnection() async {
    String requestURL = "http://" + controllerServerAddress.text.trim()+"/test";
    print("requestURL = $requestURL");
    var response;
    try {
       response = await http.get(
              requestURL,
              headers: {'agent-code':controllerAgentCode.text.trim()}
          );
    } catch (e) {
      GraphicalUI.showSnackBar(scaffoldKey: _scaffoldKey, context: context, actionLabel:"Close settings", resultMessage: "Error: ${e.toString()}");
    }
//    print("Response status: ${response.statusCode}");
//    print("Response body: ${response.body}");
    var statusCode = response.statusCode;
    if (statusCode == 200) {
      GraphicalUI.showSnackBar(scaffoldKey: _scaffoldKey, context: context, actionLabel:"Close settings", resultMessage: "Test successful!");
    }
    else{
      GraphicalUI.showSnackBar(scaffoldKey: _scaffoldKey, context: context, actionLabel:"Close settings", resultMessage: "Error from server. Status code $statusCode.");
    }

  }

  _saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("serverAddress", controllerServerAddress.text);
    prefs.setString("agentCode",     controllerAgentCode.text);

    GraphicalUI.showSnackBar(scaffoldKey: _scaffoldKey, context: context, actionLabel:"Close settings", resultMessage: "Settings was saved");
  }
}
