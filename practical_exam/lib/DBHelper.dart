import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

import 'Order.dart';



final String tableOrders = 'Orders';
final String columnId = 'id';
final String columnTable = 'tableOrder';
final String columnDetails = 'details';
final String columnType = 'type';
final String columnStatus = 'status';
final String columnTime = 'time';

class DBHelper{
  Database _db;

  Future<Database> get db async {
    if (_db != null) return _db;
    var p = await getDatabasesPath();
    String path = p + "/orders_v2.db";
    _db = await open(path);
    return _db;
  }

  open(String path) async {
    var d = await openDatabase(path, version: 2,
        onCreate: (Database db, int version) async {
          await db.execute('''
          create table $tableOrders ( 
            $columnId integer primary key, 
            $columnTable text,
            $columnDetails text,
            $columnType text,
            $columnTime integer,
            $columnStatus text
            )
          ''');
        });
    return d;
  }

  Future<Order> insertOrder(Order p) async {
    print("insert order DB");
    var dbClient = await db;
    p.id = await dbClient.insert(tableOrders, p.toMapBD());
    return p;
  }


  Future<List<Order>> getOrders() async {
    print("get orders DB");
    var dbClient = await db;
    var result = await dbClient.rawQuery("SELECT * FROM $tableOrders");

    return List.generate(result.length, (i) {
      return Order(
          result[i]['id'],
          result[i]['tableOrder'],
          result[i]['details'],
          result[i]['type'],
          result[i]['time'],
          result[i]['status']
      );
    });
  }


  Future<Order> getOrder(int id) async {
    print("entered get Order DB");
    var dbClient = await db;
    var result = await dbClient.rawQuery("SELECT * FROM $tableOrders where $columnId = $id");
    return Order(
        result[0]['id'],
        result[0]['tableOrder'],
        result[0]['details'],
        result[0]['type'],
        result[0]['time'],
        result[0]['status']
    );
  }

  Future<int> deleteOrder(int id) async {
    var dbClient = await db;
    return await dbClient.delete(tableOrders,
        where: '$columnId = ?', whereArgs: [id]);
  }


  Future<int> getCount() async {
    var dbClient = await db;
    List<Map<String, dynamic>> x = await dbClient.rawQuery('SELECT COUNT (*) from $tableOrders');
    int result = Sqflite.firstIntValue(x);
    return result;
  }
}