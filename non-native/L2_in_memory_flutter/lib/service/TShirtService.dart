import 'package:first_laboratory/domain/TShirt.dart';
import 'package:first_laboratory/repository/TShirtRepository.dart';

class TShirtService{

  static final TShirtService _service = TShirtService._internal();

  TShirtRepository repository;

  factory TShirtService(){
    return _service;
  }

  TShirtService._internal(){
    repository = TShirtRepository();
  }


  Future<TShirt> addTShirt(TShirt t){
    return repository.addTShirt(t);
  }


  Future<int> deleteTShirt(int id){
    return repository.deleteTShirt(id);
  }

  Future<int> editTShirt(int id, TShirt t){
    return repository.editTShirt(id, t);
  }

  Future<TShirt> getTShirt(int id){
    return repository.getTShirt(id);
  }

  Future<List<TShirt>> getTShirts(){
    return repository.getTShirts();
  }

  Future<int> getCount(){
    return repository.getCount();
  }
}