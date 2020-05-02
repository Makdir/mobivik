import 'dart:io';

import 'package:path_provider/path_provider.dart';
//import 'package:shared_preferences/shared_preferences.dart';


class FileProvider {

  static saveFile(String fileName, String content, String folder) async{
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;

    Directory directory = Directory(tempPath+Platform.pathSeparator+folder);
    bool isExist = await directory.exists();
    if (isExist==false) {
      await directory.create(recursive: true);
    }

    File file = File(directory.path+Platform.pathSeparator+"$fileName.mv");

    isExist = await file.exists();
    if (isExist==false) {
      await file.create(recursive: true);
    }

    file.writeAsString(content);

    return file;
  }

  static openFile(String fileName, String folder) async{
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;

    Directory directory = Directory(tempPath+Platform.pathSeparator + folder);
    bool isExist = await directory.exists();
    if (isExist==false) {
      await directory.create(recursive: true);
    }

    File file = File(directory.path+Platform.pathSeparator + "$fileName.mv");

    isExist = await file.exists();
    if (isExist==false) {
      await file.create(recursive: true);
    }
    return file;
  }

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

  static openAuxiliaryFile(String fileName) async{
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;

    Directory outputDir = Directory(tempPath+Platform.pathSeparator+"auxiliary");
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

  static saveAuxiliaryFile(String fileName, String content) async{
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;

    Directory directory = Directory(tempPath+Platform.pathSeparator+"auxiliary");
    bool isExist = await directory.exists();
    if (isExist==false) {
      await directory.create(recursive: true);
    }

    File file = File(directory.path+Platform.pathSeparator+"$fileName.mv");

    isExist = await file.exists();
    if (isExist==false) {
      await file.create(recursive: true);
    }

    file.writeAsString(content);

    return file;
  }

  static saveOutputFile(String fileName, String content) async{
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;

    Directory directory = Directory(tempPath+Platform.pathSeparator+"output");
    bool isExist = await directory.exists();
    if (isExist==false) {
      await directory.create(recursive: true);
    }

    File file = File(directory.path+Platform.pathSeparator+"$fileName.mv");

    isExist = await file.exists();
    if (isExist==false) {
      await file.create(recursive: true);
    }

    file.writeAsString(content);

    return file;
  }
}

