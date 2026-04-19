import '/auth/supabase_auth/auth_util.dart';
import '/app_state.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/home/widgets/home_surface_tokens.dart';
import '/index.dart';
import '/services/company_profile_service.dart';
import 'models/profile_menu_item.dart';
import 'widgets/profile_header_card.dart';
import 'widgets/profile_menu_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'dart:typed_data';
import 'perfil_model.dart';
export 'perfil_model.dart';

class PerfilWidget extends StatefulWidget {
  const PerfilWidget({super.key});

  static String routeName = 'perfil';
  static String routePath = 'perfil';

  @override
  State<PerfilWidget> createState() => _PerfilWidgetState();
}

class _PerfilWidgetState extends State<PerfilWidget> {
  late PerfilModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _imagePicker = ImagePicker();
  bool _isUploadingCompanyPhoto = false;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PerfilModel());
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final appState = context.watch<FFAppState>();
    final companyProfile = appState.companyProfile;
    final companyName = _resolveCompanyName(appState, companyProfile);
    final rawCnpj = _resolveCompanyCnpj(companyProfile);
    final maskedCnpj = _formatCnpj(rawCnpj);
    final companyPhotoUrl = _resolveCompanyPhotoUrl(companyProfile);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: theme.grayscale20,
        appBar: AppBar(
          backgroundColor: theme.primary,
          surfaceTintColor: Colors.transparent,
          scrolledUnderElevation: 0,
          automaticallyImplyLeading: false,
          toolbarHeight: 68,
          titleSpacing: 16,
          leading: Navigator.of(context).canPop()
              ? IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: theme.tertiary,
                    size: 22,
                  ),
                  onPressed: () => context.safePop(),
                )
              : null,
          title: Text(
            'Perfil',
            style: GoogleFonts.nunito(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: theme.tertiary,
            ),
          ),
          elevation: 0,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Divider(
              height: 1,
              color: theme.tertiary.withValues(alpha: 0.22),
            ),
          ),
        ),
        body: SafeArea(
          child: Container(
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
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (loggedIn)
                    ProfileHeaderCard(
                      companyName: companyName,
                      maskedCnpj: maskedCnpj,
                      companyPhotoUrl: companyPhotoUrl,
                      isUploadingPhoto: _isUploadingCompanyPhoto,
                      onCopyCnpj: () => _copyCnpj(rawCnpj),
                      onPhotoTap: _isUploadingCompanyPhoto
                          ? null
                          : _showImageSourceDialog,
                    ),
                  _buildMainMenuGroup(context),
                  if (loggedIn) _buildLogoutGroup(context),
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Center(
                      child: Text(
                        'Versão 1.0.0',
                        style: GoogleFonts.nunito(
                          fontSize: 12,
                          color: theme.secondaryText,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMainMenuGroup(BuildContext context) {
    final items = <ProfileMenuItem>[
      ProfileMenuItem(
        icon: Icons.person_outline_rounded,
        title: 'Meus Dados',
        subtitle: 'Informações pessoais',
        showDivider: true,
        onTap: () => context.pushNamed(MeusDadosWidget.routeName),
      ),
      ProfileMenuItem(
        icon: Icons.apartment_rounded,
        title: 'Dados da Empresa',
        subtitle: 'Informações cadastrais da empresa',
        showDivider: true,
        onTap: () => context.pushNamed(DadosMinhaEmpresaWidget.routeName),
      ),
      ProfileMenuItem(
        icon: Icons.category_outlined,
        title: 'CNAEs e Serviços',
        subtitle: 'Atividades e serviços selecionados',
        showDivider: true,
        onTap: () => context.pushNamed(CnaesServicosWidget.routeName),
      ),
      ProfileMenuItem(
        icon: Icons.security_rounded,
        title: 'Segurança',
        subtitle: 'Senha, e-mail e autenticação',
        showDivider: true,
        onTap: () => context.pushNamed('seguranca'),
      ),
      ProfileMenuItem(
        icon: Icons.settings_outlined,
        title: 'Configurações',
        subtitle: 'Preferências do app',
        showDivider: true,
        onTap: () => context.pushNamed(ConfiguracoesWidget.routeName),
      ),
      ProfileMenuItem(
        icon: Icons.help_outline_rounded,
        title: 'Ajuda',
        subtitle: 'Central de ajuda e suporte',
        onTap: () => context.pushNamed(AjudaWidget.routeName),
      ),
    ];

    return _buildMenuGroupCard(context, items);
  }

  Widget _buildLogoutGroup(BuildContext context) {
    return _buildMenuGroupCard(
      context,
      [
        ProfileMenuItem(
          icon: Icons.logout_rounded,
          title: 'Sair',
          subtitle: 'Desconectar da conta',
          accentColor: Colors.red,
          onTap: () => _onLogoutTap(context),
        ),
      ],
    );
  }

  Widget _buildMenuGroupCard(
    BuildContext context,
    List<ProfileMenuItem> items,
  ) {
    final theme = FlutterFlowTheme.of(context);
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      decoration: HomeSurfaceTokens.cardDecoration(theme, radius: 20),
      child: Column(
        children: items.map((item) => ProfileMenuTile(item: item)).toList(),
      ),
    );
  }

  Future<void> _onLogoutTap(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Sair'),
        content: const Text('Tem certeza que deseja sair da sua conta?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text(
              'Sair',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await authManager.signOut();
      if (context.mounted) {
        context.goNamedAuth('onboarding', context.mounted);
      }
    }
  }

  String _resolveCompanyName(
    FFAppState appState,
    Map<String, dynamic>? profile,
  ) {
    final fromProfile = profile?['business_name']?.toString().trim() ?? '';
    if (fromProfile.isNotEmpty) return fromProfile;

    final fromState = appState.companyName?.trim() ?? '';
    if (fromState.isNotEmpty) return fromState;

    return 'Empresa';
  }

  String _resolveCompanyCnpj(Map<String, dynamic>? profile) {
    final raw = profile?['cnpj']?.toString() ?? '';
    return raw.replaceAll(RegExp(r'[^0-9]'), '');
  }

  String? _resolveCompanyPhotoUrl(Map<String, dynamic>? profile) {
    if (profile == null) return null;
    if (!profile.containsKey('photo_url')) return null;

    final raw = profile['photo_url']?.toString().trim() ?? '';
    if (raw.isEmpty || raw == 'null') return null;
    return raw;
  }

  String _formatCnpj(String digitsOnly) {
    final digits = digitsOnly.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.length != 14) return digits;
    return '${digits.substring(0, 2)}.${digits.substring(2, 5)}.'
        '${digits.substring(5, 8)}/${digits.substring(8, 12)}-'
        '${digits.substring(12, 14)}';
  }

  Future<void> _copyCnpj(String digitsOnly) async {
    final cnpj = digitsOnly.replaceAll(RegExp(r'[^0-9]'), '');
    if (cnpj.isEmpty) return;

    await Clipboard.setData(ClipboardData(text: cnpj));
    if (!mounted) return;

    final theme = FlutterFlowTheme.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'CNPJ copiado com sucesso.',
          style: GoogleFonts.nunito(
            color: theme.tertiary,
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: theme.primary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _showImageSourceDialog() async {
    final theme = FlutterFlowTheme.of(context);
    await showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Atualizar foto da empresa',
                  style: GoogleFonts.nunito(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: theme.primaryText,
                  ),
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: Icon(
                    Icons.photo_library_outlined,
                    color: theme.primary,
                  ),
                  title: Text(
                    'Galeria',
                    style: GoogleFonts.nunito(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(sheetContext);
                    _pickCompanyImage(ImageSource.gallery);
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.camera_alt_outlined,
                    color: theme.primary,
                  ),
                  title: Text(
                    'Câmera',
                    style: GoogleFonts.nunito(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(sheetContext);
                    _pickCompanyImage(ImageSource.camera);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _pickCompanyImage(ImageSource source) async {
    try {
      final pickedFile = await _imagePicker.pickImage(
        source: source,
        maxWidth: 1200,
        maxHeight: 1200,
        imageQuality: 86,
      );
      if (pickedFile == null) return;

      final bytes = await pickedFile.readAsBytes();
      final extension = pickedFile.name.split('.').last.toLowerCase();
      await _uploadCompanyPhoto(
        fileBytes: bytes,
        fileExtension: extension.isEmpty ? 'jpg' : extension,
      );
    } catch (_) {
      if (!mounted) return;
      final theme = FlutterFlowTheme.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Não foi possível selecionar a imagem.',
            style: GoogleFonts.nunito(color: theme.tertiary),
          ),
          backgroundColor: theme.error,
        ),
      );
    }
  }

  Future<void> _uploadCompanyPhoto({
    required Uint8List fileBytes,
    required String fileExtension,
  }) async {
    final appState = context.read<FFAppState>();
    final companyId = appState.companyId;
    final companyUserId = appState.companyUserId;
    final cnpj = _resolveCompanyCnpj(appState.companyProfile);

    if (companyId == null ||
        companyId.isEmpty ||
        companyUserId == null ||
        companyUserId.isEmpty ||
        cnpj.isEmpty) {
      return;
    }

    setState(() => _isUploadingCompanyPhoto = true);
    try {
      final signedUrl = await CompanyProfileService.uploadCompanyPhoto(
        companyId: companyId,
        cnpj: cnpj,
        fileBytes: fileBytes,
        fileExtension: fileExtension,
      );

      final updatedProfile = await CompanyProfileService.updateCompanyPhoto(
        companyId: companyId,
        photoUrl: signedUrl,
      );

      if (updatedProfile != null) {
        appState.setCompanyProfile(updatedProfile);
      } else {
        await CompanyProfileService.refreshIntoAppState(
          companyId: companyId,
          companyUserId: companyUserId,
        );
      }

      if (!mounted) return;
      final theme = FlutterFlowTheme.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Foto da empresa atualizada com sucesso!',
            style: GoogleFonts.nunito(
              color: theme.tertiary,
              fontWeight: FontWeight.w700,
            ),
          ),
          backgroundColor: theme.primary,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (_) {
      if (!mounted) return;
      final theme = FlutterFlowTheme.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Não foi possível atualizar a foto da empresa.',
            style: GoogleFonts.nunito(
              color: theme.tertiary,
            ),
          ),
          backgroundColor: theme.error,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isUploadingCompanyPhoto = false);
      }
    }
  }
}
