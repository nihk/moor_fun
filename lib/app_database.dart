import 'package:moor_flutter/moor_flutter.dart';
import 'package:moor_fun/posts.dart';
import 'package:moor_fun/posts_dao.dart';

part 'app_database.g.dart';

@UseMoor(tables: [Posts], daos: [PostsDao])
class AppDatabase extends _$AppDatabase {

  AppDatabase() : super(FlutterQueryExecutor.inDatabaseFolder(path: "moor_fun.db"));

  @override
  int get schemaVersion => 1;
}