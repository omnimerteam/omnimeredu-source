import 'package:intl/intl.dart';

class AppConstants {
  // 🔹 Pagination
  static const int defaultPage = 1;
  static const int defaultLimit = 20;

  // 🔹 UI
  static const int defaultAnimationDuration = 300; // ms
  static const String defaultDateFormat = "dd/MM/yyyy";
  static const String defaultDateTimeFormat = "dd/MM/yyyy HH:mm";

  // 🔹 Default Sorts cho từng module
  static const String nameSort = "name:asc";
  static const Map<String, String> defaultSorts = {
    "class": "name:asc", // mặc định cho Class Management
    "membership": "createdAt:desc", // mặc định cho MembershipRequest
    "school": "name:asc", // mặc định cho School
  };

  // 🔹 Sort Options cho Class Management
  static const Map<String, String> classSortOptions = {
    'name:asc': 'Tên (A-Z)',
    'name:desc': 'Tên (Z-A)',
    'code:asc': 'Mã (A-Z)',
    'code:desc': 'Mã (Z-A)',
    'baseFee:asc': 'Học phí (Thấp → Cao)',
    'baseFee:desc': 'Học phí (Cao → Thấp)',
    'createdAt:asc': 'Ngày tạo (Cũ → Mới)',
    'createdAt:desc': 'Ngày tạo (Mới → Cũ)',
  };

  // 🔹 Formatters
  static final currencyFormatter = NumberFormat.currency(
    locale: 'vi_VN',
    symbol: '₫',
  );

  static DateTime? toVietnamTime(DateTime? utcDateTime) {
    if (utcDateTime == null) return null;
    return utcDateTime.toUtc().add(const Duration(hours: 7));
  }

  static final dateFormatter = DateFormat(defaultDateFormat, 'vi_VN');
  static final dateTimeFormatter = DateFormat(defaultDateTimeFormat, 'vi_VN');

  /// 🔹 Helper build query parameters (phân trang, sort, filter)
  static Map<String, String> buildQueryParams({
    required String module, // 👈 truyền vào "class", "membership", ...
    int page = defaultPage,
    int limit = defaultLimit,
    Map<String, String>? sort,
    Map<String, dynamic>? filter,
  }) {
    final queryParams = <String, String>{
      "page": page.toString(),
      "limit": limit.toString(),
    };

    // 🔹 Sort: ưu tiên sort truyền vào, nếu không thì lấy default theo module
    final sortStr = sort != null && sort.isNotEmpty
        ? sort.entries.map((e) => "${e.key}:${e.value}").join(",")
        : defaultSorts[module] ?? "createdAt:desc"; // fallback

    queryParams["sort"] = sortStr;

    // 🔹 Filter
    if (filter != null && filter.isNotEmpty) {
      queryParams["filter"] = filter.entries
          .map((e) => "${e.key}:${e.value}")
          .join(",");
    }

    return queryParams;
  }
}
