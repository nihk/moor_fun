import 'dart:async';

import 'package:moor_fun/app_database.dart';
import 'package:moor_fun/posts_dao.dart';
import 'package:moor_fun/resource.dart';
import 'package:moor_fun/rest_api.dart';

class Repository {
  final PostsDao _postsDao;
  final RestApi _restApi;

  final _posts = StreamController<Resource<List<Post>>>();
  StreamSink<Resource<List<Post>>> get _sink => _posts.sink;
  Stream<Resource<List<Post>>> get posts => _posts.stream;
  StreamSubscription<Resource<List<Post>>> _subscription;

  Repository(this._postsDao, this._restApi);

  Stream<Resource<List<Post>>> _watchPosts() async* {
    yield Resource.loading(null);

    var localSubscription = _postsDao
        .watchPosts()
        .map((posts) => Resource.loading(posts))
        .listen((resource) {
          print("emitting Resource.loading");
          _sink.add(resource);
        });

    try {
      // fixme: these need to be cancellable...somehow
      List<Post> remotePosts = await _restApi.fetch();
      print("-> fetched restApi");
      await localSubscription.cancel();
      await _postsDao.deleteAll();
      print("-> deleted all local posts");
      await _postsDao.insertAll(remotePosts);
      print("-> inserted remote posts locally");

      yield* _postsDao.watchPosts().map((posts) {
        print("--> emitting Resource.success");
        return Resource.success(posts);
      });
    } catch (e) {
      await localSubscription.cancel();
      yield* _postsDao.watchPosts().map((posts) {
        print("--> emitting Resource.error");
        return Resource.error(posts, e);
      });
    }
  }

  Future<void> refresh() async {
    await _subscription?.cancel();
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
