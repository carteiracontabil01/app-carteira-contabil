import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/singin/login/validators/auth_validators.dart';
import '/singin/login/widgets/auth_text_field.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({
    super.key,
    required this.emailController,
    required this.emailFocusNode,
    required this.passwordController,
    required this.passwordFocusNode,
    required this.passwordVisible,
    required this.onTogglePasswordVisibility,
    required this.onForgotPassword,
    required this.onLoginPressed,
    required this.showBiometricButton,
    required this.biometricType,
    required this.onBiometricPressed,
  });

  final TextEditingController? emailController;
  final FocusNode? emailFocusNode;
  final TextEditingController? passwordController;
  final FocusNode? passwordFocusNode;
  final bool passwordVisible;
  final VoidCallback onTogglePasswordVisibility;
  final VoidCallback onForgotPassword;
  final Future<void> Function()? onLoginPressed;
  final bool showBiometricButton;
  final String biometricType;
  final Future<void> Function()? onBiometricPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AuthTextField(
          controller: emailController,
          focusNode: emailFocusNode,
          labelText: 'E-mail',
          hintText: 'Digite seu e-mail',
          prefixIcon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
          validator: AuthValidators.requiredEmail,
        ),
        const SizedBox(height: 16.0),
        AuthTextField(
          controller: passwordController,
          focusNode: passwordFocusNode,
          labelText: 'Senha',
          hintText: 'Digite sua senha',
          prefixIcon: Icons.lock_outlined,
          obscureText: !passwordVisible,
          suffixIcon: InkWell(
            onTap: onTogglePasswordVisibility,
            focusNode: FocusNode(skipTraversal: true),
            child: Icon(
              passwordVisible
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              color: FlutterFlowTheme.of(context).secondaryText,
              size: 20.0,
            ),
          ),
          validator: AuthValidators.requiredPassword,
        ),
        const SizedBox(height: 8.0),
        Align(
          alignment: AlignmentDirectional.centerEnd,
          child: InkWell(
            onTap: onForgotPassword,
            child: Text(
              'Esqueceu a senha?',
              style: FlutterFlowTheme.of(context).bodySmall.override(
                    font: GoogleFonts.nunito(
                      fontWeight: FontWeight.w600,
                    ),
                    color: const Color(0xFF15203D),
                    letterSpacing: 0.0,
                  ),
            ),
          ),
        ),
        const SizedBox(height: 24.0),
        FFButtonWidget(
          onPressed: onLoginPressed,
          text: 'Entrar',
          icon: const Icon(
            Icons.login_rounded,
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
        if (showBiometricButton) ...[
          const SizedBox(height: 24.0),
          Row(
            children: [
              Expanded(
                child: Divider(
                  color: FlutterFlowTheme.of(context).grayscale40,
                  thickness: 1.0,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'OU',
                  style: FlutterFlowTheme.of(context).bodySmall.override(
                        font: GoogleFonts.nunito(fontWeight: FontWeight.w600),
                        color: FlutterFlowTheme.of(context).secondaryText,
                        letterSpacing: 0.0,
                      ),
                ),
              ),
              Expanded(
                child: Divider(
                  color: FlutterFlowTheme.of(context).grayscale40,
                  thickness: 1.0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24.0),
          OutlinedButton.icon(
            onPressed: onBiometricPressed,
            icon: const Icon(
              Icons.fingerprint_rounded,
              size: 24.0,
            ),
            label: Text(
              'Entrar com $biometricType',
              style: FlutterFlowTheme.of(context).titleSmall.override(
                    font: GoogleFonts.nunito(fontWeight: FontWeight.w600),
                    color: const Color(0xFF15203D),
                    letterSpacing: 0.0,
                  ),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF15203D),
              minimumSize: const Size(double.infinity, 56.0),
              padding: const EdgeInsetsDirectional.symmetric(horizontal: 24.0),
              side: const BorderSide(
                color: Color(0xFF15203D),
                width: 2.0,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28.0),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
