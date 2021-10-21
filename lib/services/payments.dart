import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:mobivik/common/file_provider.dart';

class Payments {

  static save(List payments) async {

    if(payments.isEmpty) return;

    // TODO payments_db can be a single file for payments (the data of export can be formed while synchronizing)
    File openedFile = await FileProvider.openAuxiliaryFile('payments_db');
    String fileContent = await openedFile.readAsString();
    if(fileContent.isEmpty) fileContent = "[]";
    List parsedJson = json.decode(fileContent);
    for (Map payment in payments){
      if(payment['sum']==0) continue;
      Map filedPayment = parsedJson.firstWhere((pay)=> pay['paydate']==payment['paydate'], orElse: ()=>null);
      if (filedPayment != null) {
        parsedJson.remove(filedPayment);
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
    controllers.forEach((docId, controller){
      try {
        Map payment = parsedJson.firstWhere((item)=>item['doc_id']==docId);
        controller.text = payment['sum'].toString();
      } catch (e) {}
    });

    return controllers;
  }
}

