import 'package:flutter_ios_android_platforms/core/constants/app_constant.dart';
import 'filter_util.dart';
import 'sort_util.dart';

class QueryBuilder {
  int page;
  int limit;

  /// Multi-sort: List of {field: direction}
  List<Map<String, String>>? sort;

  /// Filter: Map of field -> value hoặc List giá trị
  Map<String, dynamic>? filter;

  /// 🔹 Search string
  String? search;

  QueryBuilder({
    this.page = AppConstants.defaultPage,
    this.limit = AppConstants.defaultLimit,
    this.sort,
    this.filter,
    this.search,
  });

  /// Tạo query params chuẩn gửi API
  Map<String, String> build() {
    final queryParams = <String, String>{
      "page": page.toString(),
      "limit": limit.toString(),
    };

    if (sort != null && sort!.isNotEmpty) {
      queryParams["sort"] = SortUtils.listToString(sort!);
    }

    if (filter != null && filter!.isNotEmpty) {
      queryParams["filter"] = FilterUtils.mapToString(filter!);
    }

    if (search != null && search!.trim().isNotEmpty) {
      queryParams["search"] = search!.trim();
    }

    return queryParams;
  }

  /// Builder từ defaultSort module (nếu không truyền sort thì lấy defaultSort)
  factory QueryBuilder.withModule({
    required String module,
    int page = AppConstants.defaultPage,
    int limit = AppConstants.defaultLimit,
    List<Map<String, String>>? sort,
    Map<String, dynamic>? filter,
    String? search,
  }) {
    final defaultSortString = AppConstants.defaultSorts[module]; // có thể null
    final defaultSortList = defaultSortString != null
        ? SortUtils.stringToList(defaultSortString)
        : null;

    return QueryBuilder(
      page: page,
      limit: limit,
      sort: sort ?? defaultSortList,
      filter: filter,
      search: search,
    );
  }
}
