import 'package:first_laboratory/service/TShirtService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'domain/TShirt.dart';

class AddEdit extends StatefulWidget {


  final TShirt t;
  final bool mode;

  const AddEdit(this.t, this.mode);

  @override
  State createState() {
    return AddEditState(t, mode);
  }
}

class AddEditState extends State<AddEdit>{
  TShirt t;
  bool edit;
  TextField bandText;
  TextField colorText;
  TextField sizeText;
  TextField priceText;
  TextField currencyText;
  TextEditingController bandController = TextEditingController();
  TextEditingController colorController = TextEditingController();
  TextEditingController sizeController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController currencyController = TextEditingController();
  RaisedButton addEditButton;
  TShirtService service = TShirtService();
  BuildContext context;
  State parent;

  AddEditState(TShirt t, bool mode) {
    this.t = t;
    this.edit = mode;
    bandText = TextField(
      controller: bandController,
    );
    colorText = TextField(
      controller: colorController,
    );
    sizeText = TextField(
      controller: sizeController,
    );
    priceText = TextField(
      controller: priceController,
        keyboardType: TextInputType.number
    );
    currencyText = TextField(
      controller: currencyController,
    );
    bandController.text = t.band;
    colorController.text = t.color;
    sizeController.text = t.size;
    priceController.text = t.price.toString();
    currencyController.text = t.currency;
    if (edit) {
      addEditButton = RaisedButton(
        onPressed: editAnnouncement,
        child: Text("Edit"),
      );
    } else {
      addEditButton = RaisedButton(
        onPressed: addAnnouncement,
        child: Text("Add"),
      );
    }
  }

  Widget _buildTiles(TShirt root) {
    return Scaffold(
        body: Container(
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[bandText, colorText, sizeText, priceText, currencyText, addEditButton],
            )));
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return _buildTiles(t);
  }

  addAnnouncement() {

    TShirt t = TShirt.withoutID(
        bandController.text,
        colorController.text,
        sizeController.text,
        int.parse(priceController.text),
        currencyController.text);
    Navigator.pop(context, t);
  }

  editAnnouncement() {

    TShirt t = TShirt(
        this.t.id,
        bandController.text,
        colorController.text,
        sizeController.text,
        int.parse(priceController.text),
        currencyController.text);

    print(t);
    Navigator.pop(context,t);
  }

}