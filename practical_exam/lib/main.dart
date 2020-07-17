import 'dart:convert';
//import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'ChangeOrder.dart';
import 'DBHelper.dart';
import 'Order.dart';
import 'ServerHelper.dart';
import 'ViewOrder.dart';
import 'add.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Market Flutter',
      theme: ThemeData(

        primarySwatch: Colors.green,
      ),
      home: HomePageWithWidget(),
    );
  }
}

class DrawerOnly extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return new Drawer(
        child: new ListView(
          children: <Widget>[
            new ListTile(
              title: new Text("Waiter"),
              onTap: (){
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => new WaiterPage(title: "Waiter")));
              },
            ),
            new ListTile(
              title: new Text("Kitchen"),
              onTap: (){
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => new KitchenPage(title: "Kitchen")));
              },
            ),
//            new ListTile(
//              title: new Text("Rate Recipes"),
//              onTap: (){
//                Navigator.pop(context);
//                Navigator.push(context, MaterialPageRoute(builder: (context) => new ClientPage(title: "Client")));
//              },
//            )
          ],
        )
    );
  }
}

class HomePageWithWidget extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      drawer: new DrawerOnly(),
      appBar: new AppBar(title: new Text("Restaurant App")),
      body: new Text("Welcome to the Restaurant App"),
    );
  }
}

class WaiterPage extends StatefulWidget{
  WaiterPage({Key key, this.title}) : super(key: key);

  final String title;
  final IOWebSocketChannel channel = IOWebSocketChannel.connect("ws://10.0.2.2:2301");

  @override
  WaiterPageState createState() => WaiterPageState(channel: channel);
}

class WaiterPageState extends State<WaiterPage>{

  final WebSocketChannel channel;
  ServerHelper server = ServerHelper();
  DBHelper dbHelper = DBHelper();
  List<Order> _list = <Order>[];
  //bool isActive = false;

