import 'package:moor_flutter/moor_flutter.dart';
import 'package:moor_fun/app_database.dart';
import 'package:moor_fun/posts.dart';

part 'posts_dao.g.dart';

@UseDao(tables: [Posts])
class PostsDao extends DatabaseAccessor<AppDatabase> with _$PostsDaoMixin {

  PostsDao(AppDatabase appDatabase) : super(appDatabase);

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