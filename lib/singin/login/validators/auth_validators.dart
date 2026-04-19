class AuthValidators {
  AuthValidators._();

  static String? requiredEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'O e-mail é obrigatório';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Digite um e-mail válido';
    }
    return null;
  }

  static String? requiredPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'A senha é obrigatória';
    }
    if (value.length < 6) {
      return 'A senha deve ter no mínimo 6 caracteres';
    }
    return null;
  }

  static String? requiredFullName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Digite seu nome completo';
    }
    if (!value.contains(' ')) {
      return 'Digite nome e sobrenome';
    }
    return null;
  }

  static String? requiredCpf(String? value) {
    if (value == null || value.isEmpty) {
      return 'Digite seu CPF';
    }
    final cpfClean = value.replaceAll(RegExp(r'[^0-9]'), '');
    if (cpfClean.length != 11) {
      return 'CPF deve ter 11 dígitos';
    }
    return null;
  }

  static String? requiredPhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Digite seu telefone';
    }
    final phoneClean = value.replaceAll(RegExp(r'[^0-9]'), '');
    if (phoneClean.length < 10) {
      return 'Telefone inválido';
    }
    return null;
  }

  static String? requiredPasswordConfirmation(
    String? value,
    String originalPassword,
  ) {
    if (value == null || value.isEmpty) {
      return 'A confirmação é obrigatória';
    }
    if (value != originalPassword) {
      return 'As senhas nao coincidem';
    }
    return null;
  }
}
