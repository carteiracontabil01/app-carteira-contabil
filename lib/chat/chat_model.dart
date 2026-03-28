import '/flutter_flow/flutter_flow_util.dart';
import 'chat_widget.dart' show ChatWidget;
import 'package:flutter/material.dart';

class ChatMessage {
  const ChatMessage({
    required this.text,
    required this.isUser,
    required this.sentAt,
  });

  final String text;
  final bool isUser;
  final DateTime sentAt;
}

class ChatModel extends FlutterFlowModel<ChatWidget> {
  final List<ChatMessage> messages = [];

  FocusNode? inputFocusNode;
  TextEditingController? inputController;
  ScrollController? scrollController;

  @override
  void initState(BuildContext context) {
    inputFocusNode = FocusNode();
    inputController = TextEditingController();
    scrollController = ScrollController();

    final now = DateTime.now();
    messages.addAll([
      ChatMessage(
        text:
            'Olá! Sou o assistente da Carteira Contábil. Como posso ajudar você hoje?',
        isUser: false,
        sentAt: now.subtract(const Duration(minutes: 2)),
      ),
    ]);
  }

  @override
  void dispose() {
    inputFocusNode?.dispose();
    inputController?.dispose();
    scrollController?.dispose();
  }

  void addUserMessage(String text) {
    final t = text.trim();
    if (t.isEmpty) return;
    messages.add(
      ChatMessage(
        text: t,
        isUser: true,
        sentAt: DateTime.now(),
      ),
    );
    inputController?.clear();
  }

  /// Resposta mock para demonstração (substituir por API depois).
  void addAssistantPlaceholderReply() {
    messages.add(
      ChatMessage(
        text:
            'Recebemos sua mensagem. Em breve um atendente responde por aqui.',
        isUser: false,
        sentAt: DateTime.now(),
      ),
    );
  }
}
