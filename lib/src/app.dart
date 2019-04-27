import 'package:flutter/material.dart';
import 'screens/news_list.dart';
import 'blocs/stories_provider.dart';
import 'blocs/comments_provider.dart';
import 'screens/news_detail.dart';

class App extends StatelessWidget {
  Widget build(context) {
    return CommentsProvider(
      child: StoriesProvider(
        child: MaterialApp(
          title: 'News!',
          onGenerateRoute: routes,
        ),
      ),
    );
  }

  Route routes(RouteSettings settings) {
    // We return a "Builder", it's something that will produce a widget at some point in time during the future. This is a common concept in Flutter (StreamBuilder, ListBuilder, FutureBuilder, etc)

    if (settings.name == '/') {
      return MaterialPageRoute(
        builder: (context) {
          final storiesBloc = StoriesProvider.of(context);
          storiesBloc.fetchTopIds();

          return NewsList();
        },
      );
    } else {
      return MaterialPageRoute(
        builder: (context) {
          // Extract the item id from settings.name and pass into NewsDetail. A great location to do some initialization or data fetching for NewsDetail
          final itemId = int.parse(settings.name.replaceFirst('/', ''));
          final commentsBloc = CommentsProvider.of(context);

          commentsBloc.fetchItemWithComments(itemId);

          return NewsDetail(
            itemId: itemId,
          );
        },
      );
    }
  }
}
