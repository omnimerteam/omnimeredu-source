import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../domain/entities/auth/role_entity.dart';
import '../../../../../domain/usecases/auth/get_all_roles_usecase.dart';
import '../../../../../domain/usecases/auth/get_roles_personnel_usecase.dart';

part 'role_event.dart';
part 'role_state.dart';

/// Bloc quản lý danh sách Role (tất cả & role nhân sự).
class RoleBloc extends Bloc<RoleEvent, RoleState> {
  final GetAllRolesUseCase _getAllRolesUseCase;
  final GetRolesPersonnelUseCase _getRolesPersonnelUseCase;

  RoleBloc({
    required GetAllRolesUseCase getAllRolesUseCase,
    required GetRolesPersonnelUseCase getRolesPersonnelUseCase,
  }) : _getAllRolesUseCase = getAllRolesUseCase,
       _getRolesPersonnelUseCase = getRolesPersonnelUseCase,
       super(RoleInitial()) {
    // --- Lấy tất cả roles ---
    on<FetchRolesEvent>(_onFetchRoles);

    // --- Lấy roles nhân sự ---
    on<FetchRolePersonnelEvent>(_onFetchRolePersonnel);
  }

  Future<void> _onFetchRoles(
    FetchRolesEvent event,
    Emitter<RoleState> emit,
  ) async {
    emit(RoleLoading());
    try {
      final roles = await _getAllRolesUseCase();
      emit(RoleLoaded(roles));
    } catch (e) {
      emit(RoleError('Không thể tải danh sách vai trò: $e'));
    }
  }

  Future<void> _onFetchRolePersonnel(
    FetchRolePersonnelEvent event,
    Emitter<RoleState> emit,
  ) async {
    emit(RoleLoading());
    try {
      final roles = await _getRolesPersonnelUseCase();
      emit(RolePersonnelLoaded(roles));
    } catch (e) {
      emit(RoleError('Không thể tải danh sách vai trò nhân sự: $e'));
    }
  }
}
