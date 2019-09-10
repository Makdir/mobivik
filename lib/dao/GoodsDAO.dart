import 'dart:convert';
import 'dart:io';

import 'package:mobivik/models/Goods.dart';
import 'package:path_provider/path_provider.dart';


class GoodsDAO{
  Future<List> getItems() async {
    List<Goods> result = List<Goods>();
    String path = await _localPath;
    print("path = $path");

    try {
      final file = new File(path + Platform.pathSeparator + "goods.mv");
      String fileContent = await file.readAsString();
      final parsedJson = json.decode(fileContent);

      for(Map item in parsedJson){
        result.add(Goods.fromJson(item));
      }

    } catch (e){print("Еxception in goods loading = $e");}

    //List<Client> result = Client.fromJson(jsonResponse);
    return result;
  }

  Future<String> get _localPath async {
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;

    return tempPath;
  }
}

