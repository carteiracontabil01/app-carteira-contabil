import '/flutter_flow/flutter_flow_util.dart';
import 'emitir_nfse_widget.dart' show EmitirNfseWidget;
import 'package:flutter/material.dart';

class EmitirNfseModel extends FlutterFlowModel<EmitirNfseWidget> {
  // Form controllers
  final TextEditingController descricaoController = TextEditingController();
  final TextEditingController valorController = TextEditingController();
  final TextEditingController clienteController = TextEditingController();
  
  // Form focus nodes
  final FocusNode descricaoFocusNode = FocusNode();
  final FocusNode valorFocusNode = FocusNode();
  final FocusNode clienteFocusNode = FocusNode();
  
  // Estado
  bool isLoading = false;
  String? selectedServiceType;
  
  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    descricaoController.dispose();
    valorController.dispose();
    clienteController.dispose();
    descricaoFocusNode.dispose();
    valorFocusNode.dispose();
    clienteFocusNode.dispose();
  }
}

