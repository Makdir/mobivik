import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


class FileProvider {

  static openFile(String fileName) async{
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;

    Directory outputDir = Directory(tempPath+Platform.pathSeparator+"input");
    bool isExist = await outputDir.exists();
    if (isExist==false) {
      await outputDir.create(recursive: true);
    }

    File inputFile = new File(outputDir.path+Platform.pathSeparator+"$fileName.mv");

    isExist = await inputFile.exists();
    if (isExist==false) {
      await inputFile.create(recursive: true);
    }
    return inputFile;
  }

  static saveFile(String fileName) async{
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;

    Directory outputDir = Directory(tempPath+Platform.pathSeparator+"output");
    bool isExist = await outputDir.exists();
    if (isExist==false) {
      await outputDir.create(recursive: true);
    }

    File outputFile = new File(outputDir.path+Platform.pathSeparator+"$fileName.mv");

    isExist = await outputFile.exists();
    if (isExist==false) {
      await outputFile.create(recursive: true);
    }
    return outputFile;
  }


}

