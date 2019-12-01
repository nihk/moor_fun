import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:moor_fun/app_database.dart';
import 'package:moor_fun/network_bound_resource.dart';
import 'package:moor_fun/posts_dao.dart';
import 'package:moor_fun/resource.dart';
import 'package:moor_fun/rest_api.dart';
import 'package:rxdart/rxdart.dart';

class PostsRepository {
  final PostsDao _postsDao;
  final RestApi _restApi;

  final _posts = StreamController<Resource<List<Post>>>();
  StreamSink<Resource<List<Post>>> get _sink => _posts.sink;
  Stream<Resource<List<Post>>> get posts => _posts.stream;

  StreamSubscription<Resource<List<Post>>> _subscription;
  _PostsNetworkBoundResource _nbr;

  PostsRepository(this._postsDao, this._restApi);

  void refresh() {
    debugPrint("refresh called");
    _subscription?.cancel();
    _nbr?.dispose();
    _nbr = _PostsNetworkBoundResource(_postsDao, _restApi);
    _subscription = _nbr.data.listen((resource) => _sink.add(resource));
  }

  Future<int> deleteAll() {
    return _postsDao.deleteAll();
  }

  Future<int> insert(Post post) {
    return _postsDao.insert(post);
  }

  void dispose() {
    _subscription?.cancel();
    _nbr?.dispose();
    _posts.close();
  }
}

class _PostsNetworkBoundResource extends NetworkBoundResource<List<Post>> {
  final PostsDao _postsDao;
  final RestApi _restApi;

  _PostsNetworkBoundResource(this._postsDao, this._restApi);

  @override
  Observable<List<Post>> fetch() {
    return Observable.fromFuture(_restApi.fetch());
  }

  @override
  Observable<List<Post>> query() {
    return Observable(_postsDao.watchPosts());
  }

  @override
  Observable<void> saveFetchResult(List<Post> data) {
    return Observable.fromFuture(_postsDao.deleteAll())
        .flatMap((_) => Observable.fromFuture(_postsDao.insertAll(data)));
  }
}