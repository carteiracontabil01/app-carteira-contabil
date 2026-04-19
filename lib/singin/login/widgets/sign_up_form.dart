import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/singin/login/validators/auth_validators.dart';
import '/singin/login/widgets/auth_text_field.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SignUpForm extends StatelessWidget {
  const SignUpForm({
    super.key,
    required this.fullNameController,
    required this.fullNameFocusNode,
    required this.cpfController,
    required this.cpfFocusNode,
    required this.phoneController,
    required this.phoneFocusNode,
    required this.emailController,
    required this.emailFocusNode,
    required this.passwordController,
    required this.passwordFocusNode,
    required this.passwordVisible,
    required this.onTogglePasswordVisibility,
    required this.passwordConfirmController,
    required this.passwordConfirmFocusNode,
    required this.passwordConfirmVisible,
    required this.onTogglePasswordConfirmVisibility,
    required this.signUpEnabled,
    required this.onSignUpPressed,
  });

  final TextEditingController? fullNameController;
  final FocusNode? fullNameFocusNode;
  final TextEditingController? cpfController;
  final FocusNode? cpfFocusNode;
  final TextEditingController? phoneController;
  final FocusNode? phoneFocusNode;
  final TextEditingController? emailController;
  final FocusNode? emailFocusNode;
  final TextEditingController? passwordController;
  final FocusNode? passwordFocusNode;
  final bool passwordVisible;
  final VoidCallback onTogglePasswordVisibility;
  final TextEditingController? passwordConfirmController;
  final FocusNode? passwordConfirmFocusNode;
  final bool passwordConfirmVisible;
  final VoidCallback onTogglePasswordConfirmVisibility;
  final bool signUpEnabled;
  final Future<void> Function()? onSignUpPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AuthTextField(
          controller: fullNameController,
          focusNode: fullNameFocusNode,
          labelText: 'Nome Completo',
          hintText: 'Digite seu nome completo',
          prefixIcon: Icons.person_outline,
          textCapitalization: TextCapitalization.words,
          validator: AuthValidators.requiredFullName,
        ),
        const SizedBox(height: 16.0),
        AuthTextField(
          controller: cpfController,
          focusNode: cpfFocusNode,
          labelText: 'CPF',
          hintText: '000.000.000-00',
          prefixIcon: Icons.badge_outlined,
          keyboardType: TextInputType.number,
          validator: AuthValidators.requiredCpf,
        ),
        const SizedBox(height: 16.0),
        AuthTextField(
          controller: phoneController,
          focusNode: phoneFocusNode,
          labelText: 'Telefone',
          hintText: '(00) 00000-0000',
          prefixIcon: Icons.phone_outlined,
          keyboardType: TextInputType.phone,
          validator: AuthValidators.requiredPhone,
        ),
        const SizedBox(height: 16.0),
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
        const SizedBox(height: 16.0),
        AuthTextField(
          controller: passwordConfirmController,
          focusNode: passwordConfirmFocusNode,
          labelText: 'Confirmar Senha',
          hintText: 'Digite sua senha novamente',
          prefixIcon: Icons.lock_outlined,
          obscureText: !passwordConfirmVisible,
          suffixIcon: InkWell(
            onTap: onTogglePasswordConfirmVisibility,
            focusNode: FocusNode(skipTraversal: true),
            child: Icon(
              passwordConfirmVisible
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              color: FlutterFlowTheme.of(context).secondaryText,
              size: 20.0,
            ),
          ),
          validator: (value) => AuthValidators.requiredPasswordConfirmation(
            value,
            passwordController?.text ?? '',
          ),
        ),
        const SizedBox(height: 24.0),
        FFButtonWidget(
          onPressed: signUpEnabled ? onSignUpPressed : null,
          text: 'Cadastrar',
          icon: const Icon(
            Icons.person_add_rounded,
            size: 20.0,
          ),
          options: FFButtonOptions(
            width: double.infinity,
            height: 56.0,
            padding: const EdgeInsetsDirectional.symmetric(horizontal: 24.0),
            iconPadding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 8.0, 0.0),
            color: const Color(0xFFD5D91B),
            disabledColor: FlutterFlowTheme.of(context).grayscale40,
            disabledTextColor: FlutterFlowTheme.of(context).grayscale80,
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
