import '/backend/supabase/supabase.dart';

class ProductModifiersService {
  /// Calcula o preço total do produto com os modificadores selecionados
  static Future<Map<String, dynamic>> calculateTotalPrice({
    required String productId,
    required String tenantId,
    required Map<String, dynamic> selectedModifiers,
    required int quantity,
  }) async {
    try {
      // Buscar preço base do produto
      final productResponse = await Supabase.instance.client
          .from('products')
          .select('price')
          .eq('id', productId)
          .eq('tenant_id', tenantId)
          .single();

      final basePrice = (productResponse['price'] ?? 0.0) as double;

      // Calcular preço dos modificadores
      double modifiersPrice = 0.0;
      List<Map<String, dynamic>> selectedModifiersDetails = [];

      for (String groupId in selectedModifiers.keys) {
        // Pular o campo 'quantities' (será processado separadamente)
        if (groupId == 'quantities') continue;

        final modifierIds = selectedModifiers[groupId];

        if (modifierIds is List) {
          // Seleção múltipla
          for (String modifierId in modifierIds) {
            final modifierPrice =
                await _getModifierPrice(modifierId, productId: productId);
            modifiersPrice += modifierPrice;
            selectedModifiersDetails.add({
              'group_id': groupId,
              'modifier_id': modifierId,
              'price': modifierPrice,
              'quantity': 1,
            });
          }
        } else if (modifierIds is String) {
          // Seleção única
          final modifierPrice =
              await _getModifierPrice(modifierIds, productId: productId);
          modifiersPrice += modifierPrice;
          selectedModifiersDetails.add({
            'group_id': groupId,
            'modifier_id': modifierIds,
            'price': modifierPrice,
            'quantity': 1,
          });
        }
      }

      // Processar modificadores quantity_based
      final quantities =
          selectedModifiers['quantities'] as Map<String, dynamic>?;
      if (quantities != null) {
        for (String groupId in quantities.keys) {
          final groupQuantities = quantities[groupId] as Map<String, dynamic>;
          for (String modifierId in groupQuantities.keys) {
            final qty = groupQuantities[modifierId] as int;
            if (qty > 0) {
              final modifierPrice =
                  await _getModifierPrice(modifierId, productId: productId);
              modifiersPrice += modifierPrice * qty;
              selectedModifiersDetails.add({
                'group_id': groupId,
                'modifier_id': modifierId,
                'price': modifierPrice,
                'quantity': qty,
              });
            }
          }
        }
      }

      // Calcular totais
      final unitPrice = basePrice + modifiersPrice;
      final totalPrice = unitPrice * quantity;

      return {
        'base_price': basePrice,
        'modifiers_price': modifiersPrice,
        'unit_price': unitPrice,
        'total_price': totalPrice,
        'quantity': quantity,
        'selected_modifiers': selectedModifiersDetails,
      };
    } catch (e) {
      print('❌ Erro ao calcular preço total: $e');
      return {
        'base_price': 0.0,
        'modifiers_price': 0.0,
        'unit_price': 0.0,
        'total_price': 0.0,
        'quantity': quantity,
        'selected_modifiers': [],
      };
    }
  }

  /// Busca o preço de um modificador específico
  static Future<double> _getModifierPrice(String modifierId,
      {String? productId}) async {
    try {
      // Se temos productId, buscar preço específico do produto primeiro
      if (productId != null) {
        try {
          final specificPriceResponse = await Supabase.instance.client
              .from('product_modifier_prices')
              .select('price_adjustment')
              .eq('product_id', productId)
              .eq('modifier_id', modifierId)
              .eq('is_active', true)
              .single();

          return (specificPriceResponse['price_adjustment'] ?? 0.0) as double;
        } catch (e) {
          // Se não encontrar preço específico, usar preço padrão do modificador
          print(
              '⚠️ Preço específico não encontrado para $modifierId, usando preço padrão');
        }
      }

      // Buscar preço padrão do modificador
      final response = await Supabase.instance.client
          .from('product_modifiers')
          .select('price_adjustment')
          .eq('id', modifierId)
          .single();

      return (response['price_adjustment'] ?? 0.0) as double;
    } catch (e) {
      print('❌ Erro ao buscar preço do modificador $modifierId: $e');
      return 0.0;
    }
  }

