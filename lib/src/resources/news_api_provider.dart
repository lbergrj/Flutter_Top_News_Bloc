//Ncesessário dependencia http: any
import 'package:http/http.dart' show Client ;
import 'dart:convert';
import '../models/item_model.dart';
import 'repository.dart';

final root = 'https://hacker-news.firebaseio.com/v0';

class NewsApiProvider implements Source{  
  Client client =  Client();
  //Retorna Future pois o resultado á assincrono
  Future<List<int>> fetchTopIds() async{
    final response =  await client.get('$root/topstories.json');
    final ids =  json.decode(response.body);
    return ids.cast<int>();
  }

  Future<ItemModel> fetchItem(int id) async{
      final response = await client.get('$root/item/$id.json');
      final parsedJson = json.decode(response.body);
      //print('Teste $id');
      //print ('Item from API');
      return  ItemModel.fromJason(parsedJson);
  }


}