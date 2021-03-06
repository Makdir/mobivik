import 'dart:convert';
import 'dart:io';

import 'package:flutter/src/widgets/editable_text.dart';
import 'package:mobivik/common/file_provider.dart';
import 'package:mobivik/models/client_model.dart';


class Payments {

  static save(List payments) async {
    //print("payment=$payments");
    if(payments.isEmpty) return;

//    File openedFile = await FileProvider.openOutputFile('payments');
//    String fileContent = await openedFile.readAsString();
//    if(fileContent.isEmpty) fileContent = "{}";
//    Map parsedJson = json.decode(fileContent);
//    payments.forEach((entry){
//      parsedJson[entry["doc_id"]]=entry;
//
//    });
//    String outputJson = json.encode(parsedJson);
//    openedFile.writeAsString(outputJson);

    // TODO payments_db can be a single file for payments (data to export can be formed while synchronizing)
    File openedFile = await FileProvider.openAuxiliaryFile('payments_db');
    String fileContent = await openedFile.readAsString();
    if(fileContent.isEmpty) fileContent = "[]";
    List parsedJson = json.decode(fileContent);
    for (Map payment in payments){
      if(payment['sum']==0) continue;
      Map filedPayment = parsedJson.firstWhere((pay)=> pay['paydate']==payment['paydate'], orElse: ()=>null);
      print("filedPayment = $filedPayment");
      if (filedPayment != null) {
        parsedJson.remove(filedPayment);
        print("removed");
      }
      parsedJson.add(payment);
    }
    String outputJson = json.encode(parsedJson);
    openedFile.writeAsString(outputJson);



  }

  static Future<List> getHeaders() async {

    File openedFile = await FileProvider.openAuxiliaryFile('payments_db');
    String fileContent = await openedFile.readAsString();
    if(fileContent.isEmpty) fileContent = "[]";
    List headers = json.decode(fileContent);
    return headers;
  }

  static Future<Map> getById(String id) async {

    File openedFile = await FileProvider.openAuxiliaryFile('payments_db');
    String fileContent = await openedFile.readAsString();
    if(fileContent.isEmpty) return null;

    List paymentsList = json.decode(fileContent);
    Map payment;
    try {
      payment = paymentsList.firstWhere((item) => item["paydate"] == id);
    } catch(e) {
      return null;
    }

    return payment;
  }

  static Future<bool> deleteById(String id) async {

    File openedFile = await FileProvider.openAuxiliaryFile('payments_db');
    String fileContent = await openedFile.readAsString();
    if(fileContent.isEmpty) return null;

    List paymentsList = json.decode(fileContent);

    try {
      paymentsList.removeWhere((item) => item["paydate"] == id);
    } catch(e) {
      return false;
    }
    String outputJson = json.encode(paymentsList);
    openedFile.writeAsString(outputJson);

    return true;
  }

  static Future<Map<String, TextEditingController>> setPaymentControllers( Map<String, TextEditingController> controllers) async {

    File openedFile = await FileProvider.openAuxiliaryFile('payments_db');
    String fileContent = await openedFile.readAsString();
    if(fileContent.isEmpty) fileContent = "[]";
    List parsedJson = json.decode(fileContent);
    //print("parsedJson is " + parsedJson.runtimeType.toString());
    controllers.forEach((docId, controller){
      try {
        Map payment = parsedJson.firstWhere((item)=>item['doc_id']==docId);
        controller.text = payment['sum'].toString();

      } catch (e) {}

    });

    return controllers;
  }

//  }





}

