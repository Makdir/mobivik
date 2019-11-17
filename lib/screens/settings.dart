import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
    final serverAddress = prefs.getString("serverAddress");
    final agentCode = prefs.getString("agentCode");

    setState(() {
      controllerServerAddress.text = serverAddress;
      controllerAgentCode.text = agentCode;
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
              onPressed: testConnection,
              child: Text('Test connection'),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Agent code:' ),
              controller: controllerAgentCode,
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children:[
                  RaisedButton(
                    onPressed: saveData,
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

  testConnection() async {
    String requestURL = controllerServerAddress.text.trim()+"/test";
    print("requestURL = $requestURL");
    var response = await http.get(
        requestURL,
        headers: {'agent-code':controllerAgentCode.text.trim()}
    );
    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}");
  }

  saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("serverAddress", controllerServerAddress.text);
    prefs.setString("agentCode",     controllerAgentCode.text);

    final snackBar = SnackBar(
      content: const Text("Settings was saved"),
      elevation: 5,
      action: SnackBarAction(
        label: 'Close settings',
        onPressed: () {
          Navigator.pop(context);
        },

      ),
    );

    _scaffoldKey.currentState.showSnackBar(snackBar);

  }
}
