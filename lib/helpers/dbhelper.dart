import 'dart:async';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = new DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;
  static Database _db;

  Future<Database> get db async {
    if (_db != null) return _db;
    _db = await initDb();
    return _db;
  }

  DatabaseHelper.internal();

  initDb() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'mobivik.db');
    print('path=$path');
    var theDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    print('theDb=$theDb');
    return theDb;
  }

  void _onCreate(Database db, int version) async {
    // When creating the db, create the table
    await db.execute(
        "CREATE TABLE Route(id INTEGER PRIMARY KEY, outletname TEXT, address TEXT, debt TEXT)");
  }

  Future<int> deleteTable(String tableName) async {
    var database = await db;
    int res = await database.delete(tableName);
    return res;
  }

  Future<int> saveRoute(Map outlet) async {
    var dbClient = await db;
    int res = await dbClient.insert("Route", outlet);
    return res;
  }

  Future<List<Map>> getRoute() async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM Route');
    List<Map> outlets = new List();
    for (int i = 0; i < list.length; i++) {
      var outlet = Map();
      outlet["id"] =list[i]["id"];
      outlet["outletname"]=list[i]["outletname"];
      outlet["address"]=list[i]["address"];
      //user.setUserId(list[i]["id"]);
      outlets.add(outlet);
    }
    print(outlets.length);
    return outlets;
  }

  Future<int> deleteUsers(String id) async {
    var dbClient = await db;
    int res = await dbClient.rawDelete('DELETE FROM User WHERE id = ?', [id]);
    return res;
  }

  Future<bool> update(Map outlet) async {
    var dbClient = await db;
    int res =   await dbClient.update("Route", outlet,
        where: "id = ?", whereArgs: <int>[outlet["id"]]);
    return res > 0 ? true : false;
  }


}



