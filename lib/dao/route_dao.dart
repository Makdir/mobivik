import 'dart:convert';
import 'dart:io';

import 'package:mobivik/models/client_model.dart';
import 'package:mobivik/common/file_provider.dart';


class RouteDAO {

  Future<List> getItems() async {
    List<Client> result = List<Client>();


    try {
      final File file = await FileProvider.openInputFile("route");
      String fileContent = await file.readAsString();
      //print("------------fileContent = $fileContent");
      final parsedJson = json.decode(fileContent);
      print("------------parsedJson = $parsedJson");
      for(Map client in parsedJson){
        print("> client = $client");
        result.add(Client.fromJson(client));
      }

    } catch (e){print("Еxception in route loading = $e");}

    //List<Client> result = Client.fromJson(jsonResponse);
    return result;
  }


}

