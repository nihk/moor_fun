import 'package:moor_fun/app_database.dart';

class RestApi {

  Future<List<Post>> fetch() async {
    Post post1 = Post(id: 1, userId: 1, title: "First", body: "First body");
    Post post2 = Post(id: 2, userId: 2, title: "Second", body: "Second body");
    Post post3 = Post(id: 3, userId: 3, title: "Third", body: "Third body");
    Post post4 = Post(id: 4, userId: 4, title: "Fourth", body: "Fourth body");

    var list = List<Post>(4);
    list[0] = post1;
    list[1] = post2;
    list[2] = post3;
    list[3] = post4;

    await Future.delayed(Duration(seconds: 2));

    return list;
  }
}