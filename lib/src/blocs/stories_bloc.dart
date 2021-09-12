import 'dart:async';
import 'package:rxdart/rxdart.dart';
import '../models/item_model.dart';
import '../resources/repository.dart';


/*
Usando RXDart temos
Subjects = StreamController
Observable = Stream
PublishSubject() = Tipo de Stream Controler
*/

class StoriesBloc{
  final _repository = Repository();  
  final _topIds = PublishSubject<List<int>>();
  
  //Stream Controller usada pela Clase rx.dart
  final _itemsOutput = BehaviorSubject<Map<int,Future<ItemModel>>>();
  final _itemsFetcher = PublishSubject<int>(); 
  
  Observable<List<int>> get topIds => _topIds.stream;

  Observable<Map<int,Future<ItemModel>>> get items => _itemsOutput.stream;
  //Getter to Sinks
   Function (int) get fetchItem => _itemsFetcher.sink.add;

   //pipe reencaminha a saida do stream de ItemsFetcher para itemOutput
   StoriesBloc(){
      _itemsFetcher.stream.transform(_itemsTransformers()).pipe(_itemsOutput);
  }
    

  fetchTopIds()async{
    final ids = await _repository.fetchTopIds();
    _topIds.sink.add(ids);
  }

  clearCache(){
    return _repository.clearCache();
  }


  
    /*
    O método ScanStreamTransformer da biblioteca rx.dart transforma 
    o stream de dados em um mapa (cache map)
    */
  _itemsTransformers(){
    return ScanStreamTransformer (
          (Map<int,Future<ItemModel>> cache, int id, index){
           //print(index);
           cache[id] = _repository.fetchItem(id);
           return cache;
        },
        <int,Future<ItemModel>>{},
    );
  }

  dispose(){
    _topIds.close();
    _itemsFetcher.close();
    _itemsOutput.close();
  }
  
}