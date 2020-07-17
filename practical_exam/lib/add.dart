import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Order.dart';


class Add extends StatefulWidget {

  final Order p;

  const Add(this.p);

  @override
  State createState() {
    return AddState(p);
  }
}

class AddState extends State<Add>{
  Order p;
  TextField tableText;
  TextField detailsText;
  TextField typeText;
  TextField timeText;
  TextEditingController tableController = TextEditingController();
  TextEditingController detailsController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  RaisedButton addButton;
  BuildContext context;
  State parent;

  AddState(Order p) {
    this.p = p;

    tableText = TextField(
      controller: tableController,
    );
    detailsText = TextField(
      controller: detailsController,
    );
    typeText = TextField(
        controller: typeController,
    );
    timeText = TextField(
        controller: timeController,
        keyboardType: TextInputType.number
    );
    tableController.text = p.table;
    detailsController.text = p.details;
    typeController.text = p.type;
    timeController.text = p.time.toString();

    addButton = RaisedButton(
      onPressed: addProduct,
      child: Text("Add"),
    );
  }

  Widget _buildTiles(Order root) {
    return Scaffold(
        body: Container(
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[tableText, detailsText, typeText, timeText, addButton],
            )));
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return _buildTiles(p);
  }

  addProduct() {

    Order p = Order.withoutID(
        tableController.text,
        detailsController.text,
        typeController.text,
        int.parse(timeController.text),
        'recorded'
    );
    Navigator.pop(context, p);
  }

}