import 'dart:async';
import 'package:rxdart/rxdart.dart';
import '../models/item_model.dart';
import '../resources/repository.dart';


class CommentsBloc {
  final _repository = Repository();
  final _commentsFetcher = PublishSubject<int>();
  final _commenstOutput = BehaviorSubject<Map<int,Future<ItemModel>>>();

  //Streams getters

  Observable<Map<int,Future<ItemModel>>> get itemWithComments {
   return _commenstOutput.stream;
  }

  //Sink getters

  Function(int) get fetchItemWithComments{
    return  _commentsFetcher.sink.add;
  }


  CommentsBloc(){
    _commentsFetcher.stream.transform(_commentsTransformer())
    .pipe(_commenstOutput);
  }

  _commentsTransformer(){
    return ScanStreamTransformer<int, Map<int,Future<ItemModel>>>(
      (cache, int id, index){
          //print(index);
          cache[id] = _repository.fetchItem(id);
          cache[id].then((ItemModel item){
              item.kids.forEach((kidId) => fetchItemWithComments(kidId));
              
          });
        return cache;
      },
      <int,Future<ItemModel>>{},
    );
  }


  dispose(){
    _commentsFetcher.close();
    _commenstOutput.close();
  }



}