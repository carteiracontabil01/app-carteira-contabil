import '/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BiometricCredentials {
  const BiometricCredentials({
    required this.email,
    required this.password,
  });

  final String email;
  final String password;
}

Future<BiometricCredentials?> showBiometricCredentialsDialog(
  BuildContext context,
  String currentEmail,
) {
  final emailController = TextEditingController(text: currentEmail);
  final passwordController = TextEditingController();

  return showDialog<BiometricCredentials>(
    context: context,
    builder: (dialogContext) {
      final theme = FlutterFlowTheme.of(dialogContext);

      return AlertDialog(
        title: Text(
          'Confirme suas credenciais',
          style: GoogleFonts.nunito(
            fontWeight: FontWeight.w700,
            color: theme.primaryText,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: emailController,
              enabled: false,
              decoration: const InputDecoration(
                labelText: 'E-mail',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passwordController,
              autofocus: true,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Senha',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              'Cancelar',
              style: GoogleFonts.nunito(),
            ),
          ),
          TextButton(
            onPressed: () {
              final password = passwordController.text.trim();
              if (password.isEmpty) return;
              Navigator.pop(
                dialogContext,
                BiometricCredentials(
                  email: emailController.text.trim(),
                  password: password,
                ),
              );
            },
            child: Text(
              'Confirmar',
              style: GoogleFonts.nunito(
                color: theme.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      );
    },
  );
}
