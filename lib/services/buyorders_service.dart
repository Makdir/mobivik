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

  static Future<List> getBuyorders() async {

    File openedFile = await FileProvider.openOutputFile('buyorders');
    String fileContent = await openedFile.readAsString();
    if(fileContent.isEmpty) fileContent = "[]";
    List buyordersList = json.decode(fileContent);
    return buyordersList;
  }

  static Future<Map> getBuyorderById(String docId) async {

    File openedFile = await FileProvider.openOutputFile('buyorders');
    String fileContent = await openedFile.readAsString();
    if(fileContent.isEmpty) return null;

    List ordersList = json.decode(fileContent);
    Map buyorder;
    try {
      buyorder = ordersList.firstWhere((item) => item["doc_id"] == docId);
    } catch(e) {
      return null;
    }

    return buyorder;
  }

  static deleteBuyorderById(String docId) async {

//    List headers= await BuyOrders.getBuyorderHeaders();
//    headers.removeWhere((item)=>item['doc_id']==docId);
    File openedFile = await FileProvider.openAuxiliaryFile('boheaders');
    String fileContent = await openedFile.readAsString();
    if(fileContent.isEmpty) fileContent = "[]";
    List ordersList = json.decode(fileContent);
    ordersList.removeWhere((item) => item["doc_id"] == docId);
    String outputJson = json.encode(ordersList);
    openedFile.writeAsString(outputJson);


//    List buyorders = await BuyOrders.getBuyorders();
//    buyorders.removeWhere((item)=>item['doc_id']==docId);
    openedFile = await FileProvider.openOutputFile('buyorders');
    fileContent = await openedFile.readAsString();
    if(fileContent.isEmpty) fileContent = "[]";
    ordersList = json.decode(fileContent);
    ordersList.removeWhere((item) => item["doc_id"] == docId);
    outputJson = json.encode(ordersList);
    openedFile.writeAsString(outputJson);


  }

}

