import 'dart:convert';
import 'dart:io';

import 'package:mobivik/models/client_model.dart';
import 'package:mobivik/common/file_provider.dart';


class RouteDAO {

  Future<List> getItems() async {
    List<Client> result = [];
    try {
      final File file = await FileProvider.openInputFile("route");
      String fileContent = await file.readAsString();
      final parsedJson = json.decode(fileContent);
      for(Map client in parsedJson){
        result.add(Client.fromJson(client));
      }

    } catch (e){print("Еxception in route loading = $e");}
    return result;
  }


}

