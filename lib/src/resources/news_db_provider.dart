import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'dart:async';
import '../models/item_model.dart';
import 'repository.dart';

class NewsDbProvider implements Source, Cache{

  Database db;

 
  NewsDbProvider(){
    init();
  }

   //Método não usado, apenas para classe implementar Source
  @override
  Future<List<int>> fetchTopIds() {
    return null;
  }

  void init() async{
    //Metodo para a criação do banco de dados
    var Directory = await getDatabasesPath();

    final path = join(Directory , "topnews.db");
   
    //await deleteDatabase(join(Directory ,path));
 

    String id = ' id ';
    String deleted = ' deleted ';
    String type  = ' type ';
    String by = ' by ';
    String time = ' time ';
    String text = ' text ';
    String parent  = ' parent ';
    String kids = ' kids ';
    String dead  = ' dead ';
    String url  = ' url ';
    String score  = ' score ';
    String title  = ' title ';
    String descendants  = ' descendants ';

    String query = 'CREATE TABLE Items ('+
            "$id INTEGER PRIMARY KEY, $type TEXT, $by TEXT, $time INTEGER, "+
            "$text TEXT, $parent INTEGER, $kids BLOB , $dead INTEGER, $deleted INTEGER, $url TEXT, "+
            "$score INTEGER, $title TEXT,  $descendants INTEGER)";

    db = await openDatabase(
      path,
      version: 1,
      onCreate: (Database newDb, int version ) async {
      print ('Query::::: ' + query);
        await newDb.execute( query );
      },
    );

  }



  //Método de leitura no banco de dados

  Future<ItemModel> fetchItem(int item_id) async{
    
    String id = ' id ';
    final  maps = await  db.query(
      "Items",
      columns: null,
      where: "$id = ?",
      whereArgs: [item_id],
    );
    
    if(maps.length > 0){
      //print('from DB');
      return ItemModel.fromDb(maps.first);
    }    
    return null; 
  }

  Future<int> addItem(ItemModel item)   {    
    if (item != null){
    db.insert(
      "Items", 
      item.toMap(),
      conflictAlgorithm: ConflictAlgorithm.ignore
      );      
    }
  }

  Future<int> clear(){      
    return db.delete("Items");
  }

}

final newsDbProvider =  NewsDbProvider();


