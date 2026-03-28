import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'servicos_catalog.dart';
import 'servicos_repository.dart';
import 'solicitar_servico_model.dart';

class SolicitarServicoWidget extends StatefulWidget {
  const SolicitarServicoWidget({super.key});

  static String routeName = 'solicitarServico';
  static String routePath = 'solicitar-servico';

  @override
  State<SolicitarServicoWidget> createState() => _SolicitarServicoWidgetState();
}

class _SolicitarServicoWidgetState extends State<SolicitarServicoWidget> {
  late SolicitarServicoModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  int _autocompleteResetKey = 0;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SolicitarServicoModel());
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final currency = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

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
            onPressed: () => context.safePop(),
          ),
          title: Text(
            'Solicitar serviço',
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Nova solicitação',
                        style: GoogleFonts.nunito(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.3,
                          color: theme.secondaryText,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _buildServicoAutocomplete(context, _autocompleteResetKey),
                      const SizedBox(height: 14),
                      if (_model.selectedServico != null) ...[
                        _buildPrecoBlock(context, currency),
                        const SizedBox(height: 14),
                      ],
                      _fieldLabel(context, 'Observações'),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _model.observacaoController,
                        focusNode: _model.observacaoFocusNode,
                        maxLines: 4,
                        minLines: 3,
                        style: GoogleFonts.nunito(
                          fontSize: 15,
                          color: theme.primaryText,
                        ),
                        decoration: _inputDecoration(
                          context,
                          hint: 'Detalhe o que você precisa…',
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: FilledButton(
                          onPressed: _model.isSubmitting
                              ? null
                              : () => _solicitar(currency),
                          style: FilledButton.styleFrom(
                            backgroundColor: theme.primary,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: _model.isSubmitting
                              ? SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color:
                                        Colors.white.withValues(alpha: 0.95),
                                  ),
                                )
                              : Text(
                                  'Enviar solicitação',
                                  style: GoogleFonts.nunito(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
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

  InputDecoration _inputDecoration(
    BuildContext context, {
    required String hint,
  }) {
    final theme = FlutterFlowTheme.of(context);
    final borderColor = theme.primaryText.withValues(alpha: 0.1);
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.nunito(
        fontSize: 15,
        color: theme.secondaryText.withValues(alpha: 0.55),
      ),
      filled: true,
      fillColor: theme.secondaryBackground,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
    );
  }

  Widget _buildServicoAutocomplete(BuildContext context, int resetKey) {
    final theme = FlutterFlowTheme.of(context);
    final catalog = servicosCatalogo;

    return Column(
      key: ValueKey<int>(resetKey),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _fieldLabel(context, 'Serviço'),
        const SizedBox(height: 8),
        Autocomplete<ServicoCatalogoItem>(
          displayStringForOption: (o) => o.nome,
          optionsBuilder: (TextEditingValue value) {
            final q = value.text.trim().toLowerCase();
            if (q.isEmpty) {
              return catalog;
            }
            return catalog
                .where((e) => e.nome.toLowerCase().contains(q))
                .toList();
          },
          onSelected: (ServicoCatalogoItem s) {
            setState(() {
              _model.selectedServico = s;
              _model.valorOpcionalController?.clear();
            });
          },
          fieldViewBuilder: (
            BuildContext context,
            TextEditingController textEditingController,
            FocusNode focusNode,
            VoidCallback onFieldSubmitted,
          ) {
            return TextField(
              controller: textEditingController,
              focusNode: focusNode,
              onChanged: (v) {
                if (v.isEmpty) {
                  setState(() {
                    _model.selectedServico = null;
                    _model.valorOpcionalController?.clear();
                  });
                }
              },
              style: GoogleFonts.nunito(
                fontSize: 15,
                color: theme.primaryText,
              ),
              decoration: _inputDecoration(
                context,
                hint: 'Buscar e selecionar serviço…',
              ).copyWith(
                suffixIcon: Icon(
                  Icons.search_rounded,
                  color: theme.secondaryText,
                  size: 22,
                ),
              ),
            );
          },
          optionsViewBuilder: (context, onSelected, options) {
            final opts = options.toList();
            return Align(
              alignment: Alignment.topLeft,
              child: Material(
                elevation: 6,
                borderRadius: BorderRadius.circular(10),
                color: theme.secondaryBackground,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 240),
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: opts.length,
                    itemBuilder: (context, index) {
                      final option = opts[index];
                      return InkWell(
                        onTap: () => onSelected(option),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  option.nome,
                                  style: GoogleFonts.nunito(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: theme.primaryText,
                                  ),
                                ),
                              ),
                              if (option.precoFixo != null)
                                Text(
                                  NumberFormat.currency(
                                    locale: 'pt_BR',
                                    symbol: 'R\$',
                                  ).format(option.precoFixo),
                                  style: GoogleFonts.nunito(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: theme.primary,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildPrecoBlock(
    BuildContext context,
    NumberFormat currency,
  ) {
    final theme = FlutterFlowTheme.of(context);
    final s = _model.selectedServico!;

    if (s.precoFixo != null) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: theme.primary.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: theme.primary.withValues(alpha: 0.2),
          ),
        ),
        child: Row(
          children: [
            Icon(Icons.payments_outlined, color: theme.primary, size: 22),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Valor do serviço',
                style: GoogleFonts.nunito(
                  fontSize: 13,
                  color: theme.secondaryText,
                ),
              ),
            ),
            Text(
              currency.format(s.precoFixo),
              style: GoogleFonts.nunito(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: theme.primaryText,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _fieldLabel(context, 'Valor pretendido (opcional)'),
        const SizedBox(height: 8),
        TextFormField(
          controller: _model.valorOpcionalController,
          focusNode: _model.valorOpcionalFocusNode,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
          ],
          style: GoogleFonts.nunito(fontSize: 15, color: theme.primaryText),
          decoration: _inputDecoration(
            context,
            hint: 'Ex.: 1500,00',
          ),
        ),
      ],
    );
  }

  Future<void> _solicitar(NumberFormat currency) async {
    final theme = FlutterFlowTheme.of(context);

    void snack(String msg, {bool error = true}) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(msg, style: GoogleFonts.nunito()),
          backgroundColor: error ? theme.error : theme.success,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }

    if (_model.selectedServico == null) {
      snack('Selecione um serviço na lista.');
      return;
    }

    final obs = _model.observacaoController?.text.trim() ?? '';
    if (obs.isEmpty) {
      snack('Preencha o campo de observações.');
      return;
    }

    double? valorOpcional;
    final sel = _model.selectedServico!;
    if (sel.precoFixo == null) {
      final v = _model.valorOpcionalController?.text.trim() ?? '';
      if (v.isNotEmpty) {
        final parsed = double.tryParse(v.replaceAll(',', '.'));
        if (parsed == null) {
          snack('Valor opcional inválido.');
          return;
        }
        valorOpcional = parsed;
      }
    }

    setState(() => _model.isSubmitting = true);
    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;

    final id = 'sol-${DateTime.now().millisecondsSinceEpoch}';
    ServicosRepository.instance.add(
      SolicitacaoServico(
        id: id,
        servicoNome: sel.nome,
        precoCatalogo: sel.precoFixo,
        valorInformadoOpcional: valorOpcional,
        observacao: obs,
        status: 'Pendente',
        solicitadoEm: DateTime.now(),
      ),
    );

    setState(() {
      _model.isSubmitting = false;
      _model.clearForm();
      _autocompleteResetKey++;
    });

    snack('Solicitação enviada.', error: false);
    FocusScope.of(context).unfocus();
    if (mounted) context.safePop();
  }
}
