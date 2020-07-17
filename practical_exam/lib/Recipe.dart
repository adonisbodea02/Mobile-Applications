class Recipe{

  int id;
  String name;
  String details;
  String type;
  int time;
  int rating;

  Recipe(int id, String name, String details, String type, int time, int rating){
    this.id = id;
    this.name = name;
    this.details = details;
    this.type = type;
    this.time = time;
    this.rating = rating;
  }

  Recipe.withoutID (String name, String details, String type, int time, int rating){
    this.name = name;
    this.details = details;
    this.type = type;
    this.time = time;
    this.rating = rating;
    this.id = null;
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["name"] = name;
    map["details"] = details;
    map['type'] = type;
    map['time'] = time.toString();
    map['rating'] = rating.toString();
    if (id != null) {
      map["id"] = id.toString();
    }
    return map;
  }

  Map<String, dynamic> toMapBD() {
    var map = new Map<String, dynamic>();
    map["name"] = name;
    map["details"] = details;
    map['type'] = type;
    map['time'] = time;
    map['rating'] = rating;
    if (id != null) {
      map["id"] = id;
    }
    return map;
  }

  Recipe.map(dynamic obj) {
    this.id = obj["id"];
    this.name = obj["name"];
    this.details = obj["details"];
    this.type = obj["type"];
    this.time = int.parse(obj["time"]);
    this.rating = int.parse(obj["rating"]);
  }

  @override
  String toString() {
    return this.name + ' ' + ' rating ' + this.rating.toString() + ' type ' + this.type.toString();
  }
}