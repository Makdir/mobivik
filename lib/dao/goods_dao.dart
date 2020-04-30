import 'dart:convert';
import 'dart:io';

import 'package:mobivik/models/goods_model.dart';
import 'package:mobivik/common/file_provider.dart';

class GoodsDAO{
  Future<List> getItems() async {
    List<Goods> result = List<Goods>();

    //TODO Permission to storage access
    try {
      final File file = await FileProvider.openInputFile("goods");

      String fileContent = await file.readAsString();

      final parsedJson = json.decode(fileContent);

      for(Map item in parsedJson){
        result.add(Goods.fromJson(item));
      }
    } catch (e){print("Еxception in goods loading = $e");}

    return result;
  }
}

//*************************************

