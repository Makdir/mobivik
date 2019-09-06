import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mobivik/models/Client.dart';
import 'package:path_provider/path_provider.dart';

class GoodsScreen extends StatefulWidget {
  @override
  _GoodsScreenState createState() {
    return _GoodsScreenState();
  }

}

class _GoodsScreenState extends State {
  List<Client> goods = List();

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future getData() async{

    List<Client> routeList = await GoodsDAO().getItems();
    //List<dynamic> jsonData = json.decode(textData);

    setState(() {
      goods.addAll(routeList);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(title: new Text("Товары")),
        body:ListView.builder()
    );
}
}

class GoodsDAO {
  Future<List> getItems() async {
    List<Client> result = List<Client>();
    String path = await _localPath;
    print("path = $path");

    try {
      final file = new File(path + Platform.pathSeparator + "route.mv");
      String fileContent = await file.readAsString();
      final parsedJson = json.decode(fileContent);

      for(Map client in parsedJson){
        result.add(Client.fromJson(client));
      }

    } catch (e){print("Еxception in route loading = $e");}

    //List<Client> result = Client.fromJson(jsonResponse);
    return result;
  }

  Future<String> get _localPath async {
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;

    return tempPath;
  }
}