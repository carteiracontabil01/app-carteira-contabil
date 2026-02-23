import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'redefinir_senha_widget.dart';

class RedefinirSenhaModel extends FlutterFlowModel<RedefinirSenhaWidget> {
  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  // State field(s) for senha widget.
  FocusNode? senhaFocusNode;
  TextEditingController? senhaTextController;
  bool senhaVisibility = false;
  String? Function(BuildContext, String?)? senhaTextControllerValidator;

  // State field(s) for confirmSenha widget.
  FocusNode? confirmSenhaFocusNode;
  TextEditingController? confirmSenhaTextController;
  bool confirmSenhaVisibility = false;
  String? Function(BuildContext, String?)? confirmSenhaTextControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    senhaFocusNode?.dispose();
    senhaTextController?.dispose();

    confirmSenhaFocusNode?.dispose();
    confirmSenhaTextController?.dispose();
  }
}

