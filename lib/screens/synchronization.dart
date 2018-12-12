import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

class SyncScreen extends StatelessWidget {
//  final Future<Post> post;
//  SyncScreen({Key key, this.post}) : super(key: key);

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

  void parseResponseBody(String body) {
    //File file = writeFile(body);
    var jsonBody = jsonDecode(body);
    if(body.isEmpty) return;
    createDB().then((database){

    });


  }

  Future createDB() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'mobivik.db');

    Database database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
          // When creating the db, create the table
          await db.execute('CREATE TABLE Route (id INTEGER PRIMARY KEY, name TEXT, debt INTEGER, num REAL)');
        });

    return database;
  }




//  Future<String> get _localPath async {
//    final directory = await getApplicationDocumentsDirectory();
//print(directory);
//    return directory.path;
//  }
//
//  Future<File> get _localFile async {
//    final path = await _localPath;
//    return File('$path/inputdata.mv');
//  }
//
//  Future<File> writeFile(String counter) async {
//    final file = await _localFile;
//
//    // Write the file
//    return file.writeAsString('$counter');
//  }

}


