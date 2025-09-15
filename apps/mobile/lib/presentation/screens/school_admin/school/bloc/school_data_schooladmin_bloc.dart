import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ios_android_platforms/domain/usecases/school/create_school_usecase.dart';
import 'package:flutter_ios_android_platforms/domain/usecases/school/delete_school_usecase.dart';
import 'package:flutter_ios_android_platforms/domain/usecases/school/get_school_detail_for_schooladmin_usecase.dart';
import 'package:flutter_ios_android_platforms/domain/usecases/school/update_school_usecase.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/auth/authentication/authentication_bloc.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/auth/authentication/authentication_event.dart';
import 'school_data_schooladmin_event.dart';
import 'school_data_schooladmin_state.dart';

class SchoolDataSchoolAdminBloc
    extends Bloc<SchoolDataAdminEvent, SchoolDataAdminState> {
  final GetSchoolDetailForSchoolAdminUseCase getSchoolDetailUseCase;
  final CreateSchoolUseCase createSchoolUseCase;
  final UpdateSchoolUseCase updateSchoolUseCase;
  final DeleteSchoolUseCase deleteSchoolUseCase;
  final AuthenticationBloc authenticationBloc;

  SchoolDataSchoolAdminBloc({
    required this.getSchoolDetailUseCase,
    required this.createSchoolUseCase,
    required this.updateSchoolUseCase,
    required this.deleteSchoolUseCase,
    required this.authenticationBloc,
  }) : super(SchoolDataAdminInitial()) {
    on<LoadSchoolDataAdmin>((event, emit) async {
      emit(SchoolDataAdminLoading());
      try {
        final school = await getSchoolDetailUseCase.call();
        if (school == null) {
          emit(SchoolDataAdminEmpty());
        } else {
          emit(SchoolDataAdminLoaded(school));
        }
      } catch (e) {
        emit(SchoolDataAdminError(e.toString()));
      }
    });

    on<CreateSchoolDataAdminEvent>((event, emit) async {
      emit(SchoolDataAdminLoading());
      try {
        final school = await createSchoolUseCase.call(event.school);

        if (school.name != null) {
          authenticationBloc.add(
            AuthenticationSchoolUpdated(schoolName: school.name),
          );
        }

        emit(SchoolDataAdminLoaded(school));
      } catch (e) {
        emit(SchoolDataAdminError(e.toString()));
      }
    });

    on<UpdateSchoolDataAdminEvent>((event, emit) async {
      emit(SchoolDataAdminLoading());
      try {
        final school = await updateSchoolUseCase.call(event.school);

        if (school.name != null) {
          authenticationBloc.add(
            AuthenticationSchoolUpdated(schoolName: school.name),
          );
        }

        emit(SchoolDataAdminLoaded(school));
      } catch (e) {
        emit(SchoolDataAdminError(e.toString()));
      }
    });

    on<DeleteSchoolDataAdminEvent>((event, emit) async {
      emit(SchoolDataAdminLoading());
      try {
        await deleteSchoolUseCase.call();

        authenticationBloc.add(AuthenticationSchoolUpdated(schoolName: null));

        emit(SchoolDataAdminEmpty());
      } catch (e) {
        emit(SchoolDataAdminError(e.toString()));
      }
    });
  }
}
