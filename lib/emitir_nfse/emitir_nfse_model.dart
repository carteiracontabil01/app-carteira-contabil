import '/flutter_flow/flutter_flow_util.dart';
import 'emitir_nfse_widget.dart' show EmitirNfseWidget;
import 'package:flutter/material.dart';

class EmitirNfseModel extends FlutterFlowModel<EmitirNfseWidget> {
  final formKey = GlobalKey<FormState>();

  final TextEditingController descricaoController = TextEditingController();
  final TextEditingController valorController = TextEditingController();
  final TextEditingController customerSearchController =
      TextEditingController();
  final TextEditingController municipioSearchController =
      TextEditingController();

  final FocusNode descricaoFocusNode = FocusNode();
  final FocusNode valorFocusNode = FocusNode();
  final FocusNode customerSearchFocusNode = FocusNode();
  final FocusNode municipioSearchFocusNode = FocusNode();

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    descricaoController.dispose();
    valorController.dispose();
    customerSearchController.dispose();
    municipioSearchController.dispose();
    descricaoFocusNode.dispose();
    valorFocusNode.dispose();
    customerSearchFocusNode.dispose();
    municipioSearchFocusNode.dispose();
  }
}
