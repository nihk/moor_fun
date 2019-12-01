import 'dart:async';

import 'package:moor_fun/app_database.dart';
import 'package:moor_fun/posts_dao.dart';
import 'package:moor_fun/resource.dart';
import 'package:moor_fun/rest_api.dart';
import 'package:rxdart/rxdart.dart';

class Repository {
  final PostsDao _postsDao;
  final RestApi _restApi;

  final _posts = StreamController<Resource<List<Post>>>();

  StreamSink<Resource<List<Post>>> get _sink => _posts.sink;

  Stream<Resource<List<Post>>> get posts => _posts.stream;
  StreamSubscription<Resource<List<Post>>> _subscription;
  StreamSubscription<Resource<List<Post>>> _innerSubscription;

  Repository(this._postsDao, this._restApi);

  Stream<Resource<List<Post>>> _watchPosts() async* {
    yield Resource.loading(null);

    _innerSubscription = _postsDao
        .watchPosts()
        .map((posts) => Resource.loading(posts))
        .listen((resource) {
      print("emitting Resource.loading");
      _sink.add(resource);
    });

    yield* Observable.fromFuture(_restApi.fetch()).flatMap((posts) {
      print("-> restApi.fetch() done");
      return Observable.fromFuture(_innerSubscription.cancel()).flatMap((_) {
        print("-> _postsDao.deleteAll");
        return _postsDao.deleteAll().asStream();
      }).flatMap((_) {
        print("-> _postsDao.insertAll");
        return _postsDao.insertAll(posts).asStream();
      });
    }).onErrorResume((e) {
      return _postsDao.watchPosts().map((posts) {
        print("--> emitting Resource.error");
        return Resource.error(posts, e);
      });
    }).flatMap((_) => _postsDao.watchPosts().map((posts) {
          print("--> emitting Resource.success");
          return Resource.success(posts);
        }));
  }

  Future<void> refresh() async {
    await _subscription?.cancel();
    await _innerSubscription?.cancel();
    print("refresh.cancelling");
    _subscription = _watchPosts().listen((resource) => _sink.add(resource));
  }

  Future<int> deleteAll() {
    return _postsDao.deleteAll();
  }

  Future<int> insert(Post post) {
    return _postsDao.insert(post);
  }

  void dispose() {
    _posts.close();
    _subscription?.cancel();
  }
}
