import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:mobivik/common/file_provider.dart';
import 'package:mobivik/common/user_interface.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_permissions/simple_permissions.dart';


class SyncScreen extends StatefulWidget {

  @override
  _SyncScreen createState() {
    // TODO: implement createState
    return _SyncScreen();
  }



}

class _SyncScreen extends State {

  String workDateString; // work date in format YYYY-MM-DD
  double indicatorValue = 0.0;
  String progressMessage = '';
  String errorMessage = '';

  @override
  Widget build(BuildContext context) {

    return Scaffold(

        appBar: AppBar(title: const Text("Синхронизация"),),
        body: Center(
          child: Column(

            children: [
              StandardButton(caption: "Синхронизировать", onPressedAction: _executeSync),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Рабочая дата: ${DateFormat("dd.MM.yyyy").format(DateTime.now())}'),
              ),
              LinearProgressIndicator(value: indicatorValue, backgroundColor: Colors.black),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(progressMessage, style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),),
              ),
              Text(errorMessage, style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),),
            ]
          ),
        )
    );
  }

  _indicatorRefreshing(String message){
    setState(() {
      indicatorValue += 0.1;
      progressMessage = message;
    });
  }

  Future<Null> _executeSync() async {

    //String workDateIso8601String = DateTime.now().toIso8601String();
    workDateString = DateFormat("yyyy-MM-dd").format(DateTime.now());
    print('workDateString = $workDateString');

    SharedPreferences prefs = await SharedPreferences.getInstance();
    final serverAddress = prefs.getString("serverAddress").trim();
    final agentCode = prefs.getString("agentCode").trim();

    await _getSettings(serverAddress, agentCode);

    _indicatorRefreshing('Загрузка каталога товаров');
    await _getData("goods", serverAddress, agentCode);
    _indicatorRefreshing('Загрузка маршрута');
    await _getData("route", serverAddress, agentCode);

    _indicatorRefreshing('Подготовка данных');
    await _dataPreparing();

    _indicatorRefreshing('Отправка платежей');
    await _sendData('payments', serverAddress, agentCode);

    _indicatorRefreshing('Отправка заказов');
    await _sendData('buyorders', serverAddress, agentCode);

    setState(() {
      indicatorValue = 1.0;
      progressMessage = 'Обмен закончен.';
    });

  }

  _getSettings(String serverAddress, String agentCode) {

    //setState(() {indicatorValue = 0.1;});

  }


  Future parseResponseBody(String body) async{

    if(body.isEmpty) return;
    //File file = writeFile(body);
    Map<String,dynamic> jsonBody = json.decode(body);
    //print(jsonBody);
    //print(jsonBody["outlets"]);
    //print(jsonBody["outlets"].runtimeType);

    bool res = await SimplePermissions.checkPermission(Permission.WriteExternalStorage);
    print('res = $res');
    var permissionStatus;
    if(res==false){permissionStatus = SimplePermissions.requestPermission(Permission.WriteExternalStorage);};


  }

  _getData(String command, String serverAddress, String agentCode) async{

    //"http://10.0.2.2:8080";
    String uri = "http://" + serverAddress.trim() + "/" + command.trim();
    http.Client httpClient = http.Client();

    try {
      var response = await httpClient.get(uri,
          headers: {
            "agent-code": agentCode
          }
      ); //_digest.toString()
      //print("Response status: ${response.statusCode}");
      var responseStatusCode = response.statusCode;

      if(responseStatusCode == 200) {
        print('******************************************');
        print("${uri} Response body: ${response.body}");
        FileProvider.saveInputFile(command, response.body);
      }
      else{
        errorMessage = 'Ошибка соединения. Код статуса ответа = $responseStatusCode';
      }
    } catch (e) {
      print('--------------------------------------------');
      print(e);
      errorMessage = '$e';
    } finally {
      httpClient.close();
    }



  }