  /// Valida se as seleções de modificadores atendem aos requisitos
  static Future<Map<String, dynamic>> validateModifierSelections({
    required String productId,
    required String tenantId,
    required Map<String, dynamic> selectedModifiers,
  }) async {
    try {
      // Buscar grupos de modificadores obrigatórios
      final response = await Supabase.instance.client
          .from('product_modifier_group_relations')
          .select('''
            product_modifier_groups!inner(
              id,
              name_pt,
              is_required,
              min_selections,
              max_selections,
              selection_type
            )
          ''')
          .eq('product_id', productId)
          .eq('tenant_id', tenantId);

      final groups = (response as List)
          .map(
              (item) => item['product_modifier_groups'] as Map<String, dynamic>)
          .toList();

      List<String> errors = [];
      List<String> warnings = [];

      for (var group in groups) {
        final groupId = group['id'].toString();
        final groupName = group['name_pt'] ?? 'Grupo';
        final isRequired = group['is_required'] ?? false;
        final minSelections = group['min_selections'] ?? 0;
        final maxSelections = group['max_selections'];

        final selection = selectedModifiers[groupId];
        int selectedCount = 0;

        if (selection != null) {
          if (selection is List) {
            selectedCount = selection.length;
          } else if (selection is String) {
            selectedCount = 1;
          }
        }

        // Validar seleções mínimas
        if (isRequired && selectedCount < minSelections) {
          if (minSelections == 1) {
            errors.add('Selecione uma opção em "$groupName"');
          } else {
            errors.add(
                'Selecione pelo menos $minSelections opções em "$groupName"');
          }
        }

        // Validar seleções máximas
        if (maxSelections != null && selectedCount > maxSelections) {
          errors
              .add('Selecione no máximo $maxSelections opções em "$groupName"');
        }

        // Avisos para grupos não obrigatórios
        if (!isRequired && selectedCount == 0) {
          warnings.add('Você pode adicionar opções em "$groupName"');
        }
      }

      return {
        'is_valid': errors.isEmpty,
        'errors': errors,
        'warnings': warnings,
      };
    } catch (e) {
      print('❌ Erro ao validar seleções de modificadores: $e');
      return {
        'is_valid': false,
        'errors': ['Erro ao validar seleções'],
        'warnings': [],
      };
    }
  }

  /// Busca os detalhes dos modificadores selecionados
  static Future<List<Map<String, dynamic>>> getSelectedModifiersDetails({
    required Map<String, dynamic> selectedModifiers,
  }) async {
    try {
      List<Map<String, dynamic>> details = [];

      for (String groupId in selectedModifiers.keys) {
        final modifierIds = selectedModifiers[groupId];
        List<String> ids = [];

        if (modifierIds is List) {
          ids = modifierIds.cast<String>();
        } else if (modifierIds is String) {
          ids = [modifierIds];
        }

        for (String modifierId in ids) {
          final response = await Supabase.instance.client
              .from('product_modifiers')
              .select('''
                id,
                name_pt,
                description_pt,
                price_adjustment,
                price_adjustment_type,
                product_modifier_groups!inner(
                  id,
                  name_pt
                )
              ''')
              .eq('id', modifierId)
              .single();

          details.add({
            'modifier_id': modifierId,
            'group_id': groupId,
            'group_name': response['product_modifier_groups']['name_pt'],
            'modifier_name': response['name_pt'],
            'modifier_description': response['description_pt'],
            'price': response['price_adjustment'],
            'price_adjustment_type': response['price_adjustment_type'],
          });
        }
      }

      return details;
    } catch (e) {
      print('❌ Erro ao buscar detalhes dos modificadores: $e');
      return [];
    }
  }
}
