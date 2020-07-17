import 'dart:convert';
//import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:first_laboratory/DBHelper.dart';
import 'package:first_laboratory/ServerHelper.dart';
import 'package:first_laboratory/addedit.dart';
import 'package:first_laboratory/domain/TShirt.dart';
import 'package:first_laboratory/service/TShirtService.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

void testDB() async{
  var databaseHelper = DBHelper();

  var t = TShirt(1, "metallica", "black", "S", 40, "euro");

  await databaseHelper.insert(t);

  var ts = databaseHelper.getItems();
  
  ts.asStream().forEach((t) => print(t));

  t.band = "AC/DC";

  await databaseHelper.update(t.id, t);

  ts = databaseHelper.getItems();

  ts.asStream().forEach((t) => print(t));

  await databaseHelper.delete(t.id);

  ts = databaseHelper.getItems();

  ts.asStream().forEach((t) => print(t));
}

void testServer() async{
  var server = ServerHelper();

  bool isActive = await server.isActive();

  print("Server is: " + isActive.toString());

  var ts = server.getItems();

  ts.asStream().forEach((t) => print(t));

  var t = TShirt(7, "metallica", "black", "S", 40, "euro");

//  var response = await server.insert(t);
//
//  print(response.body);
//
//  var obj = json.decode(response.body) as Map;
//
//  print(obj);
//
//  print(obj['id']);

  var status = await server.delete(t.id.toString());

  print(status);
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MetalHead Flutter',
      theme: ThemeData(

        primarySwatch: Colors.green,
      ),
      home: MyHomePage(title: 'MetalHead'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  MyHomePageState createState() => MyHomePageState();

}

class MyHomePageState extends State<MyHomePage> {
  TShirtService service = TShirtService();
  ServerHelper server = ServerHelper();
  List<TShirt> _list = <TShirt>[];
  //bool isActive = false;

  @override
  void initState() {
    super.initState();
    _readFromDb();
  }

  _readFromDb() async {
    List items = await service.getTShirts();
    print(items);
    setState(() {
      items.forEach((item) {
        this._list.add(item);
      });
    });
  }

  void deleteItem(int index) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (!(connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi)){
      showAlertDialog("Status", "Delete operation is not available offline!");
    }
    else{
      TShirt t = _list[index];
      int status = await server.delete(t.id.toString());
      int id = await service.deleteTShirt(t.id);
      if(status == 204 && id != null)
      {
        setState(() {
          _list.removeAt(index);
        });
      }
      else{
        showAlertDialog("Status", "Delete operation was not successfull!");
      }
    }
  }

  void addItem() {
    Navigator.push(context, MaterialPageRoute(
        builder: (context) => AddEdit(TShirt(-8, "Band", "Color", "Size", 0, "Currency"), false)))
        .then((t) async
            {
              var connectivityResult = await (Connectivity().checkConnectivity());
              if (!(connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi))
              {
                var id = await service.getCount();
                var a = t as TShirt;
                a.id = id * -1;
                a = await service.addTShirt(a);
                print(await service.getTShirts());
                if(a != null)
                {
                  setState((){
                  _list.add(a);})
                ;}
              }
              else{
                var response = await server.insert(t);
                if(response.statusCode != 201){
                  showAlertDialog("Status", "Add operation was unsuccessfull!");
                }
                else{
                  var a = t as TShirt;
                  var data = json.decode(response.body) as Map;
                  print(data);
                  a.id = data['id'];
                  a = await service.addTShirt(a);
                  print(await service.getTShirts());
                  if(a != null)
                  {
                    setState((){
                      _list.add(a);})
                    ;}

                }
              }
            });
  }

  void editItem(int index) async{
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (!(connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi)){
      showAlertDialog("Status", "Update operation is not available offline!");
    }
    else{
      Navigator.push(context, MaterialPageRoute(
          builder: (context) => AddEdit(_list[index], true)))
          .then((t) async
              {
                int status = await server.update(t);
                int id = await service.editTShirt(t.id, t);
                if(id != null && status == 200)
                {
                  setState((){
                    _list.removeAt(index);
                    _list.insert(index, t);
                  })
                ;}
                else{
                  showAlertDialog("Status", "Update operation was unsuccessfull!");
                }
              });
    }
  }

  void showAlertDialog(String title, String message) {

    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(
        context: context,
        builder: (_) => alertDialog
    );
  }

  void sync() async{
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi)
    {
      server.synchronize().then((ts) {
        setState(() {
          print(ts);
          this._list.clear();
          this._list.addAll(ts);
        });
        showAlertDialog("Status", "Sync done successfully!");
      });
    }
    else{
      showAlertDialog("Status", "Sync can not be done offline!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.refresh),
              onPressed: ()  {
                print("SYNCHING...");
                sync();
              }
          )
        ],
      ),
      body: ListView.builder(
        itemCount: _list.length,
        itemBuilder: (BuildContext context, int index) =>
            ListTile(title: Text(_list[index].toString()), onTap: () {
              editItem(index);
            },trailing: IconButton(icon: Icon(Icons.delete),onPressed: (){
              deleteItem(index);
              
            },),),

      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addItem,
        tooltip: 'Add',
        child: Icon(Icons.add),
      ),
    );
  }
}
