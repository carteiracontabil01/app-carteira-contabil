import '/app_state.dart';
import '/auth/supabase_auth/auth_util.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/home/widgets/home_surface_tokens.dart';
import '/meus_dados/formatters/profile_input_formatters.dart';
import '/meus_dados/models/profile_form_data.dart';
import '/meus_dados/services/meus_dados_service.dart';
import '/meus_dados/widgets/meus_dados_avatar_picker.dart';
import '/meus_dados/widgets/meus_dados_form_field.dart';
import 'meus_dados_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:typed_data';

export 'meus_dados_model.dart';

class MeusDadosWidget extends StatefulWidget {
  const MeusDadosWidget({super.key});

  static String routeName = 'MeusDados';
  static String routePath = 'meusDados';

  @override
  State<MeusDadosWidget> createState() => _MeusDadosWidgetState();
}

class _MeusDadosWidgetState extends State<MeusDadosWidget> {
  late MeusDadosModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final _service = MeusDadosService();
  final _imagePicker = ImagePicker();

  late final TextEditingController _nomeController;
  late final TextEditingController _emailController;
  late final TextEditingController _telefoneController;

  bool _isLoading = true;
  bool _isSaving = false;
  bool _isUploadingPhoto = false;
  String? _imageUrl;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MeusDadosModel());
    _nomeController = TextEditingController();
    _emailController = TextEditingController(text: currentUserEmail);
    _telefoneController = TextEditingController();
    _hydrateFromCurrentUser();
  }

  void _hydrateFromCurrentUser() {
    final profile = _service.loadFromCurrentUser();
    _nomeController.text = profile.fullName;
    _emailController.text =
        profile.email.isNotEmpty ? profile.email : currentUserEmail;
    _telefoneController.text = profile.phone;
    _imageUrl = profile.imageUrl;
    _isLoading = false;
    if (mounted) {
      setState(() {});
    }
  }

  ProfileFormData _collectFormData() {
    return ProfileFormData(
      fullName: _nomeController.text.trim(),
      email: _emailController.text.trim(),
      phone: _telefoneController.text.trim(),
      imageUrl: _imageUrl?.trim(),
    );
  }

  Future<void> _saveData() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isSaving = true);
    try {
      await _service.saveProfile(_collectFormData());
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Dados atualizados com sucesso!',
            style: GoogleFonts.nunito(
              color: FlutterFlowTheme.of(context).tertiary,
              fontWeight: FontWeight.w700,
            ),
          ),
          backgroundColor: FlutterFlowTheme.of(context).primary,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Não foi possível salvar seus dados. Tente novamente.',
            style: GoogleFonts.nunito(),
          ),
          backgroundColor: FlutterFlowTheme.of(context).error,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
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
                  'Escolha uma opção',
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
                    _pickImage(ImageSource.gallery);
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
                    _pickImage(ImageSource.camera);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
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
      await _uploadPhoto(
        fileBytes: bytes,
        fileExtension: extension.isEmpty ? 'jpg' : extension,
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Não foi possível selecionar a imagem.',
            style: GoogleFonts.nunito(),
          ),
          backgroundColor: FlutterFlowTheme.of(context).error,
        ),
      );
    }
  }

  Future<void> _uploadPhoto({
    required Uint8List fileBytes,
    required String fileExtension,
  }) async {
    final companyUserId = FFAppState().companyUserId;
    if (companyUserId == null || companyUserId.isEmpty) return;

    setState(() => _isUploadingPhoto = true);
    try {
      final imageUrl = await _service.uploadAvatar(
        companyUserId: companyUserId,
        fileBytes: fileBytes,
        fileExtension: fileExtension,
      );
      _imageUrl = imageUrl;
      await _service.saveProfile(_collectFormData());

      if (!mounted) return;
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Foto atualizada com sucesso!',
            style: GoogleFonts.nunito(
              color: FlutterFlowTheme.of(context).tertiary,
              fontWeight: FontWeight.w700,
            ),
          ),
          backgroundColor: FlutterFlowTheme.of(context).primary,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Não foi possível atualizar sua foto.',
            style: GoogleFonts.nunito(),
          ),
          backgroundColor: FlutterFlowTheme.of(context).error,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isUploadingPhoto = false);
      }
    }
  }

  @override
  void dispose() {
    _model.dispose();
    _nomeController.dispose();
    _emailController.dispose();
    _telefoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

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
            'Meus Dados',
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
        body: _isLoading
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
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                      child: Container(
                        decoration: HomeSurfaceTokens.cardDecoration(
                          theme,
                          radius: 20,
                        ),
                        padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            MeusDadosAvatarPicker(
                              imageUrl: _imageUrl,
                              isUploading: _isUploadingPhoto,
                              onTap: _isUploadingPhoto
                                  ? null
                                  : _showImageSourceDialog,
                            ),
                            const SizedBox(height: 24),
                            MeusDadosFormField(
                              label: 'Nome Completo',
                              controller: _nomeController,
                              hintText: 'Digite seu nome completo',
                              icon: Icons.person_outline_rounded,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Nome é obrigatório';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            MeusDadosFormField(
                              label: 'E-mail',
                              controller: _emailController,
                              hintText: 'E-mail',
                              icon: Icons.email_outlined,
                              enabled: false,
                              keyboardType: TextInputType.emailAddress,
                            ),
                            const SizedBox(height: 16),
                            MeusDadosFormField(
                              label: 'Telefone',
                              controller: _telefoneController,
                              hintText: '(00) 0000-0000 ou (00) 00000-0000',
                              icon: Icons.phone_outlined,
                              keyboardType: TextInputType.phone,
                              inputFormatters: const [PhoneInputFormatter()],
                            ),
                            const SizedBox(height: 24),
                            SizedBox(
                              height: 54,
                              child: FilledButton.icon(
                                onPressed: _isSaving ? null : _saveData,
                                icon: _isSaving
                                    ? SizedBox(
                                        width: 18,
                                        height: 18,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                            theme.tertiary,
                                          ),
                                        ),
                                      )
                                    : const Icon(Icons.check_rounded, size: 20),
                                label: Text(
                                  _isSaving
                                      ? 'Salvando...'
                                      : 'Salvar Alterações',
                                  style: GoogleFonts.nunito(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                style: FilledButton.styleFrom(
                                  backgroundColor: theme.primary,
                                  foregroundColor: theme.tertiary,
                                  disabledBackgroundColor:
                                      theme.primary.withValues(alpha: 0.55),
                                  disabledForegroundColor: theme.tertiary,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
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
              ),
      ),
    );
  }
}
