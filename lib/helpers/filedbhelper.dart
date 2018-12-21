import 'dart:io';
import 'package:simple_permissions/simple_permissions.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


class FileDBHelper {

  Future saveStringToFile(var data, String fileName) async {
    final file = await _getLocalFile(fileName);

    // Write the file
    return file.writeAsString('$data');
  }

  Future saveRoute(Map outlet){

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

