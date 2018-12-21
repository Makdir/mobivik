import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:simple_permissions/simple_permissions.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobivik/helpers/filedbhelper.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SyncScreen extends StatelessWidget {
//  final Future<Post> post;
//  SyncScreen({Key key, this.post}) : super(key: key);
  Permission permission;
  String result;

  @override
  Widget build(BuildContext context) {

    return new Scaffold(

        appBar: new AppBar(title: new Text("Синхронизация"),),
        body: new Column(

          children: [
            RaisedButton(
              onPressed: fetchPost,
              child: const Text('Синхронизировать'),
              ),
/*            FutureBuilder<Post>(
              future: post,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                return Text(snapshot.data.title);
                } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
                }

                // By default, show a loading spinner
                return CircularProgressIndicator();
              },
            ),*/

          ]
        )
    );
  }

  Future<Null> fetchPost() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String serverAddress = prefs.getString("serverAddress").trim();

    var url = serverAddress+"/fromserver"; //"http://10.0.2.2:8080/fromserver";
    print(url);
    http.get(url, headers: {"agent-code": "600", "color": "blue"})
        .then((response) {
      var responseStatusCode = response.statusCode;
      print("Response status: ${responseStatusCode}");
      if(responseStatusCode==200) {
        var body = response.body;
        print("Response body: ${body}");
        parseResponseBody(body);
      }

    });
  }

  Future parseResponseBody(String body) async{

    if(body.isEmpty) return;
    //File file = writeFile(body);
    Map<String,dynamic> jsonBody = jsonDecode(body);
    print(jsonBody);
    print(jsonBody["outlets"]);


    bool res = await SimplePermissions.checkPermission(Permission.WriteExternalStorage);
    print('res = $res');
    var permissionStatus;
    if(res==false){permissionStatus = SimplePermissions.requestPermission(Permission.WriteExternalStorage);};

    print('permissionStatus = $permissionStatus');

    FileDBHelper fileDBHelper = new FileDBHelper();
    fileDBHelper.saveStringToFile(body, 'originput.mv');
    var outlets = jsonBody["outlets"];
    print(outlets);
    fileDBHelper.saveStringToFile(outlets, 'route.mv');

  }

}




