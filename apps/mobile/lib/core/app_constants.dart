import 'package:intl/intl.dart';

class AppConstants {
  // 🔹 Pagination
  static const int defaultPage = 1;
  static const int defaultLimit = 20;

  // 🔹 Sort
  static const String nameSort = "name:asc";
  static const String defaultSort = "createdAt:desc";

  // 🔹 UI
  static const int defaultAnimationDuration = 300; // ms
  static const String defaultDateFormat = "dd/MM/yyyy";
  static const String defaultDateTimeFormat = "dd/MM/yyyy HH:mm";

  // 🔹 Sort Options for Class Management
  static const Map<String, String> classSortOptions = {
    'name:asc': 'Tên (A-Z)',
    'name:desc': 'Tên (Z-A)',
    'code:asc': 'Mã (A-Z)',
    'code:desc': 'Mã (Z-A)',
    'baseFee:asc': 'Học phí (Thấp → Cao)',
    'baseFee:desc': 'Học phí (Cao → Thấp)',
  };

  // 🔹 Formatters
  static final currencyFormatter = NumberFormat.currency(
    locale: 'vi_VN',
    symbol: '₫',
  );

  static final dateFormatter = DateFormat(defaultDateFormat, 'vi_VN');
  static final dateTimeFormatter = DateFormat(defaultDateTimeFormat, 'vi_VN');
}
