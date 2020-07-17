import 'dart:convert';

import 'package:first_laboratory/DBHelper.dart';
import 'package:first_laboratory/domain/TShirt.dart';
import 'package:http/http.dart' as http;

class ServerHelper{

  static ServerHelper _databaseHelper;
  String url = "http://10.0.2.2:8000/TShirts/";

  ServerHelper._createInstance();
  DBHelper local = DBHelper();

  factory ServerHelper(){
    if (_databaseHelper == null) {
      _databaseHelper = ServerHelper
          ._createInstance();
    }
    return _databaseHelper;
  }

  Future<bool> isActive() async {
    var response;

    try {
      response = await http.get(url).timeout(const Duration(seconds: 3));
    } catch (e) {
      return false;
    }

    return response != null && response.statusCode == 200;
  }

  Future<http.Response> insert(TShirt t) async {
    var body = t.toMap();
    var response;
    //body.remove('id');
    try {
      response = await http.post(this.url, body: body).timeout(const Duration(seconds: 3));
    } catch (e) {
      return http.Response("error", 404);
    }
    return response;
  }

  Future<int> update(TShirt t) async {
    var response;
    try {
      response = await http.put(this.url + t.id.toString() + '/', body: t.toMap()).timeout(const Duration(seconds: 3));
    } catch (e) {
      return 404;
    }
    return response.statusCode;
  }

  Future<int> delete(String id) async {
    var response;
    try {
      response = await http.delete(this.url + id + '/').timeout(const Duration(seconds: 3));
    } catch (e) {
      return 404;
    }
    return response.statusCode;
  }

  Future<List<TShirt>> getItems() async {
    final response = await http.get(this.url);

    var tshirtsMapList = await json.decode(response.body);

    print("maplist as I got it: " + tshirtsMapList.toString());

    return List.generate(tshirtsMapList.length, (i) {
      return TShirt(
          tshirtsMapList[i]['id'],
          tshirtsMapList[i]['band'],
          tshirtsMapList[i]['color'],
          tshirtsMapList[i]['size'],
          tshirtsMapList[i]['price'],
          tshirtsMapList[i]['currency']
      );
    });
  }

  Future<List<TShirt>> synchronize() async{
    print("server  active");

    List<TShirt> localTShirts = await local.getItems();
    List<TShirt> serverTShirts = await this.getItems();
    for (TShirt localTShirt in localTShirts) {
      print(localTShirt);
      if (localTShirt.id < 0) {
        print("inserting to server: " + localTShirt.toString());
        await this.insert(localTShirt);
      }
      local.delete(localTShirt.id);
    }

    serverTShirts = await this.getItems();

    for (TShirt t in serverTShirts) {
      local.insert(t);
    }

    localTShirts = await local.getItems();

    print("sync finished");
    return Future(() => localTShirts);
  }

}

