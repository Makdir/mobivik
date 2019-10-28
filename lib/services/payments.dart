import 'dart:convert';
import 'dart:io';

import 'package:mobivik/common/cp1251Decoder.dart';
import 'package:mobivik/common/file_provider.dart';


class Payments {

  Future<void> savePayments() async {


    FileProvider.saveFile('payments.mv');
  }



}

