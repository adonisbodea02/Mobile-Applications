import 'dart:convert';

import 'package:http/http.dart' as http;

import 'DBHelper.dart';
import 'Order.dart';
import 'Recipe.dart';

class ServerHelper{

  static ServerHelper _databaseHelper;
  String url = "http://10.0.2.2:2301";

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

    response = await http.get(url + '/orders');

    return response != null && (response.statusCode == 200 || response.response.statusCode == 304);
  }

  Future<http.Response> insert(Order p) async {
    print("entered insert order");
    var body = p.toMap();
    var response;
    response = await http.post(this.url + '/order', body: body);
    return response;
  }


  Future<List<Order>> getOrdersReady() async {
    print("entered get orders ready");
    final response = await http.get(this.url + "/orders");

    var productsMapList = await json.decode(response.body);

    var productsList = productsMapList as List;

    print("maplist as I got it: " + productsMapList.toString());

    for(int i = 0; i < productsList.length; i++){
      if(productsList[i]['time'] is String){
        productsList[i]['time'] = int.parse(productsList[i]['time']);
      }
    }

    return List.generate(productsMapList.length, (i) {
      return Order(
          productsMapList[i]['id'],
          productsMapList[i]['table'],
          productsMapList[i]['details'],
          productsMapList[i]['type'],
          productsMapList[i]['time'],
          productsMapList[i]['status']
      );
    });
  }


  Future<Order> getOrderDetails(int id) async {
    print("entered get order details");
    final response = await http.get(this.url + "/order/" + id.toString());

    var productsMapList = await json.decode(response.body);

    print("maplist as I got it: " + productsMapList.toString());

    if(productsMapList['time'] is String){
      productsMapList['time'] = int.parse(productsMapList['time']);}


    return Order(
          productsMapList['id'],
          productsMapList['table'],
          productsMapList['details'],
          productsMapList['type'],
          productsMapList['time'],
          productsMapList['status']
      );
  }

  Future<List<Order>> getOrdersRecorder() async {
    print("entered get orders recorded");
    final response = await http.get(this.url + "/recorded");

    var productsMapList = await json.decode(response.body);

    var productsList = productsMapList as List;

    print("maplist as I got it: " + productsMapList.toString());

    for(int i = 0; i < productsList.length; i++){
      if(productsList[i]['time'] is String){
        productsList[i]['time'] = int.parse(productsList[i]['time']);
      }
    }

    return List.generate(productsMapList.length, (i) {
      return Order(
          productsMapList[i]['id'],
          productsMapList[i]['table'],
          productsMapList[i]['details'],
          productsMapList[i]['type'],
          productsMapList[i]['time'],
          productsMapList[i]['status']
      );
    });
  }

  Future<http.Response> changeStatus(int id, String status) async {
    print("entered change status");
    var body = {'id': id.toString(), 'status': status};
    var response;
    response = await http.post(this.url + '/status', body: body);
    return response;
  }




}

