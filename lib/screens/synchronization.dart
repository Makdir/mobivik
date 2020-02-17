import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobivik/common/file_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_permissions/simple_permissions.dart';


class SyncScreen extends StatelessWidget {

  Permission permission;
  String result;


  @override
  Widget build(BuildContext context) {

    return Scaffold(

        appBar: AppBar(title: const Text("Синхронизация"),),
        body: Center(
          child: Column(

            children: [
              RaisedButton(
                onPressed: _fetchPost,
                child: const Text('Синхронизировать'),
                ),

            ]
          ),
        )
    );
  }

  Future<Null> _fetchPost() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    final serverAddress = prefs.getString("serverAddress").trim();
    final agentCode = prefs.getString("agentCode").trim();

    await _getSettings(serverAddress, agentCode);

    await _getData("goods", serverAddress, agentCode);
    await _getData("route", serverAddress, agentCode);

    await _sendPayments(serverAddress, agentCode);

  }

  Future parseResponseBody(String body) async{

    if(body.isEmpty) return;
    //File file = writeFile(body);
    Map<String,dynamic> jsonBody = json.decode(body);
    //print(jsonBody);
    //print(jsonBody["outlets"]);
    //print(jsonBody["outlets"].runtimeType);

    bool res = await SimplePermissions.checkPermission(Permission.WriteExternalStorage);
    print('res = $res');
    var permissionStatus;
    if(res==false){permissionStatus = SimplePermissions.requestPermission(Permission.WriteExternalStorage);};


  }

  _getData(String command, String serverAddress, String agentCode) async{

    //"http://10.0.2.2:8080";
    String uri = "http://" + serverAddress.trim() + "/" + command.trim();
    var client = http.Client();

    try {
      var response = await client.get(uri,
          headers: {
            "agent-code": agentCode
          }
      ); //_digest.toString()
      //print("Response status: ${response.statusCode}");
      var responseStatusCode = response.statusCode;

      if(responseStatusCode == 200) {
        print("${uri} Response body: ${response.body}");
        FileProvider.saveInputFile(command, response.body);
      }
    } catch (e) {
      print(e);
    } finally {
      client.close();
    }

  }

  _sendPayments(String serverAddress, String agentCode) async{

    String uri = "http://" + serverAddress.trim() + "/payments" ;
    var body = _preparePayments();

    var client = http.Client();

    try {
      var response = await client.post(uri,
          body: body,
          headers: {
            "agent-code": agentCode
          }
      );
      var responseStatusCode = response.statusCode;

      if(responseStatusCode == 200) {
        print("payments Response body: ${response.body}");
        //FileProvider.saveInputFile("route", response.body);
      }
    } catch (e) {
      print(e);
    } finally {
      client.close();
    }


  }

  _preparePayments() async {
      // TODO delete zero values in payments
      File file =  await FileProvider.openOutputFile("payments");
      String result = await file.readAsString();
      if (result.isEmpty) result = "{}";
      return result;
  }

  _getSettings(String serverAddress, String agentCode) {


  }

}




