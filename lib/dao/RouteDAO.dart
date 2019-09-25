import 'dart:convert';
import 'dart:io';

import 'package:mobivik/common/cp1251Decoder.dart';
import 'package:mobivik/models/client_model.dart';
import 'package:path_provider/path_provider.dart';


class RouteDAO {

  Future<List> getItems() async {
    List<Client> result = List<Client>();
    String path = await _localPath;
    print("path = $path");

    //try {
      final file = new File(path + Platform.pathSeparator + "route.mv");
      List<int> bytes = await file.readAsBytes();
      String fileContent = decodeCp1251(bytes);
      final parsedJson = json.decode(fileContent);

      for(Map client in parsedJson){
        result.add(Client.fromJson(client));
      }

    //} catch (e){print("Еxception in route loading = $e");}

    //List<Client> result = Client.fromJson(jsonResponse);
    return result;
  }

  Future<String> get _localPath async {
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;

    return tempPath;
  }


}

