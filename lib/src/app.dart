import 'package:flutter/material.dart';
import 'screens/news_list.dart';
import 'screens/news_detail.dart';
import 'blocs/stories_provider.dart';
import 'blocs/comments_provider.dart';

class App extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    
    return CommentsProvider(
      child: StoriesProvider(
        child: MaterialApp(
          title: 'News!',
          //home: Text('Teste'),
          onGenerateRoute: routes,
        ),
      ),
    );   
  }

  Route routes( RouteSettings settings){
    if(settings.name == '/'){
      return MaterialPageRoute(
        builder: (context){   
          final storiesBloc = StoriesProvider.of(context); 
          storiesBloc.fetchTopIds();    
          return NewsList();
        },
      );
    }
    else{
      return MaterialPageRoute(
        builder: (context){
          final itemId = int.parse(settings.name.replaceFirst('/', ''));
          final commentsBloc = CommentsProvider.of(context);          
          commentsBloc.fetchItemWithComments(itemId);          
          return NewsDetail(
            itemId: itemId,
          );
        }
      );
    } 
  }

  
}