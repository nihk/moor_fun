// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class Post extends DataClass implements Insertable<Post> {
  final int userId;
  final int id;
  final String title;
  final String body;
  Post(
      {@required this.userId,
      @required this.id,
      @required this.title,
      @required this.body});
  factory Post.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    return Post(
      userId:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}user_id']),
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      title:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}title']),
      body: stringType.mapFromDatabaseResponse(data['${effectivePrefix}body']),
    );
  }
  factory Post.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer = const ValueSerializer.defaults()}) {
    return Post(
      userId: serializer.fromJson<int>(json['userId']),
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      body: serializer.fromJson<String>(json['body']),
    );
  }
  @override
  Map<String, dynamic> toJson(
      {ValueSerializer serializer = const ValueSerializer.defaults()}) {
    return {
      'userId': serializer.toJson<int>(userId),
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'body': serializer.toJson<String>(body),
    };
  }

  @override
  PostsCompanion createCompanion(bool nullToAbsent) {
    return PostsCompanion(
      userId:
          userId == null && nullToAbsent ? const Value.absent() : Value(userId),
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      title:
          title == null && nullToAbsent ? const Value.absent() : Value(title),
      body: body == null && nullToAbsent ? const Value.absent() : Value(body),
    );
  }

  Post copyWith({int userId, int id, String title, String body}) => Post(
        userId: userId ?? this.userId,
        id: id ?? this.id,
        title: title ?? this.title,
        body: body ?? this.body,
      );
  @override
  String toString() {
    return (StringBuffer('Post(')
          ..write('userId: $userId, ')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('body: $body')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(userId.hashCode,
      $mrjc(id.hashCode, $mrjc(title.hashCode, body.hashCode))));
  @override
  bool operator ==(other) =>
      identical(this, other) ||
      (other is Post &&
          other.userId == this.userId &&
          other.id == this.id &&
          other.title == this.title &&
          other.body == this.body);
}

class PostsCompanion extends UpdateCompanion<Post> {
  final Value<int> userId;
  final Value<int> id;
  final Value<String> title;
  final Value<String> body;
  const PostsCompanion({
    this.userId = const Value.absent(),
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.body = const Value.absent(),
  });
  PostsCompanion.insert({
    @required int userId,
    @required int id,
    @required String title,
    @required String body,
  })  : userId = Value(userId),
        id = Value(id),
        title = Value(title),
        body = Value(body);
  PostsCompanion copyWith(
      {Value<int> userId,
      Value<int> id,
      Value<String> title,
      Value<String> body}) {
    return PostsCompanion(
      userId: userId ?? this.userId,
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
    );
  }
}

class $PostsTable extends Posts with TableInfo<$PostsTable, Post> {
  final GeneratedDatabase _db;
  final String _alias;
  $PostsTable(this._db, [this._alias]);
  final VerificationMeta _userIdMeta = const VerificationMeta('userId');
  GeneratedIntColumn _userId;
  @override
  GeneratedIntColumn get userId => _userId ??= _constructUserId();
  GeneratedIntColumn _constructUserId() {
    return GeneratedIntColumn(
      'user_id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn(
      'id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _titleMeta = const VerificationMeta('title');
  GeneratedTextColumn _title;
  @override
  GeneratedTextColumn get title => _title ??= _constructTitle();
  GeneratedTextColumn _constructTitle() {
    return GeneratedTextColumn(
      'title',
      $tableName,
      false,
    );
  }

  final VerificationMeta _bodyMeta = const VerificationMeta('body');
  GeneratedTextColumn _body;
  @override
  GeneratedTextColumn get body => _body ??= _constructBody();
  GeneratedTextColumn _constructBody() {
    return GeneratedTextColumn(
      'body',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [userId, id, title, body];
  @override
  $PostsTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'posts';
  @override
  final String actualTableName = 'posts';
  @override
  VerificationContext validateIntegrity(PostsCompanion d,
      {bool isInserting = false}) {
    final context = VerificationContext();
    if (d.userId.present) {
      context.handle(
          _userIdMeta, userId.isAcceptableValue(d.userId.value, _userIdMeta));
    } else if (userId.isRequired && isInserting) {
      context.missing(_userIdMeta);
    }
    if (d.id.present) {
      context.handle(_idMeta, id.isAcceptableValue(d.id.value, _idMeta));
    } else if (id.isRequired && isInserting) {
      context.missing(_idMeta);
    }
    if (d.title.present) {
      context.handle(
          _titleMeta, title.isAcceptableValue(d.title.value, _titleMeta));
    } else if (title.isRequired && isInserting) {
      context.missing(_titleMeta);
    }
    if (d.body.present) {
      context.handle(
          _bodyMeta, body.isAcceptableValue(d.body.value, _bodyMeta));
    } else if (body.isRequired && isInserting) {
      context.missing(_bodyMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => <GeneratedColumn>{};
  @override
  Post map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return Post.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  Map<String, Variable> entityToSql(PostsCompanion d) {
    final map = <String, Variable>{};
    if (d.userId.present) {
      map['user_id'] = Variable<int, IntType>(d.userId.value);
    }
    if (d.id.present) {
      map['id'] = Variable<int, IntType>(d.id.value);
    }
    if (d.title.present) {
      map['title'] = Variable<String, StringType>(d.title.value);
    }
    if (d.body.present) {
      map['body'] = Variable<String, StringType>(d.body.value);
    }
    return map;
  }

  @override
  $PostsTable createAlias(String alias) {
    return $PostsTable(_db, alias);
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  $PostsTable _posts;
  $PostsTable get posts => _posts ??= $PostsTable(this);
  @override
  List<TableInfo> get allTables => [posts];
}
