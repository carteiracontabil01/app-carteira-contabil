import '/custom_code/actions/index.dart' as actions;
import 'package:provider/provider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

import 'auth/supabase_auth/supabase_user_provider.dart';
import 'auth/supabase_auth/auth_util.dart';

import '/backend/supabase/supabase.dart';
import '/backend/firebase/firebase_config.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import 'flutter_flow/flutter_flow_util.dart';
import 'flutter_flow/internationalization.dart';
import 'package:google_fonts/google_fonts.dart';
import 'index.dart';

// White Label Configuration
import 'config/environment.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GoRouter.optionURLReflectsImperativeAPIs = true;
  usePathUrlStrategy();

  // White Label Configuration
  print('🚀 Iniciando ${appConfig.appName}');
  print('📦 Package ID: ${appConfig.appId}');
  print('🏷️  Tenant Slug: ${appConfig.tenantSlug}');
  print('🎨 Primary Color: ${appConfig.primaryColor}');

  // Inicializar Firebase
  await initFirebase();

  // Start initial custom actions code
  await actions.changeStatusBarColor();
  await actions.inicializarPushNotificationsSeguro();
  // End initial custom actions code

  await SupaFlow.initialize();

  final appState = FFAppState(); // Initialize FFAppState
  await appState.initializePersistedState();

  // Start final custom actions code
  await actions.setFCMToken();
  // End final custom actions code

  runApp(ChangeNotifierProvider(
    create: (context) => appState,
    child: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  State<MyApp> createState() => _MyAppState();

  static _MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>()!;
}

class MyAppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;

  ThemeMode _themeMode = ThemeMode.system;

  late AppStateNotifier _appStateNotifier;
  late GoRouter _router;
  String getRoute([RouteMatch? routeMatch]) {
    final RouteMatch lastMatch =
        routeMatch ?? _router.routerDelegate.currentConfiguration.last;
    final RouteMatchList matchList = lastMatch is ImperativeRouteMatch
        ? lastMatch.matches
        : _router.routerDelegate.currentConfiguration;
    return matchList.uri.toString();
  }

  List<String> getRouteStack() =>
      _router.routerDelegate.currentConfiguration.matches
          .map((e) => getRoute(e))
          .toList();
  late Stream<BaseAuthUser> userStream;

  @override
  void initState() {
    super.initState();

    _appStateNotifier = AppStateNotifier.instance;
    _router = createRouter(_appStateNotifier);
    userStream = deliverySupabaseUserStream()
      ..listen((user) {
        _appStateNotifier.update(user);
      });
    jwtTokenStream.listen((_) {});
    Future.delayed(
      Duration(milliseconds: isWeb ? 0 : 100),
      () => _appStateNotifier.stopShowingSplashImage(),
    );
  }

  void setLocale(String language) {
    safeSetState(() => _locale = createLocale(language));
  }

  void setThemeMode(ThemeMode mode) => safeSetState(() {
        _themeMode = mode;
      });

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: appConfig.appName, // White Label: Nome dinâmico
      scrollBehavior: MyAppScrollBehavior(),
      localizationsDelegates: [
        FFLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        FallbackMaterialLocalizationDelegate(),
        FallbackCupertinoLocalizationDelegate(),
      ],
      locale: _locale,
      supportedLocales: const [
        Locale('pt'),
      ],
      theme: ThemeData(
        brightness: Brightness.light,
        scrollbarTheme: ScrollbarThemeData(
          radius: Radius.circular(5.0),
          thumbColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.dragged)) {
              return Color(4278303194);
            }
            if (states.contains(WidgetState.hovered)) {
              return Color(4278303194);
            }
            return Color(4278303194);
          }),
        ),
        useMaterial3: false,
      ),
      themeMode: _themeMode,
      routerConfig: _router,
    );
  }
}

class NavBarPage extends StatefulWidget {
  NavBarPage({
    Key? key,
    this.initialPage,
    this.page,
    this.disableResizeToAvoidBottomInset = false,
  }) : super(key: key);

  final String? initialPage;
  final Widget? page;
  final bool disableResizeToAvoidBottomInset;

  @override
  _NavBarPageState createState() => _NavBarPageState();
}

/// This is the private State class that goes with NavBarPage.
class _NavBarPageState extends State<NavBarPage> {
  String _currentPageName = 'home';
  late Widget? _currentPage;

  @override
  void initState() {
    super.initState();
    _currentPageName = widget.initialPage ?? _currentPageName;
    _currentPage = widget.page;
  }

