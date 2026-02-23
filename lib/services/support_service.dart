import '/backend/supabase/supabase.dart';

class SupportService {
  /// Gera um código único para o ticket
  static String generateTicketCode() {
    final now = DateTime.now();
    final timestamp = now.millisecondsSinceEpoch.toString().substring(8);
    final random = (now.microsecond % 1000).toString().padLeft(3, '0');
    return 'TKT-$timestamp$random';
  }

  /// Cria um novo ticket de suporte
  static Future<Map<String, dynamic>?> createTicket({
    required String userId,
    required String tenantId,
    required String subject,
    required String category,
    required String description,
    String? contactInfo,
    String priority = 'medium',
  }) async {
    try {
      final ticketCode = generateTicketCode();

      final ticketData = {
        'id': ticketCode,
        'user_id': userId,
        'tenant_id': tenantId,
        'subject': subject,
        'category': category,
        'priority': priority,
        'status': 'open',
        'description': description,
        'contact_info': contactInfo,
        'created_at': DateTime.now().toIso8601String(),
      };

      final response = await Supabase.instance.client
          .from('support_tickets')
          .insert(ticketData)
          .select()
          .single();

      return response;
    } catch (e) {
      print('Erro ao criar ticket: $e');
      return null;
    }
  }

  /// Busca tickets do usuário
  static Future<List<Map<String, dynamic>>> getUserTickets(
      String userId) async {
    try {
      final response = await Supabase.instance.client
          .from('support_tickets')
          .select('*')
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Erro ao buscar tickets: $e');
      return [];
    }
  }

  /// Busca FAQ por categoria
  static Future<List<Map<String, dynamic>>> getFaqByCategory({
    String? category,
    String? tenantId,
  }) async {
    try {
      var query = Supabase.instance.client
          .from('support_faq')
          .select('*')
          .eq('is_active', true);

      if (category != null) {
        query = query.eq('category', category);
      }

      if (tenantId != null) {
        query = query.eq('tenant_id', tenantId);
      }

      final response = await query.order('order_index', ascending: true);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Erro ao buscar FAQ: $e');
      return [];
    }
  }

  /// Busca categorias de suporte
  static Future<List<Map<String, dynamic>>> getSupportCategories({
    String? tenantId,
  }) async {
    try {
      var query = Supabase.instance.client
          .from('support_categories')
          .select('*')
          .eq('is_active', true);

      if (tenantId != null) {
        query = query.eq('tenant_id', tenantId);
      }

      final response = await query.order('order_index', ascending: true);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Erro ao buscar categorias: $e');
      return [];
    }
  }

  /// Adiciona uma resposta ao ticket
  static Future<Map<String, dynamic>?> addTicketResponse({
    required String ticketId,
    required String userId,
    required String message,
    bool isInternal = false,
    List<String>? attachments,
  }) async {
    try {
      final responseData = {
        'ticket_id': ticketId,
        'user_id': userId,
        'message': message,
        'is_internal': isInternal,
        'attachments': attachments,
        'created_at': DateTime.now().toIso8601String(),
      };

      final response = await Supabase.instance.client
          .from('support_ticket_responses')
          .insert(responseData)
          .select()
          .single();

      return response;
    } catch (e) {
      print('Erro ao adicionar resposta: $e');
      return null;
    }
  }

  /// Busca respostas de um ticket
  static Future<List<Map<String, dynamic>>> getTicketResponses(
      String ticketId) async {
    try {
      final response = await Supabase.instance.client
          .from('support_ticket_responses')
          .select('*')
          .eq('ticket_id', ticketId)
          .order('created_at', ascending: true);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Erro ao buscar respostas: $e');
      return [];
    }
  }

  /// Avalia um ticket
  static Future<Map<String, dynamic>?> rateTicket({
    required String ticketId,
    required String userId,
    required int rating,
    String? comment,
  }) async {
    try {
      final ratingData = {
        'ticket_id': ticketId,
        'user_id': userId,
        'rating': rating,
        'comment': comment,
        'created_at': DateTime.now().toIso8601String(),
      };

      final response = await Supabase.instance.client
          .from('support_ticket_ratings')
          .upsert(ratingData)
          .select()
          .single();

      return response;
    } catch (e) {
      print('Erro ao avaliar ticket: $e');
      return null;
    }
  }

  /// Busca estatísticas de tickets
  static Future<List<Map<String, dynamic>>> getTicketStats({
    String? tenantId,
    String? userId,
  }) async {
    try {
      var query = Supabase.instance.client
          .from('support_tickets')
          .select('status, priority, created_at, resolved_at');

      if (tenantId != null) {
        query = query.eq('tenant_id', tenantId);
      }

      if (userId != null) {
        query = query.eq('user_id', userId);
      }

      final response = await query;
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Erro ao buscar estatísticas: $e');
      return [];
    }
  }

  /// Busca um ticket específico
  static Future<Map<String, dynamic>?> getTicket(String ticketId) async {
    try {
      final response = await Supabase.instance.client
          .from('support_tickets')
          .select('*')
          .eq('id', ticketId)
          .single();

      return response;
    } catch (e) {
      print('Erro ao buscar ticket: $e');
      return null;
    }
  }

  /// Atualiza o status de um ticket
  static Future<Map<String, dynamic>?> updateTicketStatus({
    required String ticketId,
    required String status,
    String? resolution,
    String? assignedTo,
  }) async {
    try {
      final updateData = {
        'status': status,
        'updated_at': DateTime.now().toIso8601String(),
      };

      if (resolution != null) {
        updateData['resolution'] = resolution;
      }

      if (assignedTo != null) {
        updateData['assigned_to'] = assignedTo;
      }

      if (status == 'resolved') {
        updateData['resolved_at'] = DateTime.now().toIso8601String();
      } else if (status == 'closed') {
        updateData['closed_at'] = DateTime.now().toIso8601String();
      }

      final response = await Supabase.instance.client
          .from('support_tickets')
          .update(updateData)
          .eq('id', ticketId)
          .select()
          .single();

      return response;
    } catch (e) {
      print('Erro ao atualizar status do ticket: $e');
      return null;
    }
  }

  /// Incrementa contador de visualizações do FAQ
  static Future<void> incrementFaqViewCount(String faqId) async {
    try {
      await Supabase.instance.client.rpc('increment_faq_view_count', params: {
        'faq_id': faqId,
      });
    } catch (e) {
      print('Erro ao incrementar visualizações: $e');
    }
  }

  /// Busca FAQ por termo de busca
  static Future<List<Map<String, dynamic>>> searchFaq({
    required String searchTerm,
    String? tenantId,
  }) async {
    try {
      var query = Supabase.instance.client
          .from('support_faq')
          .select('*')
          .eq('is_active', true);

      if (tenantId != null) {
        query = query.eq('tenant_id', tenantId);
      }

      // Busca em question_pt e answer_pt
      final response = await query.or(
        'question_pt.ilike.%$searchTerm%,answer_pt.ilike.%$searchTerm%',
      );

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Erro ao buscar FAQ: $e');
      return [];
    }
  }
}
