import 'package:flutter/cupertino.dart';
import 'package:moor_fun/app_database.dart';
import 'package:moor_fun/posts_repository.dart';
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
        // fixme: Repository has state; it probably shouldn't be an app-wide singleton
        ProxyProvider<AppDatabase, PostsRepository>(
          update: (_, AppDatabase appDatabase, __) =>
              PostsRepository(appDatabase.postsDao, RestApi())..refresh(),
          dispose: (_, repository) => repository.dispose(),
        )
      ],
      child: CupertinoApp(
        title: 'Moor Demo',
        theme: CupertinoThemeData(
            scaffoldBackgroundColor: CupertinoColors.white,
            barBackgroundColor: CupertinoColors.extraLightBackgroundGray,
            primaryColor: CupertinoColors.destructiveRed),
        home: HomePage(),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var repository = Provider.of<PostsRepository>(context);

    return CupertinoPageScaffold(
      child: SafeArea(
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                CupertinoButton(
                  child: Icon(CupertinoIcons.clear),
                  onPressed: () {
                    repository.deleteAll();
                    id = 1;
                  },
                ),
                SizedBox(
                  width: 10,
                ),
                CupertinoButton(
                  child: Icon(CupertinoIcons.add),
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
                CupertinoButton(
                  child: Icon(CupertinoIcons.bluetooth),
                  onPressed: () {
                    repository.refresh();
                  },
                ),
              ],
            ),

            Expanded(
              child: StreamProvider<Resource<List<Post>>>(
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
                              child: CupertinoActivityIndicator(),
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
            ),
          ],
        ),
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
        return Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(resource.data[index].title),
              Text(resource.data[index].body),
            ],
          ),
        );
      },
    );
  }
}
