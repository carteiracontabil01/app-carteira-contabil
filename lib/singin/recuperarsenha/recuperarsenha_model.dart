import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'recuperarsenha_widget.dart' show RecuperarsenhaWidget;
import 'package:flutter/material.dart';

class RecuperarsenhaModel extends FlutterFlowModel<RecuperarsenhaWidget> {
  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  // State field(s) for senha widget.
  FocusNode? senhaFocusNode;
  TextEditingController? senhaTextController;
  String? Function(BuildContext, String?)? senhaTextControllerValidator;
  // State field(s) for confirmSenha widget.
  FocusNode? confirmSenhaFocusNode;
  TextEditingController? confirmSenhaTextController;
  String? Function(BuildContext, String?)? confirmSenhaTextControllerValidator;
  // Stores action output result for [Backend Call - API (ResetPass)] action in Button widget.
  ApiCallResponse? apiResultmwa;

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
