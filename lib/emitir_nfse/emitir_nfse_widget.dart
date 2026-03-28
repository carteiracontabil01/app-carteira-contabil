import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'emitir_nfse_model.dart';
export 'emitir_nfse_model.dart';

class EmitirNfseWidget extends StatefulWidget {
  const EmitirNfseWidget({super.key});

  static String routeName = 'emitirNfse';
  static String routePath = 'emitir-nfse';

  @override
  State<EmitirNfseWidget> createState() => _EmitirNfseWidgetState();
}

class _EmitirNfseWidgetState extends State<EmitirNfseWidget> {
  late EmitirNfseModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  static const _serviceTypes = [
    'Consultoria',
    'Desenvolvimento',
    'Design',
    'Marketing',
    'Treinamento',
    'Outro',
  ];

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => EmitirNfseModel());
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: theme.primaryBackground,
        appBar: AppBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_rounded,
              color: theme.primaryText,
              size: 24,
            ),
            onPressed: () => context.pop(),
          ),
          title: Text(
            'Emitir NFS-e',
            style: GoogleFonts.nunito(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: theme.primaryText,
            ),
          ),
          centerTitle: true,
          elevation: 0,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Informe os dados da nota para emissão.',
                    style: GoogleFonts.nunito(
                      fontSize: 14,
                      height: 1.45,
                      color: theme.secondaryText,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _sectionLabel(context, 'Destinatário'),
                  const SizedBox(height: 10),
                  _buildTextField(
                    context,
                    hint: 'Nome ou razão social do cliente',
                    controller: _model.clienteController,
                    focusNode: _model.clienteFocusNode,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 22),
                  _sectionLabel(context, 'Serviço'),
                  const SizedBox(height: 10),
                  _buildServiceDropdown(context),
                  const SizedBox(height: 22),
                  _fieldLabel(context, 'Descrição'),
                  const SizedBox(height: 8),
                  _buildTextField(
                    context,
                    hint: 'Descreva o serviço prestado',
                    controller: _model.descricaoController,
                    focusNode: _model.descricaoFocusNode,
                    maxLines: 4,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 22),
                  _fieldLabel(context, 'Valor (R\$)'),
                  const SizedBox(height: 8),
                  _buildTextField(
                    context,
                    hint: '0,00',
                    controller: _model.valorController,
                    focusNode: _model.valorFocusNode,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^\d+\.?\d{0,2}')),
                    ],
                    textInputAction: TextInputAction.done,
                  ),
                  const SizedBox(height: 32),
                  _buildSubmitButton(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _sectionLabel(BuildContext context, String text) {
    return Text(
      text,
      style: GoogleFonts.nunito(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.3,
        color: FlutterFlowTheme.of(context).secondaryText,
      ),
    );
  }

  Widget _fieldLabel(BuildContext context, String text) {
    return Text(
      text,
      style: GoogleFonts.nunito(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: FlutterFlowTheme.of(context).primaryText,
      ),
    );
  }

  /// Campos sem ícones — borda leve, cantos 10 (alinhado a Guias / filtros)
  Widget _buildTextField(
    BuildContext context, {
    required String hint,
    required TextEditingController controller,
    required FocusNode focusNode,
    int maxLines = 1,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    TextInputAction? textInputAction,
  }) {
    final theme = FlutterFlowTheme.of(context);
    final borderColor = theme.primaryText.withValues(alpha: 0.1);

    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      maxLines: maxLines,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      textInputAction: textInputAction,
      style: GoogleFonts.nunito(
        fontSize: 15,
        color: theme.primaryText,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.nunito(
          fontSize: 15,
          color: theme.secondaryText.withValues(alpha: 0.55),
        ),
        filled: true,
        fillColor: theme.secondaryBackground,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: theme.primary.withValues(alpha: 0.65),
            width: 1.5,
          ),
        ),
        isDense: true,
      ),
    );
  }

  Widget _buildServiceDropdown(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      decoration: BoxDecoration(
        color: theme.secondaryBackground,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: theme.primaryText.withValues(alpha: 0.1),
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _model.selectedServiceType,
          isExpanded: true,
          hint: Text(
            'Selecione o tipo',
            style: GoogleFonts.nunito(
              fontSize: 15,
              color: theme.secondaryText.withValues(alpha: 0.55),
            ),
          ),
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: theme.secondaryText,
            size: 22,
          ),
          style: GoogleFonts.nunito(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: theme.primaryText,
          ),
          dropdownColor: theme.secondaryBackground,
          borderRadius: BorderRadius.circular(10),
          items: _serviceTypes.map((s) {
            return DropdownMenuItem<String>(
              value: s,
              child: Text(s),
            );
          }).toList(),
          onChanged: (v) => setState(() => _model.selectedServiceType = v),
        ),
      ),
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    return SizedBox(
      width: double.infinity,
      height: 50,
      child: FilledButton(
        onPressed: _model.isLoading ? null : _emitirNota,
        style: FilledButton.styleFrom(
          backgroundColor: theme.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24),
        ),
        child: _model.isLoading
            ? SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: Colors.white.withValues(alpha: 0.95),
                ),
              )
            : Text(
                'Emitir NFS-e',
                style: GoogleFonts.nunito(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
      ),
    );
  }

  Future<void> _emitirNota() async {
    final theme = FlutterFlowTheme.of(context);

    void snack(String msg, {bool error = true}) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(msg, style: GoogleFonts.nunito()),
          backgroundColor: error ? theme.error : theme.success,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }

    if (_model.clienteController.text.trim().isEmpty) {
      snack('Informe o cliente');
      return;
    }
    if (_model.selectedServiceType == null) {
      snack('Selecione o tipo de serviço');
      return;
    }
    if (_model.descricaoController.text.trim().isEmpty) {
      snack('Descreva o serviço');
      return;
    }
    if (_model.valorController.text.trim().isEmpty) {
      snack('Informe o valor');
      return;
    }

    setState(() => _model.isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() => _model.isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Colors.white, size: 22),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'NFS-e emitida com sucesso.',
                style: GoogleFonts.nunito(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        backgroundColor: theme.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 3),
      ),
    );

    _model.clienteController.clear();
    _model.descricaoController.clear();
    _model.valorController.clear();
    setState(() => _model.selectedServiceType = null);
  }
}
