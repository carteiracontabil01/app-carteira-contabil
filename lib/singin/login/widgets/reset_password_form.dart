import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/singin/login/validators/auth_validators.dart';
import '/singin/login/widgets/auth_text_field.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ResetPasswordForm extends StatelessWidget {
  const ResetPasswordForm({
    super.key,
    required this.emailController,
    required this.emailFocusNode,
    required this.canSendResetEmail,
    required this.cooldownSeconds,
    required this.onSendResetEmail,
  });

  final TextEditingController? emailController;
  final FocusNode? emailFocusNode;
  final bool canSendResetEmail;
  final int cooldownSeconds;
  final Future<void> Function()? onSendResetEmail;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AuthTextField(
          controller: emailController,
          focusNode: emailFocusNode,
          labelText: 'E-mail',
          hintText: 'Digite seu e-mail cadastrado',
          prefixIcon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
          validator: AuthValidators.requiredEmail,
        ),
        const SizedBox(height: 24.0),
        FFButtonWidget(
          onPressed: canSendResetEmail ? onSendResetEmail : null,
          text: canSendResetEmail
              ? 'Enviar e-mail de recuperação'
              : 'Aguarde ${cooldownSeconds}s...',
          icon: const Icon(
            Icons.email_outlined,
            size: 20.0,
          ),
          options: FFButtonOptions(
            width: double.infinity,
            height: 56.0,
            padding: const EdgeInsetsDirectional.symmetric(horizontal: 24.0),
            iconPadding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 8.0, 0.0),
            color: const Color(0xFFD5D91B),
            textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                  font: GoogleFonts.nunito(
                    fontWeight: FontWeight.w600,
                  ),
                  color: const Color(0xFF15203D),
                  letterSpacing: 0.0,
                ),
            elevation: 0.0,
            borderRadius: BorderRadius.circular(28.0),
          ),
        ),
      ],
    );
  }
}
