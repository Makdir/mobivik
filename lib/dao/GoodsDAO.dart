import 'dart:convert';
import 'dart:io';

import 'package:mobivik/common/cp1251Decoder.dart';
import 'package:mobivik/models/goods_model.dart';
import 'package:path_provider/path_provider.dart';
//import "package:charcode/charcode.dart";

class GoodsDAO{
  Future<List> getItems() async {
    List<Goods> result = List<Goods>();
    String path = await _localPath;
    print("path = $path");
    //TODO Permission to storage access
    //try {
      final file = new File(path + Platform.pathSeparator + "goods.mv");
      List<int> bytes = await file.readAsBytes();
      String fileContent = decodeCp1251(bytes);

      final parsedJson = json.decode(fileContent);

      for(Map item in parsedJson){
        result.add(Goods.fromJson(item));
      }

    //} catch (e){print("Еxception in goods loading = $e");}


    //List<Client> result = Client.fromJson(jsonResponse);
    return result;
  }

  Future<String> get _localPath async {
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;

    return tempPath;
  }
}

//*************************************

