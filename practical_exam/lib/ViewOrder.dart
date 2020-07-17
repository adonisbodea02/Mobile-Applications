import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Order.dart';


class ViewOrder extends StatefulWidget {

  final Order p;

  const ViewOrder(this.p);

  @override
  State createState() {
    return ViewOrderState(p);
  }
}

class ViewOrderState extends State<ViewOrder>{
  Order p;
  TextField tableText;
  TextField detailsText;
  TextField typeText;
  TextField timeText;
  TextField statusText;
  TextEditingController tableController = TextEditingController();
  TextEditingController detailsController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController statusController = TextEditingController();
  RaisedButton backButton;
  BuildContext context;
  State parent;

  ViewOrderState(Order p) {
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
    statusText = TextField(
      controller: statusController,
    );
    tableController.text = p.table;
    detailsController.text = p.details;
    typeController.text = p.type;
    timeController.text = p.time.toString();
    statusController.text = p.status;

    backButton = RaisedButton(
      onPressed: goBack,
      child: Text("Back"),
    );
  }

  Widget _buildTiles(Order root) {
    return Scaffold(
        body: Container(
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[tableText, detailsText, typeText, timeText, statusText, backButton],
            )));
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return _buildTiles(p);
  }

  goBack() {


    Navigator.pop(context);
  }

}