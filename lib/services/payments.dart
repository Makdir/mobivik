import 'dart:convert';
import 'dart:io';

import 'package:mobivik/common/cp1251Decoder.dart';
import 'package:mobivik/common/file_provider.dart';


class Payments {

  static savePayments(List payments) async {
    print("payment=$payments");
    if(payments.isEmpty) return;

    File openedFile = await FileProvider.openFile('payments.mv');
    String fileContent = await openedFile.readAsString();

    final parsedJson = json.decode(fileContent);
    print("parsedJson is " + parsedJson.runtimeType.toString());

    FileProvider.saveFile('payments.mv');
  }



}

