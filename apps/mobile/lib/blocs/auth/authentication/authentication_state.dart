part of 'authentication_bloc.dart';

enum AuthenticationStatus { unknown, authenticated, unauthenticated }

class AuthenticationState {
  final AuthenticationStatus status;
  final User? user;
  final String? role;

  const AuthenticationState._({required this.status, this.user, this.role});

  const AuthenticationState.unknown()
    : this._(status: AuthenticationStatus.unknown);

  const AuthenticationState.authenticated({
    required User user,
    required String? role,
  }) : this._(
         status: AuthenticationStatus.authenticated,
         user: user,
         role: role,
       );

  const AuthenticationState.unauthenticated()
    : this._(status: AuthenticationStatus.unauthenticated);

  @override
  String toString() =>
      'AuthenticationState(status: $status, uid: ${user?.uid}, role: $role)';
}
