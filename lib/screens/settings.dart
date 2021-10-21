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
  final _controllerServerAddress = TextEditingController();
  final _controllerAgentCode = TextEditingController();
  final _controllerOrganization = TextEditingController();

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
    final _organization = prefs.getString("organization");

    setState(() {
      _controllerServerAddress.text = _serverAddress;
      _controllerAgentCode.text = _agentCode;
      _controllerOrganization.text = _organization;
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
              controller: _controllerServerAddress,
            ),
            RaisedButton(
              onPressed: _testConnection,
              child: Text('Test connection'),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Agent code:' ),
              controller: _controllerAgentCode,
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Organization:' ),
              controller: _controllerOrganization,
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
    String requestURL = "http://" + _controllerServerAddress.text.trim()+"/test";
    print("requestURL = $requestURL");
    var response;
    try {
       response = await http.get(
              requestURL,
              headers: {'agent-code':_controllerAgentCode.text.trim()}
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
    prefs.setString("serverAddress", _controllerServerAddress.text);
    prefs.setString("agentCode",     _controllerAgentCode.text);
    prefs.setString("organization",  _controllerOrganization.text.trim());

    GraphicalUI.showSnackBar(scaffoldKey: _scaffoldKey, context: context, actionLabel:"Close settings", resultMessage: "Settings was saved");
  }
}