  @override
  Widget build(BuildContext context) {
    final tabs = {
      'home': HomeWidget(),
      'nfseList': NfseListWidget(),
      'guias': GuiasWidget(),
      'perfil': PerfilWidget(),
    };
    final currentIndex = tabs.keys.toList().indexOf(_currentPageName);

    return Scaffold(
      resizeToAvoidBottomInset: !widget.disableResizeToAvoidBottomInset,
      body: _currentPage ?? tabs[_currentPageName],
      floatingActionButton: Visibility(
        visible: responsiveVisibility(
          context: context,
          desktop: false,
        ),
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                FlutterFlowTheme.of(context).primary,
                FlutterFlowTheme.of(context).primary.withValues(alpha: 0.8),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: FlutterFlowTheme.of(context).primary.withValues(alpha: 0.3),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: FloatingActionButton(
            onPressed: () {
              context.pushNamed('emitirNfse');
            },
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 26,
                ),
                Text(
                  'NFS-e',
                  style: GoogleFonts.nunito(
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Visibility(
        visible: responsiveVisibility(
          context: context,
          desktop: false,
        ),
        child: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          notchMargin: 8,
          color: FlutterFlowTheme.of(context).secondaryBackground,
          elevation: 8,
          child: Container(
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Botão Início
                Expanded(
                  child: InkWell(
                    onTap: () => safeSetState(() {
                      _currentPage = null;
                      _currentPageName = 'home';
                    }),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _currentPageName == 'home'
                              ? Icons.home
                              : Icons.home_outlined,
                          color: _currentPageName == 'home'
                              ? FlutterFlowTheme.of(context).primary
                              : FlutterFlowTheme.of(context).grayscale80,
                          size: 24,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Início',
                          style: GoogleFonts.nunito(
                            fontSize: 11,
                            fontWeight: _currentPageName == 'home'
                                ? FontWeight.w600
                                : FontWeight.w500,
                            color: _currentPageName == 'home'
                                ? FlutterFlowTheme.of(context).primary
                                : FlutterFlowTheme.of(context).grayscale80,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Botão NFS-e
                Expanded(
                  child: InkWell(
                    onTap: () => safeSetState(() {
                      _currentPage = null;
                      _currentPageName = 'nfseList';
                    }),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _currentPageName == 'nfseList'
                              ? Icons.receipt_long
                              : Icons.receipt_long_outlined,
                          color: _currentPageName == 'nfseList'
                              ? FlutterFlowTheme.of(context).primary
                              : FlutterFlowTheme.of(context).grayscale80,
                          size: 24,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'NFS-e',
                          style: GoogleFonts.nunito(
                            fontSize: 11,
                            fontWeight: _currentPageName == 'nfseList'
                                ? FontWeight.w600
                                : FontWeight.w500,
                            color: _currentPageName == 'nfseList'
                                ? FlutterFlowTheme.of(context).primary
                                : FlutterFlowTheme.of(context).grayscale80,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Espaço para o FAB
                const SizedBox(width: 70),
                // Botão Guias
                Expanded(
                  child: InkWell(
                    onTap: () => safeSetState(() {
                      _currentPage = null;
                      _currentPageName = 'guias';
                    }),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _currentPageName == 'guias'
                              ? Icons.description
                              : Icons.description_outlined,
                          color: _currentPageName == 'guias'
                              ? FlutterFlowTheme.of(context).primary
                              : FlutterFlowTheme.of(context).grayscale80,
                          size: 24,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Guias',
                          style: GoogleFonts.nunito(
                            fontSize: 11,
                            fontWeight: _currentPageName == 'guias'
                                ? FontWeight.w600
                                : FontWeight.w500,
                            color: _currentPageName == 'guias'
                                ? FlutterFlowTheme.of(context).primary
                                : FlutterFlowTheme.of(context).grayscale80,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Botão Perfil
                Expanded(
                  child: InkWell(
                    onTap: () => safeSetState(() {
                      _currentPage = null;
                      _currentPageName = 'perfil';
                    }),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _currentPageName == 'perfil'
                              ? Icons.person_rounded
                              : Icons.person_outline_rounded,
                          color: _currentPageName == 'perfil'
                              ? FlutterFlowTheme.of(context).primary
                              : FlutterFlowTheme.of(context).grayscale80,
                          size: 24,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Perfil',
                          style: GoogleFonts.nunito(
                            fontSize: 11,
                            fontWeight: _currentPageName == 'perfil'
                                ? FontWeight.w600
                                : FontWeight.w500,
                            color: _currentPageName == 'perfil'
                                ? FlutterFlowTheme.of(context).primary
                                : FlutterFlowTheme.of(context).grayscale80,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
