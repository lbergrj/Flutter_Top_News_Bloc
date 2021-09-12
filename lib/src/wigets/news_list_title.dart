import 'dart:async';
import 'package:flutter/material.dart';
import '../models/item_model.dart';
import '../blocs/stories_provider.dart';
import 'loading_container.dart';

class NewsListTitle extends StatelessWidget{
  final int itemId;  
  NewsListTitle ({this.itemId});
   
  @override
  Widget build(BuildContext context) {    
    final bloc = StoriesProvider.of(context);
    return StreamBuilder(
      stream: bloc.items,
      builder: (context, AsyncSnapshot<Map <int, Future<ItemModel>>> snapshop){
        if(!snapshop.hasData){
          return LoadingContainer();
        }
        return FutureBuilder(
          future: snapshop.data[itemId],
          builder: (context, AsyncSnapshot<ItemModel> itemSnapshot){
            if(! itemSnapshot.hasData){
              return LoadingContainer();
            }
            return buildTitle(context,itemSnapshot.data);
          },
        );
      },
    );
  }
  
  
  Widget buildTitle(BuildContext context,ItemModel item){
    return Column(
      children: [
        ListTile( 
          onTap: (){
            Navigator.pushNamed( context, '/${item.id}');
          },
          title: Text(item.title),
          subtitle: Text(item.score.toString() + ' points'),
          trailing: Column(
            children: [
             Icon(Icons.comment),
              Text(item.descendants.toString()),
            ],
          ) ,
        ),
        Divider (
          height: 6.0,
        ),
      ],
    );
  } // pesquisar sobre ListTile em docs.flutter.io
  
}