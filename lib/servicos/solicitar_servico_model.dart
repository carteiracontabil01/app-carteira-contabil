import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'servicos_catalog.dart' show ServicoCatalogoItem;
import 'solicitar_servico_widget.dart' show SolicitarServicoWidget;
class SolicitarServicoModel extends FlutterFlowModel<SolicitarServicoWidget> {
  TextEditingController? observacaoController;
  TextEditingController? valorOpcionalController;
  FocusNode? observacaoFocusNode;
  FocusNode? valorOpcionalFocusNode;

  ServicoCatalogoItem? selectedServico;
  bool isSubmitting = false;

  @override
  void initState(BuildContext context) {
    observacaoController = TextEditingController();
    valorOpcionalController = TextEditingController();
    observacaoFocusNode = FocusNode();
    valorOpcionalFocusNode = FocusNode();
  }

  void clearForm() {
    selectedServico = null;
    observacaoController?.clear();
    valorOpcionalController?.clear();
  }

  @override
  void dispose() {
    observacaoController?.dispose();
    valorOpcionalController?.dispose();
    observacaoFocusNode?.dispose();
    valorOpcionalFocusNode?.dispose();
  }
}
