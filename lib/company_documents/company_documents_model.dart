import '/flutter_flow/flutter_flow_util.dart';
import 'company_documents_widget.dart' show CompanyDocumentsWidget;
import 'package:flutter/material.dart';

class CompanyDocumentsModel extends FlutterFlowModel<CompanyDocumentsWidget> {
  bool isLoading = false;
  bool isLoadingMore = false;
  bool isRefreshing = false;

  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    searchController.dispose();
    searchFocusNode.dispose();
  }
}
