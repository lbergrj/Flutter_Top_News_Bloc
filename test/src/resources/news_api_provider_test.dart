import 'package:news/src/resources/news_api_provider.dart';
import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';

void main() {
  
  test('FetchTopIds return a list of Ids', () async{
    
    //Setup pf test case
    final newsApi = NewsApiProvider();
    newsApi.client = MockClient((request) async{
        return Response(json.encode([1,2,3,4]), 200);      
    });

    final ids = await newsApi.fetchTopIds();

    expect(ids,[1,2,3,4]);


    
  });

  test('FetchItem returns a item model',() async {

    final newsApi = NewsApiProvider();
    final jsonMap = {'id': 123};
    newsApi.client = MockClient((request) async{
        return Response(json.encode(jsonMap), 200);      
    });

    final item = await newsApi.fetchItem(123);
    print(item.type);
    
    expect(item.id,123);


    });


}
