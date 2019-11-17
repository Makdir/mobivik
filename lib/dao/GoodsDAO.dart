import 'dart:convert';
import 'dart:io';

import 'package:mobivik/common/cp1251_decoder.dart';
import 'package:mobivik/models/goods_model.dart';
import 'package:mobivik/common/file_provider.dart';
//import "package:charcode/charcode.dart";

class GoodsDAO{
  Future<List> getItems() async {
    List<Goods> result = List<Goods>();

    //TODO Permission to storage access
    try {
      final file = FileProvider.openInputFile("goods.mv");
      List<int> bytes = await file.readAsBytes();
      String fileContent = decodeCp1251(bytes);

      final parsedJson = json.decode(fileContent);

      for(Map item in parsedJson){
        result.add(Goods.fromJson(item));
      }

    } catch (e){print("Еxception in goods loading = $e");}


    //List<Client> result = Client.fromJson(jsonResponse);
    return result;
  }

}

//*************************************

