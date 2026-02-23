import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'login_widget.dart' show LoginWidget;
import 'package:flutter/material.dart';

class LoginModel extends FlutterFlowModel<LoginWidget> {
  ///  State fields for stateful widgets in this page.

  final formKey1 = GlobalKey<FormState>();
  final formKey2 = GlobalKey<FormState>();
  final formKey3 = GlobalKey<FormState>();
  // State field(s) for emailAddress widget.
  FocusNode? emailAddressFocusNode;
  TextEditingController? emailAddressTextController;
  String? Function(BuildContext, String?)? emailAddressTextControllerValidator;
  // State field(s) for password widget.
  FocusNode? passwordFocusNode;
  TextEditingController? passwordTextController;
  late bool passwordVisibility;
  String? Function(BuildContext, String?)? passwordTextControllerValidator;
  // State field(s) for fullName_Create widget.
  FocusNode? fullNameCreateFocusNode;
  TextEditingController? fullNameCreateTextController;
  String? Function(BuildContext, String?)?
      fullNameCreateTextControllerValidator;
  // State field(s) for cpf_Create widget.
  FocusNode? cpfCreateFocusNode;
  TextEditingController? cpfCreateTextController;
  String? Function(BuildContext, String?)? cpfCreateTextControllerValidator;
  // State field(s) for phone_Create widget.
  FocusNode? phoneCreateFocusNode;
  TextEditingController? phoneCreateTextController;
  String? Function(BuildContext, String?)? phoneCreateTextControllerValidator;
  // State field(s) for emailAddress_Create widget.
  FocusNode? emailAddressCreateFocusNode;
  TextEditingController? emailAddressCreateTextController;
  String? Function(BuildContext, String?)?
      emailAddressCreateTextControllerValidator;
  // State field(s) for password_Create widget.
  FocusNode? passwordCreateFocusNode;
  TextEditingController? passwordCreateTextController;
  late bool passwordCreateVisibility;
  String? Function(BuildContext, String?)?
      passwordCreateTextControllerValidator;
  // State field(s) for passwordConfirm widget.
  FocusNode? passwordConfirmFocusNode;
  TextEditingController? passwordConfirmTextController;
  late bool passwordConfirmVisibility;
  String? Function(BuildContext, String?)?
      passwordConfirmTextControllerValidator;
  // State field(s) for emailAddressReset widget.
  FocusNode? emailAddressResetFocusNode;
  TextEditingController? emailAddressResetTextController;
  String? Function(BuildContext, String?)?
      emailAddressResetTextControllerValidator;

  @override
  void initState(BuildContext context) {
    passwordVisibility = false;
    passwordCreateVisibility = false;
    passwordConfirmVisibility = false;
  }

  @override
  void dispose() {
    emailAddressFocusNode?.dispose();
    emailAddressTextController?.dispose();

    passwordFocusNode?.dispose();
    passwordTextController?.dispose();

    fullNameCreateFocusNode?.dispose();
    fullNameCreateTextController?.dispose();

    cpfCreateFocusNode?.dispose();
    cpfCreateTextController?.dispose();

    phoneCreateFocusNode?.dispose();
    phoneCreateTextController?.dispose();

    emailAddressCreateFocusNode?.dispose();
    emailAddressCreateTextController?.dispose();

    passwordCreateFocusNode?.dispose();
    passwordCreateTextController?.dispose();

    passwordConfirmFocusNode?.dispose();
    passwordConfirmTextController?.dispose();

    emailAddressResetFocusNode?.dispose();
    emailAddressResetTextController?.dispose();
  }
}
