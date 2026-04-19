import 'dart:async';

import '/app_state.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/home/widgets/home_surface_tokens.dart';
import '/services/company_documents_service.dart';
import 'company_documents_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

export 'company_documents_model.dart';

class CompanyDocumentsWidget extends StatefulWidget {
  const CompanyDocumentsWidget({super.key});

  static String routeName = 'companyDocuments';
  static String routePath = 'documentos-empresa';

  @override
  State<CompanyDocumentsWidget> createState() => _CompanyDocumentsWidgetState();
}

class _BreadcrumbItem {
  const _BreadcrumbItem({
    required this.id,
    required this.label,
  });

  final String? id;
  final String label;
}

class _CompanyDocumentsWidgetState extends State<CompanyDocumentsWidget> {
  late CompanyDocumentsModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  Timer? _searchDebounce;

  static const int _pageSize = 20;

  final List<_BreadcrumbItem> _breadcrumbs = <_BreadcrumbItem>[
    const _BreadcrumbItem(id: null, label: 'Documentos'),
  ];
  final List<CompanyDocumentNode> _nodes = <CompanyDocumentNode>[];

  String? _currentParentId;
  int _currentPage = 1;
  int _totalFolders = 0;
  int _totalFiles = 0;
  bool _hasNext = false;
  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CompanyDocumentsModel());
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadDocuments(reset: true));
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _model.dispose();
    super.dispose();
  }

  Future<void> _loadDocuments({required bool reset}) async {
    final appState = context.read<FFAppState>();
    final companyId = appState.companyId;
    if (companyId == null || companyId.isEmpty) return;

    if (reset) {
      _model.isLoading = true;
      _currentPage = 1;
      _hasNext = false;
    } else {
      if (_model.isLoadingMore || !_hasNext) return;
      _model.isLoadingMore = true;
    }
    if (mounted) setState(() {});

    final response = await CompanyDocumentsService.getSharedDocumentsPaginated(
      companyId: companyId,
      parentId: _currentParentId,
      page: _currentPage,
      pageSize: _pageSize,
      search: _currentSearch,
    );

    if (!mounted) return;
    if (reset) {
      _nodes
        ..clear()
        ..addAll(response.data);
    } else {
      _nodes.addAll(response.data);
    }

    _hasNext = response.hasNext;
    _totalFolders = response.totalFolders;
    _totalFiles = response.totalFiles;

    _model.isLoading = false;
    _model.isLoadingMore = false;
    _model.isRefreshing = false;
    setState(() {});
  }

  Future<void> _onRefresh() async {
    _model.isRefreshing = true;
    if (mounted) setState(() {});
    await _loadDocuments(reset: true);
  }

  String? get _currentSearch {
    final raw = _model.searchController.text.trim();
    return raw.isEmpty ? null : raw;
  }

  void _onSearchChanged(String _) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 350), () {
      if (!mounted) return;
      _loadDocuments(reset: true);
    });
  }

  void _openFolder(CompanyDocumentNode node) {
    if (!node.isFolder) return;
    _currentParentId = node.id;
    _breadcrumbs.add(_BreadcrumbItem(id: node.id, label: node.name));
    _model.searchController.clear();
    _loadDocuments(reset: true);
  }

  void _goToBreadcrumb(int index) {
    final crumb = _breadcrumbs[index];
    _breadcrumbs.removeRange(index + 1, _breadcrumbs.length);
    _currentParentId = crumb.id;
    _model.searchController.clear();
    _loadDocuments(reset: true);
  }

  void _goUp() {
    if (_breadcrumbs.length <= 1) return;
    _goToBreadcrumb(_breadcrumbs.length - 2);
  }

  Future<void> _openFile(CompanyDocumentNode node) async {
    final url = await CompanyDocumentsService.createSignedFileUrl(node);
    if (url == null || url.isEmpty) {
      _showSnack('Arquivo indisponível para download.');
      return;
    }

    final uri = Uri.tryParse(url);
    if (uri == null) {
      _showSnack('URL de arquivo inválida.');
      return;
    }

    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!launched) {
      _showSnack('Não foi possível abrir o documento.');
    }
  }

  String _formatBytes(int? bytes) {
    if (bytes == null || bytes <= 0) return 'Tamanho não informado';
    const units = <String>['B', 'KB', 'MB', 'GB'];
    double size = bytes.toDouble();
    int unit = 0;
    while (size >= 1024 && unit < units.length - 1) {
      size /= 1024;
      unit++;
    }
    return '${size.toStringAsFixed(unit == 0 ? 0 : 1)} ${units[unit]}';
  }

  IconData _iconForNode(CompanyDocumentNode node) {
    if (node.isFolder) return Icons.folder_rounded;
    final normalizedType = (node.documentType ?? '').toLowerCase().trim();
    if (normalizedType.contains('contrato')) return Icons.description_rounded;
    if (normalizedType.contains('procuracao') || normalizedType.contains('procuração')) {
      return Icons.gavel_rounded;
    }
    if (normalizedType.contains('declaracao') || normalizedType.contains('declaração')) {
      return Icons.assignment_rounded;
    }
    if (normalizedType.contains('certidao') || normalizedType.contains('certidão')) {
      return Icons.verified_rounded;
    }
    if (normalizedType.contains('nf') || normalizedType.contains('nota')) {
      return Icons.receipt_long_rounded;
    }

    final ext = (node.storageKey ?? node.name).split('.').last.toLowerCase();
    if (ext == 'pdf') return Icons.picture_as_pdf_rounded;
    if (ext == 'doc' || ext == 'docx') return Icons.description_rounded;
    if (ext == 'xls' || ext == 'xlsx') return Icons.table_chart_rounded;
    if (ext == 'png' || ext == 'jpg' || ext == 'jpeg' || ext == 'webp') {
      return Icons.image_rounded;
    }
    return Icons.insert_drive_file_rounded;
  }

  Color _iconColorForNode(FlutterFlowTheme theme, CompanyDocumentNode node) {
    if (node.isFolder) return theme.primary;
    final normalizedType = (node.documentType ?? '').toLowerCase().trim();
    if (normalizedType.contains('declaracao') || normalizedType.contains('declaração')) {
      return const Color(0xFF326BDE);
    }
    if (normalizedType.contains('certidao') || normalizedType.contains('certidão')) {
      return const Color(0xFF1D8B5E);
    }
    if (normalizedType.contains('nf') || normalizedType.contains('nota')) {
      return const Color(0xFF7A4FD8);
    }

    final ext = (node.storageKey ?? node.name).split('.').last.toLowerCase();
    if (ext == 'pdf') return const Color(0xFFD14343);
    if (ext == 'doc' || ext == 'docx') return const Color(0xFF2B579A);
    if (ext == 'xls' || ext == 'xlsx') return const Color(0xFF1D6F42);
    if (ext == 'png' || ext == 'jpg' || ext == 'jpeg' || ext == 'webp') {
      return const Color(0xFF8A4FFF);
    }
    return theme.secondary;
  }

  String _subtitleForNode(CompanyDocumentNode node) {
    if (node.isFolder) return 'Pasta compartilhada';
    return _formatBytes(node.fileSizeBytes);
  }

  ({String label, Color color, Color textColor})? _expirationBadge(
    FlutterFlowTheme theme,
    CompanyDocumentNode node,
  ) {
    if (!node.isFile || node.expirationDate == null) return null;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final expiration = node.expirationDate!;
    final exp = DateTime(expiration.year, expiration.month, expiration.day);
    final days = exp.difference(today).inDays;

    if (days < 0) {
      return (
        label: 'Vencido em ${_dateFormat.format(exp)}',
        color: const Color(0xFFFFE5E5),
        textColor: const Color(0xFFAF2B2B),
      );
    }
    if (days <= 30) {
      return (
        label: 'Vence em ${_dateFormat.format(exp)}',
        color: const Color(0xFFFFF3DA),
        textColor: const Color(0xFF996400),
      );
    }
    return (
      label: 'Validade ${_dateFormat.format(exp)}',
      color: theme.grayscale20,
      textColor: theme.secondaryText,
    );
  }

  void _showSnack(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: GoogleFonts.nunito(),
        ),
      ),
    );
  }

  Widget _buildBreadcrumbs(FlutterFlowTheme theme) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(_breadcrumbs.length, (index) {
          final item = _breadcrumbs[index];
          final isLast = index == _breadcrumbs.length - 1;
          return Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: isLast
                      ? theme.primary.withValues(alpha: 0.1)
                      : theme.grayscale20,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: isLast
                        ? theme.primary.withValues(alpha: 0.2)
                        : theme.grayscale30,
                  ),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(999),
                  onTap: isLast ? null : () => _goToBreadcrumb(index),
                  child: Text(
                    item.label,
                    style: GoogleFonts.nunito(
                      fontSize: 12,
                      fontWeight: isLast ? FontWeight.w800 : FontWeight.w700,
                      color: isLast ? theme.primary : theme.secondaryText,
                    ),
                  ),
                ),
              ),
              if (!isLast)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Icon(
                    Icons.chevron_right_rounded,
                    size: 16,
                    color: theme.secondaryText,
                  ),
                ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildBackToParentButton(FlutterFlowTheme theme) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: _goUp,
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: theme.primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: theme.primary.withValues(alpha: 0.18)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.arrow_back_rounded,
                size: 16,
                color: theme.primary,
              ),
              const SizedBox(width: 6),
              Text(
                'Voltar',
                style: GoogleFonts.nunito(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: theme.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(FlutterFlowTheme theme) {
    final currentFolderLabel =
        _breadcrumbs.isNotEmpty ? _breadcrumbs.last.label : 'Documentos';
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isCompactHeader = screenWidth < 390;
    final horizontalMargin = isCompactHeader ? 6.0 : 12.0;
    final topMargin = isCompactHeader ? 6.0 : 10.0;
    final horizontalPadding = isCompactHeader ? 12.0 : 14.0;

    return Container(
      margin: EdgeInsets.fromLTRB(horizontalMargin, topMargin, horizontalMargin, 12),
      padding: EdgeInsets.fromLTRB(horizontalPadding, 14, horizontalPadding, 12),
      decoration: HomeSurfaceTokens.cardDecoration(theme, radius: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isCompactHeader) ...[
            Text(
              currentFolderLabel,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.nunito(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: theme.primary,
              ),
            ),
            if (_breadcrumbs.length > 1) ...[
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: _buildBackToParentButton(theme),
              ),
            ],
          ] else
            Row(
              children: [
                Expanded(
                  child: Text(
                    currentFolderLabel,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.nunito(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: theme.primary,
                    ),
                  ),
                ),
                if (_breadcrumbs.length > 1) _buildBackToParentButton(theme),
              ],
            ),
          const SizedBox(height: 10),
          _buildBreadcrumbs(theme),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _model.searchController,
                  focusNode: _model.searchFocusNode,
                  onChanged: _onSearchChanged,
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    isDense: true,
                    prefixIcon: const Icon(Icons.search_rounded, size: 20),
                    hintText: 'Buscar pasta ou documento',
                    hintStyle: GoogleFonts.nunito(fontSize: 13),
                    filled: true,
                    fillColor: theme.secondaryBackground,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: theme.grayscale30),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: theme.grayscale30),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: theme.primary, width: 1.4),
                    ),
                  ),
                ),
              ),
              if (_model.searchController.text.trim().isNotEmpty)
                IconButton(
                  tooltip: 'Limpar busca',
                  onPressed: () {
                    _model.searchController.clear();
                    _loadDocuments(reset: true);
                  },
                  icon: Icon(
                    Icons.close_rounded,
                    color: theme.secondaryText,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'Pastas: $_totalFolders  •  Arquivos: $_totalFiles',
            style: GoogleFonts.nunito(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: theme.secondaryText,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNodeCard(FlutterFlowTheme theme, CompanyDocumentNode node) {
    final badge = _expirationBadge(theme, node);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: node.isFolder ? () => _openFolder(node) : () => _openFile(node),
        child: Ink(
          decoration: HomeSurfaceTokens.cardDecoration(theme, radius: 14),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: _iconColorForNode(theme, node).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _iconForNode(node),
                    color: _iconColorForNode(theme, node),
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        node.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.nunito(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: theme.primary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _subtitleForNode(node),
                        style: GoogleFonts.nunito(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: theme.secondaryText,
                        ),
                      ),
                      if (badge != null) ...[
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: badge.color,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            badge.label,
                            style: GoogleFonts.nunito(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              color: badge.textColor,
                              height: 1.1,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Icon(
                  node.isFolder
                      ? Icons.chevron_right_rounded
                      : Icons.open_in_new_rounded,
                  color: theme.secondaryText,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(FlutterFlowTheme theme, FFAppState appState) {
    final noCompany = appState.companyId == null || appState.companyId!.isEmpty;
    if (noCompany) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            'Selecione uma empresa para visualizar documentos.',
            textAlign: TextAlign.center,
            style: GoogleFonts.nunito(
              fontSize: 15,
              color: theme.secondaryText,
            ),
          ),
        ),
      );
    }

    if (_model.isLoading && _nodes.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return RefreshIndicator(
      color: theme.primary,
      onRefresh: _onRefresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        children: [
          _buildHeader(theme),
          if (_nodes.isEmpty && !_model.isLoading)
            Container(
              margin: const EdgeInsets.only(top: 16),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 22),
              decoration: HomeSurfaceTokens.cardDecoration(theme, radius: 16),
              child: Column(
                children: [
                  Icon(
                    Icons.folder_open_rounded,
                    size: 46,
                    color: theme.secondaryText.withValues(alpha: 0.55),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Nenhum documento compartilhado encontrado nesta pasta.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.nunito(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: theme.secondaryText,
                    ),
                  ),
                ],
              ),
            )
          else ...[
            for (final node in _nodes) ...[
              _buildNodeCard(theme, node),
              const SizedBox(height: 10),
            ],
            if (_hasNext)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: OutlinedButton.icon(
                  onPressed: _model.isLoadingMore
                      ? null
                      : () {
                          _currentPage += 1;
                          _loadDocuments(reset: false);
                        },
                  icon: _model.isLoadingMore
                      ? SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: theme.primary,
                          ),
                        )
                      : const Icon(Icons.expand_more_rounded),
                  label: Text(
                    _model.isLoadingMore ? 'Carregando...' : 'Carregar mais',
                    style: GoogleFonts.nunito(fontWeight: FontWeight.w800),
                  ),
                ),
              ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: theme.grayscale20,
        appBar: AppBar(
          backgroundColor: theme.primary,
          automaticallyImplyLeading: false,
          toolbarHeight: 68,
          titleSpacing: 0,
          scrolledUnderElevation: 0,
          surfaceTintColor: Colors.transparent,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: theme.tertiary,
              size: 22,
            ),
            onPressed: () => context.safePop(),
          ),
          title: Text(
            'Documentos da empresa',
            style: GoogleFonts.nunito(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: theme.tertiary,
            ),
          ),
          actions: [
            IconButton(
              tooltip: 'Chat',
              onPressed: () => context.pushNamed('chat'),
              icon: Icon(
                Icons.chat_bubble_outline_rounded,
                color: theme.tertiary,
                size: 21,
              ),
            ),
            IconButton(
              onPressed: () => context.pushNamed('notificacoes'),
              icon: Icon(
                Icons.notifications_outlined,
                color: theme.tertiary,
                size: 21,
              ),
            ),
          ],
          elevation: 0,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Divider(
              height: 1,
              color: theme.tertiary.withValues(alpha: 0.22),
            ),
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                theme.grayscale10,
                theme.grayscale20,
              ],
            ),
          ),
          child: Consumer<FFAppState>(
            builder: (context, appState, _) => _buildBody(theme, appState),
          ),
        ),
      ),
    );
  }
}
