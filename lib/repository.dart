import 'dart:async';

import 'package:moor_fun/app_database.dart';
import 'package:moor_fun/posts_dao.dart';
import 'package:moor_fun/resource.dart';
import 'package:moor_fun/rest_api.dart';

class Repository {
  final PostsDao _postsDao;
  final RestApi _restApi;

//  final _posts = StreamController<Resource<List<Post>>>();
//  Stream<Resource<List<Post>>> get posts => _posts.stream;

  Repository(this._postsDao, this._restApi);

  Stream<Resource<List<Post>>> watchPosts() async* {
    yield Resource.loading(null);
    List<Post> cachedPosts = await _postsDao.getPosts();
    yield Resource.loading(cachedPosts);

    try {
      List<Post> remotePosts = await _restApi.fetch();
      await _postsDao.deleteAll();
      _postsDao.insertAll(remotePosts);

      yield* _postsDao.watchPosts().map((posts) => Resource.success(posts));
    } catch (e) {
      yield* _postsDao.watchPosts().map((posts) => Resource.error(posts, e));
    }
  }
  
  void refresh() {
  }

  Future<int> deleteAll() {
    return _postsDao.deleteAll();
  }

  Future<int> insert(Post post) {
    return _postsDao.insert(post);
  }

//  void dispose() {
//    _posts.close();
//  }
}