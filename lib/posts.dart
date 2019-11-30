import 'package:moor_flutter/moor_flutter.dart';

class Posts extends Table {
  IntColumn get id => integer()();
  IntColumn get userId => integer()();
  TextColumn get title => text()();
  TextColumn get body => text()();
}