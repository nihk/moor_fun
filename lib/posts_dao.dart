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

  Future<List<Post>> getPosts() {
    return select(posts).get();
  }

  Future<int> insert(Post post) {
    return into(posts).insert(post);
  }

  Future<void> insertAll(List<Post> postz) {
    return batch((f) => f.insertAll(posts, postz));
  }

  Future<int> deleteAll() {
    return delete(posts).go();
  }
}