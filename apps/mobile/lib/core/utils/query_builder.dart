import 'package:flutter_ios_android_platforms/core/constants/app_constant.dart';
import 'filter_util.dart';
import 'sort_util.dart';

class QueryBuilder {
  int page;
  int limit;

  /// Multi-sort: List of {field: direction}
  List<Map<String, String>> sort;

  /// Filter: Map of field -> value or List of values
  Map<String, dynamic> filter;

  QueryBuilder({
    this.page = AppConstants.defaultPage,
    this.limit = AppConstants.defaultLimit,
    List<Map<String, String>>? sort,
    Map<String, dynamic>? filter,
  }) : sort = sort ?? [],
       filter = filter ?? {};

  /// Tạo query params Map<String, String> chuẩn gửi API
  Map<String, String> build() {
    final queryParams = <String, String>{
      "page": page.toString(),
      "limit": limit.toString(),
      "sort": SortUtils.listToString(sort),
    };

    if (filter.isNotEmpty) {
      queryParams["filter"] = FilterUtils.mapToString(filter);
    }

    return queryParams;
  }

  /// Builder từ defaultSort module
  factory QueryBuilder.withModule({
    required String module,
    int page = 1,
    int limit = 10,
    List<Map<String, String>>? sort,
    Map<String, dynamic>? filter,
  }) {
    final defaultSortString =
        AppConstants.defaultSorts[module] ?? "createdAt:desc";
    final defaultSortList = SortUtils.stringToList(defaultSortString);

    return QueryBuilder(
      page: page,
      limit: limit,
      sort: sort ?? defaultSortList,
      filter: filter,
    );
  }
}
