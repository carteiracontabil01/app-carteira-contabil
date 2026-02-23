import '/flutter_flow/flutter_flow_util.dart';
import 'alterar_email_widget.dart' show AlterarEmailWidget;
import 'package:flutter/material.dart';

class AlterarEmailModel extends FlutterFlowModel<AlterarEmailWidget> {
  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  
  // State field(s) for email widget.
  FocusNode? emailFocusNode;
  TextEditingController? emailTextController;
  String? Function(BuildContext, String?)? emailTextControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    emailFocusNode?.dispose();
    emailTextController?.dispose();
  }
}

