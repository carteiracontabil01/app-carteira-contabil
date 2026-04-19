class SignUpPayload {
  const SignUpPayload({
    required this.email,
    required this.password,
    required this.fullName,
    required this.cpf,
    required this.phone,
  });

  final String email;
  final String password;
  final String fullName;
  final String cpf;
  final String phone;
}
