import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';


class FileDBHelper {

  Future saveStringToFile(var data, String fileName) async {
    final file = await _getLocalFile(fileName);

    // Write the file
    return file.writeAsString('$data');
  }

  List getRoute() {
    List<Map> result;
    _localPath.then((path){
      final file = new File(path + "/route.mv");
      //print('file='+file.toString());
      String fileContent = file.readAsStringSync();
      print('fileContent='+fileContent);
      print('fileContent.split(new RegExp(r"{*}")='+fileContent.split(new RegExp(r"{*}")).toString());
//      result = fileContent.split(new RegExp(r"{*}"));
//      print('result='+result.toString());
    });

    return result;
  }

  Future<String> get _localPath async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var applicationDataPath = prefs.getString("applicationDataPath");

    return applicationDataPath;

//    final directory = await getApplicationDocumentsDirectory();
//    print(directory);
//    return directory.path;
  }

  Future<File> _getLocalFile(String fileName) async {
    final path = await _localPath;
    String fullPath = path + "/" + fileName;
    return File(fullPath);
  }


}

