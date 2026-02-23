import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
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
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).primary,
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 24,
            ),
            onPressed: () => context.pop(),
          ),
          title: Text(
            'Emitir NFS-e',
            style: FlutterFlowTheme.of(context).headlineSmall.override(
                  font: GoogleFonts.nunito(fontWeight: FontWeight.w600),
                  color: Colors.white,
                  letterSpacing: 0.0,
                ),
          ),
          elevation: 0.0,
          centerTitle: false,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header com ícone
                  Center(
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            FlutterFlowTheme.of(context).primary,
                            FlutterFlowTheme.of(context).primary.withValues(alpha: 0.7),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: FlutterFlowTheme.of(context).primary.withValues(alpha: 0.3),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.receipt_long,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Título e descrição
                  Text(
                    'Nova Nota Fiscal',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.nunito(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: FlutterFlowTheme.of(context).primaryText,
                    ),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  Text(
                    'Preencha os dados abaixo para emitir uma nova NFS-e',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.nunito(
                      fontSize: 14,
                      color: FlutterFlowTheme.of(context).secondaryText,
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Formulário
                  _buildFormSection(context),
                  
                  const SizedBox(height: 32),
                  
                  // Botão de emitir
                  _buildSubmitButton(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildFormSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cliente
          _buildInputField(
            context,
            label: 'Cliente',
            hint: 'Nome do cliente ou empresa',
            controller: _model.clienteController,
            focusNode: _model.clienteFocusNode,
            icon: Icons.person_outline,
          ),
          
          const SizedBox(height: 20),
          
          // Tipo de Serviço
          _buildServiceTypeSelector(context),
          
          const SizedBox(height: 20),
          
          // Descrição do Serviço
          _buildInputField(
            context,
            label: 'Descrição do Serviço',
            hint: 'Descreva o serviço prestado',
            controller: _model.descricaoController,
            focusNode: _model.descricaoFocusNode,
            icon: Icons.description_outlined,
            maxLines: 4,
          ),
          
          const SizedBox(height: 20),
          
          // Valor
          _buildInputField(
            context,
            label: 'Valor (R\$)',
            hint: '0,00',
            controller: _model.valorController,
            focusNode: _model.valorFocusNode,
            icon: Icons.attach_money,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildInputField(
    BuildContext context, {
    required String label,
    required String hint,
    required TextEditingController controller,
    required FocusNode focusNode,
    required IconData icon,
    int maxLines = 1,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.nunito(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: FlutterFlowTheme.of(context).primaryText,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          focusNode: focusNode,
          maxLines: maxLines,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.nunito(
              fontSize: 14,
              color: FlutterFlowTheme.of(context).secondaryText.withValues(alpha: 0.5),
            ),
            prefixIcon: Icon(
              icon,
              color: FlutterFlowTheme.of(context).primary,
              size: 22,
            ),
            filled: true,
            fillColor: FlutterFlowTheme.of(context).primaryBackground,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: FlutterFlowTheme.of(context).primary.withValues(alpha: 0.1),
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: FlutterFlowTheme.of(context).primary,
                width: 2,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
          style: GoogleFonts.nunito(
            fontSize: 15,
            color: FlutterFlowTheme.of(context).primaryText,
          ),
        ),
      ],
    );
  }
  
  Widget _buildServiceTypeSelector(BuildContext context) {
    final services = [
      'Consultoria',
      'Desenvolvimento',
      'Design',
      'Marketing',
      'Treinamento',
      'Outro',
    ];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tipo de Serviço',
          style: GoogleFonts.nunito(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: FlutterFlowTheme.of(context).primaryText,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).primaryBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: FlutterFlowTheme.of(context).primary.withValues(alpha: 0.1),
              width: 1,
            ),
          ),
          child: DropdownButtonFormField<String>(
            value: _model.selectedServiceType,
            hint: Text(
              'Selecione o tipo',
              style: GoogleFonts.nunito(
                fontSize: 14,
                color: FlutterFlowTheme.of(context).secondaryText.withValues(alpha: 0.5),
              ),
            ),
            icon: Icon(
              Icons.keyboard_arrow_down,
              color: FlutterFlowTheme.of(context).primary,
            ),
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.category_outlined,
                color: FlutterFlowTheme.of(context).primary,
                size: 22,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
            style: GoogleFonts.nunito(
              fontSize: 15,
              color: FlutterFlowTheme.of(context).primaryText,
            ),
            dropdownColor: FlutterFlowTheme.of(context).secondaryBackground,
            items: services.map((String service) {
              return DropdownMenuItem<String>(
                value: service,
                child: Text(service),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _model.selectedServiceType = newValue;
              });
            },
          ),
        ),
      ],
    );
  }
  
  Widget _buildSubmitButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _model.isLoading ? null : () {
          // Aqui você implementará a lógica de emissão
          _emitirNota();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: FlutterFlowTheme.of(context).primary,
          foregroundColor: Colors.white,
          elevation: 8,
          shadowColor: FlutterFlowTheme.of(context).primary.withValues(alpha: 0.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: _model.isLoading
            ? SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  strokeWidth: 3,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle_outline, size: 24),
                  const SizedBox(width: 12),
                  Text(
                    'Emitir Nota Fiscal',
                    style: GoogleFonts.nunito(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
  
  void _emitirNota() async {
    // Validações básicas
    if (_model.clienteController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Por favor, informe o cliente'),
          backgroundColor: FlutterFlowTheme.of(context).error,
        ),
      );
      return;
    }
    
    if (_model.selectedServiceType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Por favor, selecione o tipo de serviço'),
          backgroundColor: FlutterFlowTheme.of(context).error,
        ),
      );
      return;
    }
    
    if (_model.descricaoController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Por favor, descreva o serviço'),
          backgroundColor: FlutterFlowTheme.of(context).error,
        ),
      );
      return;
    }
    
    if (_model.valorController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Por favor, informe o valor'),
          backgroundColor: FlutterFlowTheme.of(context).error,
        ),
      );
      return;
    }
    
    setState(() {
      _model.isLoading = true;
    });
    
    // Simula processamento
    await Future.delayed(const Duration(seconds: 2));
    
    setState(() {
      _model.isLoading = false;
    });
    
    // Mostra sucesso
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            Text('NFS-e emitida com sucesso!'),
          ],
        ),
        backgroundColor: const Color(0xFF4CAF50),
        duration: const Duration(seconds: 3),
      ),
    );
    
    // Limpa o formulário
    _model.clienteController.clear();
    _model.descricaoController.clear();
    _model.valorController.clear();
    setState(() {
      _model.selectedServiceType = null;
    });
  }
}

