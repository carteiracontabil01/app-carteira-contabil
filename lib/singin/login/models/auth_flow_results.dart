class AuthFlowResult {
  const AuthFlowResult({
    required this.success,
    this.message,
  });

  final bool success;
  final String? message;
}

class SignUpFlowResult extends AuthFlowResult {
  const SignUpFlowResult({
    required super.success,
    super.message,
    this.showProfileWarning = false,
  });

  final bool showProfileWarning;
}
