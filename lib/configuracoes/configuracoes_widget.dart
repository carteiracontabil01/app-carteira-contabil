import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/home/widgets/home_surface_tokens.dart';
import '/services/biometric_service.dart';
import '/services/secure_storage_service.dart';
import '/services/settings_service.dart';
import '/seguranca/widgets/biometric_credentials_dialog.dart';
import 'configuracoes_model.dart';
import 'widgets/settings_option_tile.dart';
import 'widgets/settings_section_title.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

export 'configuracoes_model.dart';

class ConfiguracoesWidget extends StatefulWidget {
  const ConfiguracoesWidget({super.key});

  static String routeName = 'Configuracoes';
  static String routePath = 'configuracoes';

  @override
  State<ConfiguracoesWidget> createState() => _ConfiguracoesWidgetState();
}

class _ConfiguracoesWidgetState extends State<ConfiguracoesWidget> {
  late ConfiguracoesModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final _settingsService = SettingsService();
  final _biometricService = BiometricService();
  final _secureStorage = SecureStorageService();

  bool _loadingSettings = true;
  bool _notificacoesEntregas = true;
  bool _modoEscuro = false;
  bool _vibracao = true;
  bool _sons = true;

  bool _biometricAvailable = false;
  bool _biometricEnabled = false;
  String _biometricType = 'Biometria';
  bool _isTogglingBiometric = false;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ConfiguracoesModel());
    _loadSettings();
    _checkBiometricStatus();
  }

  Future<void> _loadSettings() async {
    final settings = await _settingsService.loadSettings();
    if (!mounted) return;
    setState(() {
      _notificacoesEntregas = settings.notificationsOrders;
      _modoEscuro = settings.darkMode;
      _vibracao = settings.vibration;
      _sons = settings.appSounds;
      _loadingSettings = false;
    });
  }

  Future<void> _checkBiometricStatus() async {
    final isAvailable = await _biometricService.isBiometricAvailable();
    final isEnabled = await _secureStorage.isBiometricEnabled();
    final biometricType = await _biometricService.getBiometricTypeDescription();

    if (!mounted) return;
    setState(() {
      _biometricAvailable = isAvailable;
      _biometricEnabled = isEnabled;
      _biometricType = biometricType;
    });
  }

  Future<void> _toggleBiometric(bool value) async {
    if (_isTogglingBiometric) return;
    setState(() => _isTogglingBiometric = true);
    try {
      if (value) {
        final hasEnrolled = await _biometricService.hasBiometricsEnrolled();
        if (!hasEnrolled) {
          _showSnack(
            message:
                'Configure $_biometricType nas configurações do dispositivo primeiro.',
            backgroundColor: FlutterFlowTheme.of(context).warning,
          );
          return;
        }

        if (!mounted) return;
        final credentials = await showBiometricCredentialsDialog(
          context,
          '',
        );
        if (credentials == null) return;

        await _secureStorage.saveCredentials(
          email: credentials.email,
          password: credentials.password,
        );
        await _secureStorage.setBiometricEnabled(true);
        if (!mounted) return;
        setState(() => _biometricEnabled = true);
        _showSnack(
          message: '$_biometricType ativado com sucesso!',
          backgroundColor: FlutterFlowTheme.of(context).success,
        );
      } else {
        await _secureStorage.setBiometricEnabled(false);
        if (!mounted) return;
        setState(() => _biometricEnabled = false);
        _showSnack(
          message: '$_biometricType desativado',
          backgroundColor: FlutterFlowTheme.of(context).info,
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isTogglingBiometric = false);
      }
    }
  }

  void _showSnack({
    required String message,
    required Color backgroundColor,
  }) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: GoogleFonts.nunito(),
        ),
        backgroundColor: backgroundColor,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _setNotificacoesEntrega(bool value) async {
    setState(() => _notificacoesEntregas = value);
    await _settingsService.setNotificacoesPedidos(value);
  }

  Future<void> _setModoEscuro(bool value) async {
    setState(() => _modoEscuro = value);
    await _settingsService.setModoEscuro(value);
    _showSnack(
      message: 'Modo escuro ${value ? 'ativado' : 'desativado'}.',
      backgroundColor: FlutterFlowTheme.of(context).info,
    );
  }

  Future<void> _setSons(bool value) async {
    setState(() => _sons = value);
    await _settingsService.setSons(value);
  }

  Future<void> _setVibracao(bool value) async {
    setState(() => _vibracao = value);
    await _settingsService.setVibracao(value);
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Widget _buildCardSection(List<Widget> children) {
    final theme = FlutterFlowTheme.of(context);
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      decoration: HomeSurfaceTokens.cardDecoration(theme, radius: 20),
      child: Column(children: children),
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
          surfaceTintColor: Colors.transparent,
          scrolledUnderElevation: 0,
          toolbarHeight: 68,
          titleSpacing: 0,
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: theme.tertiary,
              size: 22,
            ),
            onPressed: () => context.safePop(),
          ),
          title: Text(
            'Configurações',
            style: GoogleFonts.nunito(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: theme.tertiary,
            ),
          ),
          centerTitle: true,
          elevation: 0,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Divider(
              height: 1,
              color: theme.tertiary.withValues(alpha: 0.22),
            ),
          ),
        ),
        body: _loadingSettings
            ? Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(theme.primary),
                ),
              )
            : SafeArea(
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
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SettingsSectionTitle(title: 'Notificações'),
                        _buildCardSection([
                          SettingsOptionTile(
                            icon: Icons.notifications_active_outlined,
                            title: 'Notificações da Empresa',
                            subtitle:
                                'Receba alertas importantes e atualizações',
                            switchValue: _notificacoesEntregas,
                            onSwitchChanged: _setNotificacoesEntrega,
                          ),
                        ]),
                        const SettingsSectionTitle(title: 'Aparência'),
                        _buildCardSection([
                          SettingsOptionTile(
                            icon: Icons.dark_mode_outlined,
                            title: 'Modo Escuro',
                            subtitle: 'Ativar tema escuro',
                            switchValue: _modoEscuro,
                            onSwitchChanged: _setModoEscuro,
                          ),
                        ]),
                        const SettingsSectionTitle(title: 'Som e Vibração'),
                        _buildCardSection([
                          SettingsOptionTile(
                            icon: Icons.volume_up_outlined,
                            title: 'Sons do App',
                            subtitle: 'Reproduzir sons de notificações',
                            switchValue: _sons,
                            onSwitchChanged: _setSons,
                            showDivider: true,
                          ),
                          SettingsOptionTile(
                            icon: Icons.vibration_outlined,
                            title: 'Vibração',
                            subtitle: 'Vibrar ao receber notificações',
                            switchValue: _vibracao,
                            onSwitchChanged: _setVibracao,
                          ),
                        ]),
                        const SettingsSectionTitle(title: 'Privacidade e Segurança'),
                        _buildCardSection([
                          if (_biometricAvailable)
                            SettingsOptionTile(
                              icon: Icons.fingerprint_rounded,
                              title: 'Login com $_biometricType',
                              subtitle: 'Entre rapidamente usando biometria',
                              switchValue: _biometricEnabled,
                              onSwitchChanged:
                                  _isTogglingBiometric ? null : _toggleBiometric,
                              showDivider: true,
                            ),
                          SettingsOptionTile(
                            icon: Icons.lock_outline_rounded,
                            title: 'Alterar Senha',
                            subtitle: 'Modificar sua senha de acesso',
                            onTap: () => context.pushNamed('recuperarsenha'),
                            showDivider: true,
                          ),
                          SettingsOptionTile(
                            icon: Icons.privacy_tip_outlined,
                            title: 'Política de Privacidade',
                            subtitle: 'Leia nossa política de privacidade',
                            onTap: () => context.pushNamed('politicaPrivacidade'),
                            showDivider: true,
                          ),
                          SettingsOptionTile(
                            icon: Icons.description_outlined,
                            title: 'Termos de Uso',
                            subtitle: 'Leia nossos termos de uso',
                            onTap: () => context.pushNamed('termosUso'),
                          ),
                        ]),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
