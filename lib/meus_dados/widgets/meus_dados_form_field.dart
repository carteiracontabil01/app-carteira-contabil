import '/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class MeusDadosFormField extends StatelessWidget {
  const MeusDadosFormField({
    super.key,
    required this.label,
    required this.controller,
    required this.hintText,
    required this.icon,
    this.enabled = true,
    this.keyboardType,
    this.inputFormatters,
    this.validator,
  });

  final String label;
  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final bool enabled;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.nunito(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: theme.primary,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          enabled: enabled,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          validator: validator,
          style: GoogleFonts.nunito(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: enabled ? theme.primary : theme.grayscale80,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: GoogleFonts.nunito(
              fontSize: 14,
              color: theme.secondaryText,
            ),
            prefixIcon: Icon(
              icon,
              color: theme.primary,
              size: 20,
            ),
            filled: true,
            fillColor: theme.secondaryBackground,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 14,
            ),
            enabledBorder: _buildBorder(theme.grayscale30),
            focusedBorder: _buildBorder(theme.primary, width: 1.6),
            disabledBorder: _buildBorder(theme.grayscale30),
            errorBorder: _buildBorder(theme.error),
            focusedErrorBorder: _buildBorder(theme.error, width: 1.6),
          ),
        ),
      ],
    );
  }

  OutlineInputBorder _buildBorder(Color color, {double width = 1}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(
        color: color,
        width: width,
      ),
    );
  }
}
