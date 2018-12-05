import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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



    var url = "http://10.0.2.2:8080/fromserver";
    http.get(url, headers: {"agent-code": "600", "color": "blue"})
        .then((response) {
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");
    });

    //http.read("https://jsonplaceholder.typicode.com/posts/1").then(print);
  }

}


