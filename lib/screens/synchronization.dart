import 'dart:async';
import 'dart:convert';
import 'dart:io';



import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobivik/common/file_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_permissions/simple_permissions.dart';


class SyncScreen extends StatelessWidget {
//  final Future<Post> post;
//  SyncScreen({Key key, this.post}) : super(key: key);

  Permission permission;
  String result;

  @override
  Widget build(BuildContext context) {

    return new Scaffold(

        appBar: AppBar(title: const Text("Синхронизация"),),
        body: Center(
          child: Column(

            children: [
              RaisedButton(
                onPressed: fetchPost,
                child: const Text('Синхронизировать'),
                ),

            ]
          ),
        )
    );
  }

  Future<Null> fetchPost() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    final serverAddress = prefs.getString("serverAddress").trim();
    final agentCode = prefs.getString("agentCode").trim();

    await getRoute(serverAddress, agentCode);
    await sendPayments(serverAddress, agentCode);

  }

  Future parseResponseBody(String body) async{

    if(body.isEmpty) return;
    //File file = writeFile(body);
    Map<String,dynamic> jsonBody = json.decode(body);
    print(jsonBody);
    print(jsonBody["outlets"]);
    print(jsonBody["outlets"].runtimeType);

    bool res = await SimplePermissions.checkPermission(Permission.WriteExternalStorage);
    print('res = $res');
    var permissionStatus;
    if(res==false){permissionStatus = SimplePermissions.requestPermission(Permission.WriteExternalStorage);};

    //print('permissionStatus = $permissionStatus');
    //List outlets = jsonBody["outlets"];

  }

  sendPayments(String serverAddress, String agentCode) async{
    String url = "http://" + serverAddress+"/payments"; //"http://10.0.2.2:8080/fromserver";
    String payments = await preparePayments();
    var queryParameters = {
      'p': payments
    };

    var uri = Uri.http(serverAddress, '/payments', queryParameters);

    print(uri);

    var response = await http.get(uri, headers: {"agent-code": agentCode});
    print("Response status: ${response.statusCode}");

//    http.get(url, headers: {"agent-code": agentCode})
//        .then((response) {
//            var responseStatusCode = response.statusCode;
//            print("Response status: ${responseStatusCode}");
//            var body = response.body;
//            print("Payments body : ${body}");
//            print("Payments url = ${response.request.url}");
//            if(responseStatusCode==200) {
//
//      }
//    }
//    );



  }

  getRoute(String serverAddress, String agentCode) async{
//    var url = serverAddress+"/route"; //"http://10.0.2.2:8080/fromserver";
//    //print(url);
//    http.get(url, headers: {"agent-code": agentCode})
//        .then((response) {
//      var responseStatusCode = response.statusCode;
//      print("Response status: ${responseStatusCode}");
//
//      if(responseStatusCode==200) {
//        var body = response.body;
//        //print("Response body: ${body}");
//        FileProvider.saveInputFile("route", body);
//
//        //file.writeAsString(body);
//        //parseResponseBody(body);
//
//      }
//
//    });

  }

  preparePayments() async {
      // TODO delete zero values in payments
      File file =  await FileProvider.openOutputFile("payments");
      String result = await file.readAsString();
      if (result.isEmpty) result = "{}";
      return result;
  }

}




