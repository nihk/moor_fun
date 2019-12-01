import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:moor_fun/resource.dart';
import 'package:rxdart/rxdart.dart';

abstract class NetworkBoundResource<T> {
  final _data = StreamController<Resource<T>>();
  StreamSink<Resource<T>> get _sink => _data.sink;
  Stream<Resource<T>> get data => _data.stream;

  CompositeSubscription _compositeSubscription = CompositeSubscription();

  NetworkBoundResource() {
    _launch();
  }

  void _launch() {
    _sink.add(Resource.loading(null));

    var loadingSubscription =
        query().map((data) => Resource.loading(data)).listen((resource) {
      debugPrint("emitting Resource.loading");
      _sink.add(resource);
    });
    _compositeSubscription.add(loadingSubscription);

    var subscription = fetch()
        .flatMap((data) {
          debugPrint("-> fetch() done");
          return Observable.fromFuture(loadingSubscription.cancel())
              .flatMap((_) {
            _compositeSubscription.remove(loadingSubscription);
            debugPrint("-> calling saveFetch");
            return saveFetch(data);
          });
        })
        .flatMap((_) => query().map((data) {
              debugPrint("--> emitting Resource.success");
              return Resource.success(data);
            }))
        .onErrorResume((e) {
          return Observable.fromFuture(loadingSubscription.cancel())
              .flatMap((_) {
            _compositeSubscription.remove(loadingSubscription);
            return query().map((data) {
              debugPrint("--> emitting Resource.error");
              return Resource.error(data, e);
            });
          });
        })
        .listen((resource) => _sink.add(resource));

    _compositeSubscription.add(subscription);
  }

  Observable<T> query();

  Observable<T> fetch();

  Observable<void> saveFetch(T data);

  void dispose() {
    _compositeSubscription.dispose();
    _data.close();
  }
}
