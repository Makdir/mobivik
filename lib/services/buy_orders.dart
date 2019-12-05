import 'dart:convert';
import 'dart:io';

import 'package:flutter/src/widgets/editable_text.dart';
import 'package:mobivik/common/cp1251_decoder.dart';
import 'package:mobivik/common/file_provider.dart';


class BuyOrders {

  static save(Map order) async {
    //print("payment=$payments");
    if(order.isEmpty) return;

    File openedFile = await FileProvider.openOutputFile('payments');
    String fileContent = await openedFile.readAsString();
    if(fileContent.isEmpty) fileContent = "{}";
    Map parsedJson = json.decode(fileContent);
    //print(" to ");
//    order.forEach((entry){
//      parsedJson[entry["doc_id"]]=entry;
//
//    });
    String outputJson = json.encode(parsedJson);

    openedFile.writeAsString(outputJson);
    //print("openedFile = " + openedFile.path);
    //var outputFile = FileProvider.saveFile('payments');
  }

  static Future<Map<String, TextEditingController>> setPayment( Map<String, TextEditingController> controllers) async {

    File openedFile = await FileProvider.openOutputFile('payments');
    String fileContent = await openedFile.readAsString();
    if(fileContent.isEmpty) fileContent = "{}";
    Map parsedJson = json.decode(fileContent);
    //print("parsedJson is " + parsedJson.runtimeType.toString());
    controllers.forEach((docId, controller){
      try {
        controller.text = parsedJson[docId]['sum'].toString();

      } catch (e) {}

    });

    return controllers;
  }

//  }





}

