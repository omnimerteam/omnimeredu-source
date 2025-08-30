import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ios_android_platforms/domain/entities/role.dart';
import 'package:flutter_ios_android_platforms/domain/usecases/get_all_roles_usecase.dart';

part 'role_event.dart';
part 'role_state.dart';

class RoleBloc extends Bloc<RoleEvent, RoleState> {
  final GetAllRolesUseCase getAllRolesUseCase;

  RoleBloc(this.getAllRolesUseCase) : super(RoleInitial()) {
    on<FetchRolesEvent>((event, emit) async {
      emit(RoleLoading());
      try {
        final roles = await getAllRolesUseCase();
        emit(RoleLoaded(roles));
      } catch (e) {
        emit(RoleError("Không thể tải danh sách vai trò"));
      }
    });
  }
}
