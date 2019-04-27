import 'package:flutter/material.dart';
import '../blocs/stories_provider.dart';
import '../widgets/news_list_tile.dart';
import '../widgets/refresh.dart';

class NewsList extends StatelessWidget {
  Widget build(context) {
    // context gives reference of hierarchy, and we crawl up the hierarchy until we find an instance of the StoriesProvider, and that returns the reference to the bloc that is tied to the StoriesProvider. Now we'll be able to get access to the Stream that is tied to StoriesProvider and attempt to fetch some data.
    final bloc = StoriesProvider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Top News'),
      ),
      body: buildList(bloc),
    );
  }

  // Had to export in StoriesProvider to get access to the type
  Widget buildList(StoriesBloc bloc) {
    return StreamBuilder(
      stream: bloc.topIds,
      builder: (context, AsyncSnapshot<List<int>> snapshot) {
        // Anotating type of AsyncSnapshot is important and will save time in the future
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        return Refresh(
          child: ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (context, int index) {
              bloc.fetchItem(snapshot.data[index]);

              return NewsListTile(
                itemId: snapshot.data[index],
              );
            },
          ),
        );
      },
    );
  }
}

// Proof of concept for ListView and FutureBuilder
/*
Widget buildList() {
  return ListView.builder(
    itemCount: 1000,
    itemBuilder: (context, int index) {
      return FutureBuilder(
        future: getFuture(),
        builder: (context, snapshot) {
          // Invoked right when Future gets resolved, with data coming from Future on snapshot
          
          // ListView will only render the size of the first item, and based on the size of the screen, the others in the list
          return Container(
              height: 80.0,
              child: snapshot.hasData
                  ? Text('Im visible $index')
                  : Text('I havent fetch data yet $index'));
        },
      );
    },
  );
}

getFuture() {
  return Future.delayed(
    Duration(seconds: 2),
    () => 'hi',
  );
}
*/
