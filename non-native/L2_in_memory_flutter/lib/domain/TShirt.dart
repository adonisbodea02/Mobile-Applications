class TShirt{

  int id;
  String band;
  String color;
  String size;
  int price;
  String currency;

  TShirt(int id, String band, String color, String size, int price, String currency){
    this.id = id;
    this.band = band;
    this.color = color;
    this.size = size;
    this.price = price;
    this.currency = currency;
  }

  TShirt.withoutID (String band, String color, String size, int price, String currency){
    this.band = band;
    this.color = color;
    this.size = size;
    this.price = price;
    this.currency = currency;
    this.id = null;
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["band"] = band;
    map["color"] = color;
    map['size'] = size;
    map['price'] = price.toString();
    map['currency'] = currency;
    if (id != null) {
      map["id"] = id.toString();
    }
    return map;
  }

  Map<String, dynamic> toMapBD() {
    var map = new Map<String, dynamic>();
    map["band"] = band;
    map["color"] = color;
    map['size'] = size;
    map['price'] = price;
    map['currency'] = currency;
    if (id != null) {
      map["id"] = id;
    }
    return map;
  }

  TShirt.map(dynamic obj) {
    this.id = obj["id"];
    this.band = obj["band"];
    this.color = obj["color"];
    this.size = obj["size"];
    this.price = obj["price"];
    this.currency = obj["currency"];
  }

  @override
  String toString() {
    return this.band + ' ' + this.color + ' ' + this.size;
  }
}