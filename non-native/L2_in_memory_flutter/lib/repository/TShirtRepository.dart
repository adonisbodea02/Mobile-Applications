import 'package:first_laboratory/DBHelper.dart';
import 'package:first_laboratory/domain/TShirt.dart';

class TShirtRepository{

  DBHelper _databaseHelper;

  static final _repository = TShirtRepository._internal();

  TShirtRepository._internal(){
    this._databaseHelper = new DBHelper();

//    _tshirts.add(TShirt(-1, "Metallica", "Black", "M", 150, "Ron"));
//    _tshirts.add(TShirt(-2, "Dirty Shirt", "Green", "L", 60, "Ron"));
//    _tshirts.add(TShirt(-3, "Nirvana", "White", "M", 10, "Euro"));
//    _tshirts.add(TShirt(-4, "Guns'n'Roses", "Grey", "M", 100, "Ron"));
//    _tshirts.add(TShirt(-5, "Aerosmith", "Black", "M", 20, "Dollar"));
//    _tshirts.add(TShirt(-6, "AC/DC", "Grey", "M", 80, "Ron"));
//    _tshirts.add(TShirt(-7, "Green Day", "Black", "M", 40, "Euro"));
  }

  factory TShirtRepository(){
    return _repository;
  }

  Future<TShirt> addTShirt(TShirt t){
    return _databaseHelper.insert(t);
  }

  Future<List<TShirt>> getTShirts(){
    return _databaseHelper.getItems();
  }

  Future<TShirt> getTShirt(int id){
    return _databaseHelper.getItem(id);
  }

  Future<int> deleteTShirt(int id){
    return _databaseHelper.delete(id);
  }

  Future<int> editTShirt(int id, TShirt newTShirt){
    return _databaseHelper.update(id, newTShirt);
  }

  Future<int> getCount(){
    return _databaseHelper.getCount();
  }
}