//  _sendPayments(String serverAddress, String agentCode) async{
//    String uri = "http://" + serverAddress.trim() + "/payments" ;
//    var body = _preparePayments();
//
//    var client = http.Client();
//
//    try {
//      var response = await client.post(uri,
//          body: body,
//          headers: {
//            "agent-code": agentCode
//          }
//      );
//      var responseStatusCode = response.statusCode;
//
//      if(responseStatusCode == 200) {
//        print("payments Response body: ${response.body}");
//        //FileProvider.saveInputFile("route", response.body);
//      }
//    } catch (e) {
//      print(e);
//    } finally {
//      client.close();
//    }
//  }

  _sendData(String dataType, String serverAddress, String agentCode) async{
    String uri = "http://" + serverAddress.trim() + Platform.pathSeparator + dataType;

    File file =  await FileProvider.openOutputFile(dataType);
    String body = await file.readAsString();
    if (body.isEmpty) body = "{}";
    //var body = _preparePayments();

    var client = http.Client();

    try {
      var response = await client.post(uri,
          body: body,
          headers: {
            "agent-code": agentCode
          }
      );
      var responseStatusCode = response.statusCode;

      if(responseStatusCode == 200) {
        print("$dataType response body is ${response.body}");
      }
    } catch (e) {
      print(e);
    } finally {
      client.close();
    }
  }

  _preparePayments() async {

      // Payments block
      File file =  await FileProvider.openOutputFile("payments");
      String content = await file.readAsString();
      if (content.isEmpty) {
        content = "{}";
        FileProvider.saveInputFile('payments', content);
        return;
      }

      Map payments = json.decode(content);
      List paymentsKeys = payments.keys.toList();
      int listSize = paymentsKeys.length;
      for(int i = 0; i < listSize; i++) {
        //paymentsKeys.forEach((key){
        String key = paymentsKeys[i];

        String payDate = payments[key]['paydate'];
        print('payDate = $payDate');
        if ((payDate == null)||(payDate.isEmpty)) {
          payments.remove(key);
          continue;
        }

        String paymentDate = DateFormat('yyyy-MM-dd').format(
            DateTime.parse(payDate));

        print('paymentDate = $paymentDate');
        print('workDateString.compareTo(paymentDate) = ${workDateString.compareTo(paymentDate)}');

        if (workDateString.compareTo(paymentDate) != 0) {
          payments.remove(key);
          continue;
        }

        var sum = payments[key]['sum'];
        if ((sum == 0) || (sum == '') || (sum is String)) {
          payments.remove(key);
          continue;
        }
      }
      String result = json.encode(payments);
      FileProvider.saveOutputFile('payments', result);

  }
  _prepareBuyOrders() async {

    File file =  await FileProvider.openOutputFile("buyorders");
    String content = await file.readAsString();
    if (content.isEmpty) {
      content = "[]";
      FileProvider.saveInputFile('buyorders', content);
      return;
    }

    List buyorders = json.decode(content);
    int listSize = buyorders.length;
    int i = 0;
    while( i < listSize ) {
      String docDate = buyorders[i]['doc_id'];
      String documentsDate = DateFormat('yyyy-MM-dd').format( DateTime.parse(docDate) );

      if (workDateString.compareTo(documentsDate) != 0) {
        buyorders.removeAt(i);
        listSize--;
        continue;
      }
      i++;
    }
    String result = json.encode(buyorders);
    FileProvider.saveFile('buyorders', result, 'output');



  }

  _fixBOHeaders() async {
    // Fixing headers for journal
    File file =  await FileProvider.openFile('boheaders', 'auxiliary');
    String content = await file.readAsString();
    if (content.isEmpty) {
      return;
    }

    List boheaders = json.decode(content);
    int listSize = boheaders.length;
    int i = 0;
    while( i < listSize ) {
      String docDate = boheaders[i]['doc_id'];
      String documentDate = DateFormat('yyyy-MM-dd').format( DateTime.parse(docDate) );

      if (workDateString.compareTo(documentDate) != 0) {
        boheaders.removeAt(i);
        listSize--;
        continue;
      }
      i++;
    }
    String result = json.encode(boheaders);
    FileProvider.saveFile('boheaders', result, 'auxiliary');

  }

  void _dataPreparing() async {
    await  _preparePayments();
    await  _prepareBuyOrders();
    await  _fixBOHeaders();
  }


}


