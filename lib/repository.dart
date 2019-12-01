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

  Future<void> _watchPosts() async {
    _subscription = _postsDao
        .watchPosts()
        .map((posts) => Resource.loading(posts))
        .listen((posts) => _sink.add(posts));

    try {
      List<Post> remotePosts = await _restApi.fetch();
      _subscription.cancel();
      await _postsDao.deleteAll();
      _postsDao.insertAll(remotePosts);

      _subscription = _postsDao
          .watchPosts()
          .map((posts) => Resource.success(posts))
          .listen((posts) => _sink.add(posts));
    } catch (e) {
      _subscription.cancel();
      _subscription = _postsDao
          .watchPosts()
          .map((posts) => Resource.error(posts, e))
          .listen((posts) => _sink.add(posts));
    }
  }
  
  Future<void> refresh() {
    _subscription?.cancel();
    return _watchPosts();
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