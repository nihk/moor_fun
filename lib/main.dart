import 'package:flutter/material.dart';
import 'package:moor_fun/app_database.dart';
import 'package:moor_fun/posts_dao.dart';
import 'package:moor_fun/repository.dart';
import 'package:moor_fun/resource.dart';
import 'package:moor_fun/rest_api.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

int id = 1;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AppDatabase>(
          create: (_) => AppDatabase(),
          dispose: (_, appDatabase) => appDatabase.close(),
        ),
        // fixme: Repository has state; it shouldn't be an app-wide singleton
        ProxyProvider<AppDatabase, Repository>(
          update: (_, AppDatabase appDatabase, __) =>
              Repository(appDatabase.postsDao, RestApi())..refresh(),
          dispose: (_, repository) => repository.dispose(),
        )
      ],
      child: MaterialApp(
        title: 'Moor Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomePage(),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var repository = Provider.of<Repository>(context);

    return Scaffold(
      body: StreamProvider<Resource<List<Post>>>(
        initialData: Resource.loading(null),
        create: (BuildContext context) {
          return repository.posts;
        },
        child: Consumer<Resource<List<Post>>>(
          builder: (BuildContext context, Resource<List<Post>> resource,
              Widget child) {
            switch (resource.state) {
              case ResourceState.LOADING:
                return Stack(
                  children: <Widget>[
                    PostsList(
                      resource: resource,
                    ),
                    Center(
                      child: CircularProgressIndicator(),
                    )
                  ],
                );
              case ResourceState.SUCCESS:
                return PostsList(
                  resource: resource,
                );
              case ResourceState.ERROR:
                return PostsList(
                  resource: resource,
                );
            }

            return null;
          },
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            child: Icon(Icons.close),
            onPressed: () {
              repository.deleteAll();
              id = 1;
            },
          ),
          SizedBox(
            width: 10,
          ),
          FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              repository.insert(
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
          SizedBox(
            width: 10,
          ),
          FloatingActionButton(
            child: Icon(Icons.network_wifi),
            onPressed: () {
              repository.refresh();
            },
          ),
        ],
      ),
    );
  }
}

class PostsList extends StatelessWidget {
  final Resource<List<Post>> resource;

  const PostsList({Key key, this.resource}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: resource.data?.length ?? 0,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(resource.data[index].title),
          subtitle: Text(resource.data[index].body),
        );
      },
    );
  }
}
