import 'package:moor_flutter/moor_flutter.dart';
import 'package:moor_fun/posts.dart';

part 'app_database.g.dart';

@UseMoor(tables: [Posts])
class AppDatabase extends _$AppDatabase {

  AppDatabase() : super(FlutterQueryExecutor.inDatabaseFolder(path: "moor_fun.db"));

  @override
  int get schemaVersion => 1;

  Stream<List<Post>> watchPosts() {
    return select(posts).watch();
  }

  Future<int> insert(Post post) {
    return into(posts).insert(post);
  }

  Future<int> deleteAll() {
    return delete(posts).go();
  }
}