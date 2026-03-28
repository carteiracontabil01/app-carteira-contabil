import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'chat_model.dart';
export 'chat_model.dart';

class ChatWidget extends StatefulWidget {
  const ChatWidget({
    super.key,
    /// Quando `true` (ex.: aba do [NavBarPage]), oculta o botão voltar do AppBar.
    this.embeddedInBottomNav = false,
  });

  /// Abrir em tela cheia pela rota `chat` — mostrar voltar.
  final bool embeddedInBottomNav;

  static String routeName = 'chat';
  static String routePath = 'chat';

  @override
  State<ChatWidget> createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  late ChatModel _model;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ChatModel());
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    final c = _model.scrollController;
    if (c == null || !c.hasClients) return;
    c.animateTo(
      c.position.maxScrollExtent,
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
    );
  }

  void _onSend() {
    final text = _model.inputController?.text ?? '';
    if (text.trim().isEmpty) return;
    setState(() {
      _model.addUserMessage(text);
      _model.addAssistantPlaceholderReply();
    });
    _scrollToBottom();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final timeFmt = DateFormat('HH:mm');

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: theme.primaryBackground,
        appBar: AppBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
          leading: widget.embeddedInBottomNav
              ? null
              : IconButton(
                  icon: Icon(
                    Icons.arrow_back_rounded,
                    color: theme.primaryText,
                    size: 28,
                  ),
                  onPressed: () => context.safePop(),
                ),
          title: Text(
            'Chat',
            style: GoogleFonts.nunito(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: theme.primaryText,
            ),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  controller: _model.scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  itemCount: _model.messages.length,
                  itemBuilder: (context, index) {
                    final msg = _model.messages[index];
                    return _MessageBubble(
                      message: msg,
                      timeFormat: timeFmt,
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
                decoration: BoxDecoration(
                  color: theme.secondaryBackground,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 8,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _model.inputController,
                        focusNode: _model.inputFocusNode,
                        minLines: 1,
                        maxLines: 5,
                        textCapitalization: TextCapitalization.sentences,
                        style: GoogleFonts.nunito(
                          fontSize: 15,
                          color: theme.primaryText,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Digite uma mensagem…',
                          hintStyle: GoogleFonts.nunito(
                            fontSize: 15,
                            color: theme.secondaryText,
                          ),
                          filled: true,
                          fillColor: theme.primaryBackground,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: BorderSide(
                              color: theme.primaryText.withValues(alpha: 0.1),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: BorderSide(
                              color: theme.primaryText.withValues(alpha: 0.1),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: BorderSide(
                              color: theme.primary.withValues(alpha: 0.5),
                            ),
                          ),
                        ),
                        onSubmitted: (_) => _onSend(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Material(
                      color: theme.primary,
                      borderRadius: BorderRadius.circular(24),
                      child: InkWell(
                        onTap: _onSend,
                        borderRadius: BorderRadius.circular(24),
                        child: const Padding(
                          padding: EdgeInsets.all(12),
                          child: Icon(
                            Icons.send_rounded,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({
    required this.message,
    required this.timeFormat,
  });

  final ChatMessage message;
  final DateFormat timeFormat;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final isUser = message.isUser;
    final bg = isUser
        ? theme.primary
        : theme.secondaryBackground;
    final fg = isUser ? Colors.white : theme.primaryText;
    final align = isUser ? Alignment.centerRight : Alignment.centerLeft;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Align(
        alignment: align,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.sizeOf(context).width * 0.82,
          ),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(16),
                topRight: const Radius.circular(16),
                bottomLeft: Radius.circular(isUser ? 16 : 4),
                bottomRight: Radius.circular(isUser ? 4 : 16),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.text,
                    style: GoogleFonts.nunito(
                      fontSize: 15,
                      height: 1.35,
                      color: fg,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    timeFormat.format(message.sentAt),
                    style: GoogleFonts.nunito(
                      fontSize: 11,
                      color: isUser
                          ? Colors.white.withValues(alpha: 0.75)
                          : theme.secondaryText,
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
}
