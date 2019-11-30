import 'package:flutter/material.dart';
import 'package:moor_fun/app_database.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

int id = 1;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => AppDatabase(),
      child: MaterialApp(
        title: 'Moor Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Consumer<AppDatabase>(
          builder:
              (BuildContext context, AppDatabase appDatabase, Widget child) {
            return Scaffold(
              body: StreamProvider<List<Post>>(
                create: (BuildContext context) {
                  return appDatabase.watchPosts();
                },
                child: Consumer<List<Post>>(
                  builder:
                      (BuildContext context, List<Post> posts, Widget child) {
                    return ListView.builder(
                      itemCount: posts?.length ?? 0,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(posts[index].title),
                          subtitle: Text(posts[index].body),
                        );
                      },
                    );
                  },
                ),
              ),
              floatingActionButton: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  FloatingActionButton(
                    child: Icon(Icons.close),
                    onPressed: () {
                      appDatabase.deleteAll();
                      id = 1;
                    },
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () {
                      appDatabase.insert(
                        Post(
                          userId: id * id,
                          id: id,
                          title: "Number $id",
                          body: "Body $id",
                        ),
                      );
                      id++;
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
