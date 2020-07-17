class Order{

  int id;
  String table;
  String details;
  String type;
  int time;
  String status;

  Order(int id, String name, String details, String type, int time, String rating){
    this.id = id;
    this.table = name;
    this.details = details;
    this.type = type;
    this.time = time;
    this.status = rating;
  }

  Order.withoutID (String name, String details, String type, int time, String rating){
    this.table = name;
    this.details = details;
    this.type = type;
    this.time = time;
    this.status = rating;
    this.id = null;
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["table"] = table;
    map["details"] = details;
    map['type'] = type;
    map['time'] = time.toString();
    map['status'] = status;
    if (id != null) {
      map["id"] = id.toString();
    }
    return map;
  }

  Map<String, dynamic> toMapBD() {
    var map = new Map<String, dynamic>();
    map["tableOrder"] = table;
    map["details"] = details;
    map['type'] = type;
    map['time'] = time;
    map['status'] = status;
    if (id != null) {
      map["id"] = id;
    }
    return map;
  }

  Order.map(dynamic obj) {
    this.id = obj["id"];
    this.table = obj["table"];
    this.details = obj["details"];
    this.type = obj["type"];
    this.time = int.parse(obj["time"]);
    this.status = obj["status"];
  }

  @override
  String toString() {
    return this.table + ' details: ' + this.details + ' type: ' + this.type;
  }
}