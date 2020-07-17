import 'package:first_laboratory/domain/TShirt.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

final String tableTShirts = 'TShirts';
final String columnId = 'id';
final String columnBand = 'band';
final String columnColor = 'color';
final String columnSize = 'size';
final String columnCurrency = 'currency';
final String columnPrice = 'price';

class DBHelper{
  Database _db;

  Future<Database> get db async {
    if (_db != null) return _db;
    var p = await getDatabasesPath();
    String path = p + "/rock_tshirts_v3.db";
    _db = await open(path);
    return _db;
  }

  open(String path) async {
    var d = await openDatabase(path, version: 3,
        onCreate: (Database db, int version) async {
          await db.execute('''
          create table $tableTShirts ( 
            $columnId integer primary key, 
            $columnBand text,
            $columnColor text,
            $columnSize text,
            $columnCurrency text,
            $columnPrice integer)
          ''');
        });
    return d;
  }

  Future<TShirt> insert(TShirt t) async {
    var dbClient = await db;
    t.id = await dbClient.insert(tableTShirts, t.toMapBD());
    return t;
  }

  Future<List<TShirt>> getItems() async {
    var dbClient = await db;
    var result = await dbClient.rawQuery("SELECT * FROM $tableTShirts");

    return List.generate(result.length, (i) {
      return TShirt(
        result[i]['id'],
        result[i]['band'],
        result[i]['color'],
        result[i]['size'],
        result[i]['price'],
        result[i]['currency']
      );
    });
  }

  Future<TShirt> getItem(int id) async {
    var dbClient = await db;
    var result = await dbClient.rawQuery("SELECT * FROM $tableTShirts where $columnId = $id");
    return TShirt(
        result[0]['id'],
        result[0]['band'],
        result[0]['color'],
        result[0]['size'],
        result[0]['price'],
        result[0]['currency']
    );
  }

  Future<int> delete(int id) async {
    var dbClient = await db;
    return await dbClient.delete(tableTShirts,
        where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> update(int id, TShirt t) async {
    var dbClient = await db;
    return await dbClient.update(tableTShirts, t.toMapBD(),
        where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> getCount() async {
    var dbClient = await db;
    List<Map<String, dynamic>> x = await dbClient.rawQuery('SELECT COUNT (*) from $tableTShirts');
    int result = Sqflite.firstIntValue(x);
    return result;
  }
}