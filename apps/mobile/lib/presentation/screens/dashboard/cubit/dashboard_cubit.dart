import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ios_android_platforms/domain/repositories/dashboard/dashboard_repository.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/dashboard/cubit/dashboard_state.dart';
import 'package:flutter_ios_android_platforms/services/dashboard_cache_service.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final DashboardRepository _repository;
  final DashboardCacheService _cacheService;

  DashboardCubit({
    required DashboardRepository repository,
    required DashboardCacheService cacheService,
  }) : _repository = repository,
       _cacheService = cacheService,
       super(DashboardInitial());

  Future<void> loadDashboard(String role) async {
    emit(DashboardLoading());
    try {
      final cached = await _cacheService.load(role);
      if (cached != null) {
        emit(DashboardLoaded(role: role, data: cached, isFromCache: true));
        _refreshInBackground(role);
      } else {
        await _fetchAndCache(role);
      }
    } catch (e) {
      emit(DashboardError("Không thể tải dữ liệu: $e"));
    }
  }

  Future<void> refreshDashboard(String role) async {
    if (state is DashboardLoaded) {
      emit((state as DashboardLoaded).copyWith(isRefreshing: true));
    }
    try {
      await _fetchAndCache(role);
    } catch (e) {
      emit(DashboardError("Không thể làm mới dữ liệu: $e"));
    }
  }

  void _refreshInBackground(String role) async {
    try {
      final fresh = await _repository.getDashboardData(role);
      await _cacheService.save(role, fresh);
      emit(DashboardLoaded(role: role, data: fresh, isFromCache: false));
    } catch (_) {}
  }

  Future<void> _fetchAndCache(String role) async {
    final fresh = await _repository.getDashboardData(role);
    await _cacheService.save(role, fresh);
    emit(DashboardLoaded(role: role, data: fresh, isFromCache: false));
  }
}
