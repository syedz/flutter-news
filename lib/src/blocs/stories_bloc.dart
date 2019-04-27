import 'dart:async';
import 'package:rxdart/rxdart.dart';
import '../models/item_model.dart';
import '../resources/repository.dart';

class StoriesBloc {
  final _repository = Repository(); // Will be getting data from Repository
  final _topIds = PublishSubject<
      List<int>>(); // Like a StreamController, and will be accepting data
  final _items = BehaviorSubject<int>();

  Observable<Map<int, Future<ItemModel>>> items;

  // Getters to Streams/Observable, this will be available to the outside world
  Observable<List<int>> get topIds => _topIds.stream;
  // DON'T DO THIS, this creates a new transformer each time - do in constructor
  // get items => _items.stream.transform(_itemsTransformer());

  // Getters to Sinks
  Function(int) get fetchItem => _items.sink.add;

  StoriesBloc() {
    items = _items.stream.transform(_itemsTransformer());
  }

  fetchTopIds() async {
    final ids = await _repository.fetchTopIds();
    // Add to sink from the Subject/StreamController
    _topIds.sink.add(ids);
  }

  _itemsTransformer() {
    return ScanStreamTransformer(
      (Map<int, Future<ItemModel>> cache, int id, index) {
        print(index);
        cache[id] = _repository.fetchItem(id);
        return cache;
      },
      <int, Future<ItemModel>>{},
    );
  }

  // If every called, close all of the different stream controllers that we have
  dispose() {
    _topIds.close();
    _items.close();
  }
}
