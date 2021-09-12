import 'package:flutter/material.dart';
import '../blocs/stories_provider.dart';
import '../wigets/news_list_title.dart';
import '../wigets/refresh.dart';


class NewsList extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    //Dá acesso aos streams em todo o aplicativo
    final bloc = StoriesProvider.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Top News'),
      ),
      body: buildList(bloc),
    );
  }


  Widget buildList(StoriesBloc bloc){
    return StreamBuilder(
      stream: bloc.topIds,
      builder: (context, AsyncSnapshot<List<int>> snapshot){
        if(!snapshot.hasData){
          return Center(            
            child: CircularProgressIndicator(          
            ),
          );
        }

        return Refresh(
          child: ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (context,int index){
              bloc.fetchItem(snapshot.data[index]);            
              return NewsListTitle(
                itemId: snapshot.data[index],
              );
           },
          ),
        );
      },
    );
  }

  
  //Só busca os itens que são visíveis conforme mostrado na tela
  //Quando movemos a scroll ocorrem novas requisições
  

}