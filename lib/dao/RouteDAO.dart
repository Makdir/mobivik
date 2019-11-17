import 'dart:convert';
import 'dart:io';

import 'package:mobivik/common/cp1251_decoder.dart';
import 'package:mobivik/models/client_model.dart';
import 'package:mobivik/common/file_provider.dart';


class RouteDAO {

  Future<List> getItems() async {
    List<Client> result = List<Client>();
        //print("path = $path");
    print("----------------------------------------------");
    //try {
      final File file = await FileProvider.openInputFile("route");
      //List<int> bytes = await file.readAsBytes();
      //String fileContent = decodeCp1251(bytes);
      String fileContent = await file.readAsString();
      //print("fileContent = $fileContent");
      final parsedJson = json.decode(fileContent);

      for(Map client in parsedJson){
        result.add(Client.fromJson(client));
      }

    //} catch (e){print("Еxception in route loading = $e");}

    //List<Client> result = Client.fromJson(jsonResponse);
    return result;
  }


}

