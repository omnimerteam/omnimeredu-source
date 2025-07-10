abstract class SignupEvent {}

class SignupSubmitted extends SignupEvent {
  final String email;
  final String password;
  final String rePassword;
  final String fullName;
  final String gender;
  final String phone;
  final String role;

  SignupSubmitted({
    required this.email,
    required this.password,
    required this.rePassword,
    required this.fullName,
    required this.gender,
    required this.phone,
    required this.role,
  });
}
