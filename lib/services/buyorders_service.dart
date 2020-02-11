import 'dart:convert';
import 'dart:io';

import 'package:mobivik/common/file_provider.dart';


class BuyOrders {

  static save(Map order) async {
    //print("payment=$payments");
    if(order.isEmpty) return;

    File openedFile = await FileProvider.openOutputFile('buyorders');
    String fileContent = await openedFile.readAsString();
    if(fileContent.isEmpty) fileContent = "[]";
    List ordersList = json.decode(fileContent);
    ordersList.removeWhere((item) => item["doc_id"] == order["doc_id"]);
    ordersList.add(order);
    String outputJson = json.encode(ordersList);
    openedFile.writeAsString(outputJson);
  }

  static saveHeader(Map header) async {
    //print("payment=$payments");
    if(header.isEmpty) return;

    File openedFile = await FileProvider.openAuxiliaryFile('boheaders');
    String fileContent = await openedFile.readAsString();
    if(fileContent.isEmpty) fileContent = "[]";
    List ordersList = json.decode(fileContent);
    ordersList.removeWhere((item) => item["doc_id"] == header["doc_id"]);
    ordersList.add(header);
    String outputJson = json.encode(ordersList);
    openedFile.writeAsString(outputJson);
  }

  static Future<List> getBuyorderHeaders() async {

    File openedFile = await FileProvider.openAuxiliaryFile('boheaders');
    String fileContent = await openedFile.readAsString();
    if(fileContent.isEmpty) fileContent = "[]";
    List buyordersList = json.decode(fileContent);
    return buyordersList;
  }

}

