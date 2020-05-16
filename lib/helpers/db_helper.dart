// import 'dart:io';

import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqlite_api.dart';

class DBHelper {

  static Future<Database> database () async {
    final dbPath = await sql.getDatabasesPath();
    print('database method in DBHELPER');

    return sql.openDatabase(
      path.join(dbPath, 'great_places.db'),
      onCreate: ( 
        db, 
        version 
        ) {        
        return db.execute(
          'CREATE TABLE user_places ( id TEXT PRIMARY KEY, title TEXT, imagePath TEXT );'
        );
      },
      version: 1
    );
  }

  static Future<void> insert(
    String table,
    Map<String, Object> data,    
  ) async {
    final db = await DBHelper.database();
    db.insert(
      table, 
      data,
      conflictAlgorithm: sql.ConflictAlgorithm.replace
    );
  }  // end of insert


  static Future<List<Map<String, dynamic>>> getData(String table) async {
    print('getData method in DBHELPER');
    final db = await DBHelper.database();
    return db.query(table);
  }
}


