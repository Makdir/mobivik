import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SyncScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(title: new Text("Синхронизация"),),
        body: new Column(


          children: [new RaisedButton(
              onPressed:(){fetchPost;},
              child: const Text('Синхронизировать'),
              ),
]
        )
    );
  }
  void syncButton(){

  }

  Future<http.Response> fetchPost() {
    return http.get('https://jsonplaceholder.typicode.com/posts/1');
  }

}