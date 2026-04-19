import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/onboarding/widgets/onboarding_initial_buttons.dart';
import '/onboarding/widgets/onboarding_initial_screen.dart';
import 'onboarding_model.dart';
export 'onboarding_model.dart';

import '/signin/login/login_widget.dart';

class OnboardingWidget extends StatefulWidget {
  const OnboardingWidget({super.key});

  static String routeName = 'onboarding';
  static String routePath = 'inicioApp';

  @override
  State<OnboardingWidget> createState() => _OnboardingWidgetState();
}

class _OnboardingWidgetState extends State<OnboardingWidget> {
  late OnboardingModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => OnboardingModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    final screenHeight = MediaQuery.of(context).size.height;
    final safeAreaTop = MediaQuery.of(context).padding.top;
    final safeAreaBottom = MediaQuery.of(context).padding.bottom;
    final availableHeight = screenHeight - safeAreaTop - safeAreaBottom;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Stack(
            children: [
              OnboardingInitialScreen(
                availableHeight: availableHeight,
                onHelpTap: () => context.goNamed('ajuda'),
              ),

              Positioned(
                bottom: availableHeight * 0.3 -
                    28.0,
                left: 24.0,
                right: 24.0,
                child: OnboardingInitialButtons(
                  onCreateAccountTap: () => context.goNamed(LoginWidget.routeName),
                  onLoginTap: () => context.goNamed(LoginWidget.routeName),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
