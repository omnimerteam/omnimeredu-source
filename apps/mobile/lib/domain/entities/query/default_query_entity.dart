import 'package:flutter_ios_android_platforms/core/utils/query_builder.dart';

class DefaultQueryEntity {
  final int page;
  final int limit;
  final List<Map<String, String>> sort;
  final Map<String, dynamic> filter;

  DefaultQueryEntity({
    this.page = 1,
    this.limit = 10,
    this.sort = const [],
    this.filter = const {},
  });

  QueryBuilder toQueryBuilder() {
    return QueryBuilder(page: page, limit: limit, sort: sort, filter: filter);
  }

  DefaultQueryEntity copyWith({
    int? page,
    int? limit,
    List<Map<String, String>>? sort,
    Map<String, dynamic>? filter,
  }) {
    return DefaultQueryEntity(
      page: page ?? this.page,
      limit: limit ?? this.limit,
      sort: sort ?? this.sort,
      filter: filter ?? this.filter,
    );
  }
}
