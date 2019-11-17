import 'dart:io';

import 'package:path_provider/path_provider.dart';
//import 'package:shared_preferences/shared_preferences.dart';


class FileProvider {

  static openOutputFile(String fileName) async{
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

  static openInputFile(String fileName) async{
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;

    Directory dir = Directory(tempPath+Platform.pathSeparator+"input");
    bool isExist = await dir.exists();
    if (isExist==false) {
      await dir.create(recursive: true);
    }

    File outputFile = new File(dir.path+Platform.pathSeparator+"$fileName.mv");

    isExist = await outputFile.exists();
    if (isExist==false) {
      await outputFile.create(recursive: true);
    }
    return outputFile;
  }

  static saveInputFile(String fileName, String content) async{
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;

    Directory inputDir = Directory(tempPath+Platform.pathSeparator+"input");
    bool isExist = await inputDir.exists();
    if (isExist==false) {
      await inputDir.create(recursive: true);
    }

    File inputFile = File(inputDir.path+Platform.pathSeparator+"$fileName.mv");

    isExist = await inputFile.exists();
    if (isExist==false) {
      await inputFile.create(recursive: true);
    }

    inputFile.writeAsString(content);

    return inputFile;
  }


}

