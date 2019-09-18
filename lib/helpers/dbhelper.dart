import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

final String tableRoute = 'route';
final String columnId = '_id';
final String columnOutletName = 'outletname';
final String columnAddress = 'address';
final String columnDone = 'done';

class Outlet {
  int id;
  String outletname;
  String address;
  bool done;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnOutletName: outletname,
      columnAddress: address,
      columnDone: done == true ? 1 : 0
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  Outlet();

  Outlet.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    outletname = map[columnOutletName];
    address = map[columnAddress];
    done = map[columnDone] == 1;
  }
}

class DatabaseProvider {
  Database db;




  Future open() async {

    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'mobiviker.db');

    print("path=$path");

    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
          await db.execute('''
            create table $tableRoute ( 
              $columnId integer primary key autoincrement, 
              $columnOutletName text,
              $columnAddress text,
              $columnDone integer not null)
            '''
          );
        });
  }

  Future<Outlet> insertOutlet(Outlet outlet) async {
    outlet.id = await db.insert(tableRoute, outlet.toMap());
    return outlet;
  }

  Future<Outlet> getOutlet(int id) async {
    List<Map> maps = await db.query(tableRoute,
        columns: [columnId, columnDone, columnOutletName, columnAddress],
        where: '$columnId = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return Outlet.fromMap(maps.first);
    }
    return null;
  }

  Future<int> deleteRoute(int id) async {
    return await db.delete(tableRoute, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> updateOutlet(Outlet outlet) async {
    return await db.update(tableRoute, outlet.toMap(),
        where: '$columnId = ?', whereArgs: [outlet.id]);
  }

  Future close() async => db.close();
}


