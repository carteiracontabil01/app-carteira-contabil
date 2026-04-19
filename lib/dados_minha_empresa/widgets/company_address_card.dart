import '/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CompanyAddressCard extends StatelessWidget {
  const CompanyAddressCard({
    super.key,
    required this.typeLabel,
    required this.street,
    required this.number,
    required this.neighborhood,
    required this.city,
    required this.state,
    required this.zipCode,
    this.complement,
  });

  final String typeLabel;
  final String street;
  final String number;
  final String neighborhood;
  final String city;
  final String state;
  final String zipCode;
  final String? complement;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.secondaryBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.grayscale30),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.location_on_rounded,
                color: theme.primary,
                size: 18,
              ),
              const SizedBox(width: 6),
              Text(
                typeLabel,
                style: GoogleFonts.nunito(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: theme.primaryText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            '$street, $number',
            style: GoogleFonts.nunito(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: theme.primaryText,
            ),
          ),
          if (complement != null && complement!.trim().isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              complement!,
              style: GoogleFonts.nunito(
                fontSize: 13,
                color: theme.secondaryText,
              ),
            ),
          ],
          const SizedBox(height: 6),
          Text(
            '$neighborhood - $city/$state',
            style: GoogleFonts.nunito(
              fontSize: 13,
              color: theme.secondaryText,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'CEP: $zipCode',
            style: GoogleFonts.nunito(
              fontSize: 13,
              color: theme.secondaryText,
            ),
          ),
        ],
      ),
    );
  }
}
