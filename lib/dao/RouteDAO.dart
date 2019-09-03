import 'dart:convert';
import 'dart:io';

import 'package:mobivik/models/Client.dart';
import 'package:path_provider/path_provider.dart';


class RouteDAO {

  Future<List> getRoute() async {
    List<Client> result = List<Client>();
    String path = await _localPath;
    print("path = $path");

    try {
      final file = new File(path + Platform.pathSeparator + "route.mv");
      String fileContent = await file.readAsString();
      final parsedJson = json.decode(fileContent);

      print("parsedJson = $parsedJson");
      for(Map client in parsedJson){
        result.add(Client.fromJson(client));
      }


      //result = parsedJson.map((i)=>Client.fromJson(i)).toList();
      print("1result = $result");
    } catch (e){print("exception = $e");}

    //List<Client> result = Client.fromJson(jsonResponse);
    return result;
  }

  Future<String> get _localPath async {
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;

    return tempPath;

//    SharedPreferences prefs = await SharedPreferences.getInstance();
//    var applicationDataPath = prefs.getString("applicationDataPath");
//
//    return applicationDataPath;

//    final directory = await getApplicationDocumentsDirectory();
//    print(directory);
//    return directory.path;
  }


}

