import '/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthTextField extends StatelessWidget {
  const AuthTextField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.labelText,
    required this.hintText,
    required this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.none,
    this.validator,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String labelText;
  final String hintText;
  final IconData prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      autofocus: false,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: FlutterFlowTheme.of(context).bodyMedium.override(
              font: GoogleFonts.nunito(),
              color: FlutterFlowTheme.of(context).secondaryText,
              letterSpacing: 0.0,
            ),
        hintText: hintText,
        hintStyle: FlutterFlowTheme.of(context).bodySmall.override(
              font: GoogleFonts.nunito(),
              color: FlutterFlowTheme.of(context).secondaryText,
              letterSpacing: 0.0,
            ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: FlutterFlowTheme.of(context).grayscale20,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(28.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Color(0xFF15203D),
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(28.0),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: FlutterFlowTheme.of(context).error,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(28.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: FlutterFlowTheme.of(context).error,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(28.0),
        ),
        filled: true,
        fillColor: FlutterFlowTheme.of(context).secondaryBackground,
        contentPadding: const EdgeInsetsDirectional.all(16.0),
        prefixIcon: Icon(
          prefixIcon,
          color: FlutterFlowTheme.of(context).secondaryText,
        ),
        suffixIcon: suffixIcon,
      ),
      style: FlutterFlowTheme.of(context).bodyMedium.override(
            font: GoogleFonts.nunito(),
            letterSpacing: 0.0,
          ),
      keyboardType: keyboardType,
      textCapitalization: textCapitalization,
      validator: validator,
    );
  }
}
