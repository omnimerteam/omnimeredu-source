import 'package:flutter_ios_android_platforms/domain/entities/query/default_query_entity.dart';
import 'package:flutter_ios_android_platforms/domain/entities/tuition/extra_fee_entity.dart';

/// Event gốc
abstract class ExtraFeeManagementEvent {}

/// --- Danh sách ---
class LoadExtraFeeEvent extends ExtraFeeManagementEvent {
  final DefaultQueryEntity? query;
  LoadExtraFeeEvent({this.query});
}

class RefreshExtraFeeEvent extends ExtraFeeManagementEvent {}

class LoadMoreExtraFeeEvent extends ExtraFeeManagementEvent {}

class FilterExtraFeeEvent extends ExtraFeeManagementEvent {
  final Map<String, dynamic> filter;
  FilterExtraFeeEvent(this.filter);
}

class SortExtraFeeEvent extends ExtraFeeManagementEvent {
  final List<Map<String, String>> sort;
  SortExtraFeeEvent(this.sort);
}

class SearchExtraFeeEvent extends ExtraFeeManagementEvent {
  final String search;
  SearchExtraFeeEvent(this.search);
}

/// --- Chi tiết ---
class LoadExtraFeeByIdEvent extends ExtraFeeManagementEvent {
  final String feeId;
  LoadExtraFeeByIdEvent(this.feeId);
}

class ShowExtraFeeDetailsEvent extends ExtraFeeManagementEvent {
  final ExtraFeeEntity extraFee;
  ShowExtraFeeDetailsEvent(this.extraFee);
}

class HideExtraFeeDetailsEvent extends ExtraFeeManagementEvent {}

/// --- CRUD ---
class CreateExtraFeeEvent extends ExtraFeeManagementEvent {
  final ExtraFeeEntity extraFee;
  CreateExtraFeeEvent(this.extraFee);
}

class UpdateExtraFeeEvent extends ExtraFeeManagementEvent {
  final ExtraFeeEntity extraFee;
  UpdateExtraFeeEvent(this.extraFee);
}

class DeleteExtraFeeEvent extends ExtraFeeManagementEvent {
  final String feeId;
  DeleteExtraFeeEvent(this.feeId);
}

/// --- Khác (tùy use case) ---
class ApproveExtraFeeEvent extends ExtraFeeManagementEvent {
  final String feeId;
  ApproveExtraFeeEvent(this.feeId);
}

class RejectExtraFeeEvent extends ExtraFeeManagementEvent {
  final String feeId;
  final String reason;
  RejectExtraFeeEvent(this.feeId, this.reason);
}