  WaiterPageState({this.channel}) {
    channel.stream.listen((data) {
      setState(() {
        var d = jsonDecode(data);
        print(d.runtimeType.toString());
        //print(data);
        //Fluttertoast.showToast(msg: "New order was added: " + d['table'] + " type:" + d['type']);
        showAlertDialog("Update", "New order was added: " + d['table'] + " type:" + d['type']);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _readFromDB();
    if(_list.length == 0){
    _readFromServer();}
  }

  _readFromDB() async{
    List items = await dbHelper.getOrders();
    print(items);
    if(items.length > 0)
    {
      setState(() {
        items.forEach((item) {
          this._list.add(item);
        });
      });
    }
  }

  _readFromServer() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (!(connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi)){
    }
    else{
      List itemsBD = await dbHelper.getOrders();
      if(itemsBD.length == 0){
      List items = await server.getOrdersReady();
      print(items);
      if(_list.length == 0){
        setState(() {
          items.forEach((item) {
            this._list.add(item);
            if(itemsBD.length == 0)
              this.dbHelper.insertOrder(item);
          });
        });
      }
    }}
  }

  void sync () async{
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (!(connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi)){
      showAlertDialog("Update", "Sync is not availlable");
    }
    else{
     List items = await server.getOrdersReady();
     print(items);
     _list.clear();
     setState(() {
       items.forEach((item) {
         this._list.add(item);
       });
     });
    }
  }

  void viewOrder(int index) async{
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (!(connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi)){
      showAlertDialog("Status", "Operation is not available offline!");
    }
    else{
      Order response = await server.getOrderDetails(_list[index].id);
      Navigator.push(context, MaterialPageRoute(
          builder: (context) => ViewOrder(response)));
    }
  }

  void addOrder() async{


    Navigator.push(context, MaterialPageRoute(
        builder: (context) => Add(Order(-1, "table", "details", "type", 0,'status'))))
        .then((t) async
      {
        var connectivityResult = await (Connectivity().checkConnectivity());
        if (!(connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi)){
          var a = t as Order;
          a.id = _list.length * (-1);
          await dbHelper.insertOrder(a);
          setState((){
            _list.add(a);});
          }
        else{
        var response = await server.insert(t);
        if(response.statusCode != 200){
          showAlertDialog("Status", "Add operation was unsuccessfull!");
        }
        else{
          var a = t as Order;
          var data = json.decode(response.body) as Map;
          a.id = data['id'];
          await dbHelper.insertOrder(a);
          setState((){
            _list.add(a);})
          ;}
      }});
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: new DrawerOnly(),
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
      body: new Stack(
          children: <Widget>[
            ListView.builder(
                itemCount: _list.length,
                itemBuilder: (BuildContext context, int index) =>
                    ListTile(title: Text(_list[index].toString()),
                      onTap: (){viewOrder(index);},

                    )
            ),
          ]),
      floatingActionButton: FloatingActionButton(
        onPressed: (){addOrder();},
        tooltip: 'Add',
        child: Icon(Icons.add),
      ),
    );
  }

  @override
  void dispose() {
    widget.channel.sink.close();
    super.dispose();
  }

}

class KitchenPage extends StatefulWidget{

  KitchenPage({Key key, this.title}) : super(key: key);

  final String title;
  final IOWebSocketChannel channel = IOWebSocketChannel.connect("ws://10.0.2.2:2301");

  @override
  KitchenPageState createState() => KitchenPageState(channel: channel);
}

class KitchenPageState extends State<KitchenPage>{

  final WebSocketChannel channel;
  ServerHelper server = ServerHelper();
  List<Order> _list = <Order>[];

  KitchenPageState({this.channel}) {
    channel.stream.listen((data) {
      setState(() {
        var d = jsonDecode(data);
        print(d.runtimeType.toString());
        print(data);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _readFromServer();
  }


  _readFromServer() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (!(connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi)){
      showAlertDialog("Status", "Operation is not available offline!");
    }
    else{
      List items = await server.getOrdersRecorder();
      print(items);
      setState(() {
        items.forEach((item) {
          this._list.add(item);
        });
      });
    }
  }


  void changeOrder(int index) async{
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (!(connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi)){
      showAlertDialog("Status", "Operation is not available offline!");
    }
    else{
      Navigator.push(context, MaterialPageRoute(
          builder: (context) => ChangeOrder()))
          .then((t) async
      {
        var response = await server.changeStatus(_list[index].id, t);
        if(response.statusCode != 200){
          showAlertDialog("Status", "Operation was unsuccessfull!");
        }
        else{
          var data = json.decode(response.body) as Map;
          setState((){
            _list[index].status = data['status'];})
          ;}
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: new DrawerOnly(),
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
        ],
      ),
      body: ListView.builder(
          itemCount: _list.length,
          itemBuilder: (BuildContext context, int index) =>
              ListTile(title: Text(_list[index].toString()),
                onTap: (){changeOrder(index);},
                )
      ),
    );
  }

  @override
  void dispose() {
    widget.channel.sink.close();
    super.dispose();
  }
}

//class UserPage extends StatefulWidget{
//  UserPage({Key key, this.title}) : super(key: key);
//
//  final String title;
//  final IOWebSocketChannel channel = IOWebSocketChannel.connect("ws://10.0.2.2:2301");
//
//  @override
//  UserPageState createState() => UserPageState(channel: channel);
//}
//
//class UserPageState extends State<UserPage>{
//
//  final WebSocketChannel channel;
//  DBHelper dbHelper = DBHelper();
//  ServerHelper server = ServerHelper();
//
//
//  UserPageState({this.channel}) {
//    channel.stream.listen((data) {
//      setState(() {
//        var d = jsonDecode(data);
//        print(d.runtimeType.toString());
//        print(data);
//      });
//    });
//  }
//
//  @override
//  void initState() {
//    super.initState();
//  }
//
//
//
//  void showAlertDialog(String title, String message) {
//    AlertDialog alertDialog = AlertDialog(
//      title: Text(title),
//      content: Text(message),
//    );
//    showDialog(
//        context: context,
//        builder: (_) => alertDialog
//    );
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      drawer: new DrawerOnly(),
//      appBar: AppBar(
//        title: Text(widget.title),
//      ),
//      body: ListView.builder(
//          itemCount: _list.length,
//          itemBuilder: (BuildContext context, int index) =>
//              ListTile(title: Text(_list[index].toString()),
//                trailing: IconButton(icon: Icon(Icons.rate_review), onPressed: (){
//                  increaseRating(index);
//                },),)
//      ),
//    );
//  }
//
//  @override
//  void dispose() {
//    widget.channel.sink.close();
//    super.dispose();
//  }
//}