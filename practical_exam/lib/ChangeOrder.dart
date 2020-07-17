import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Order.dart';


class ChangeOrder extends StatefulWidget {

  const ChangeOrder();

  @override
  State createState() {
    return ChangeOrderState();
  }
}

class ChangeOrderState extends State<ChangeOrder>{


  TextField statusText;
  TextEditingController statusController = TextEditingController();
  RaisedButton addButton;
  BuildContext context;
  State parent;

  ChangeOrderState() {


    statusText = TextField(
      controller: statusController,
    );

    statusController.text = "ready";

    addButton = RaisedButton(
      onPressed: addProduct,
      child: Text("Add"),
    );
  }

  Widget _buildTiles() {
    return Scaffold(
        body: Container(
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[statusText, addButton],
            )));
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return _buildTiles();
  }

  addProduct() {

    Navigator.pop(context, statusController.text);
  }

}