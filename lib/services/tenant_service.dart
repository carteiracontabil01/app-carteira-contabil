import 'package:supabase_flutter/supabase_flutter.dart';

/// Serviço para gerenciar operações relacionadas a tenants (empresas)
/// no sistema multi-tenant Carteira Contábil
class TenantService {
  static final SupabaseClient _supabase = Supabase.instance.client;

  /// Detecta o tenant pela URL/domínio
  ///
  /// Exemplos de URLs suportadas:
  /// - `lopes.carteiracontabil.com.br` → busca por domain
  /// - `lopes-supermercado` → busca por slug
  /// - `localhost` → retorna tenant padrão de desenvolvimento
  static Future<String?> detectTenantByUrl(
    String url, {
    String? tenantSlug,
  }) async {
    try {
      // Remove protocolo, www e path
      String cleanUrl = url
          .replaceAll('https://', '')
          .replaceAll('http://', '')
          .replaceAll('www.', '')
          .split('/')[0]; // Pega apenas o domínio

      print('🔍 Detectando tenant para URL: $cleanUrl');

      // Se um tenantSlug fixo for fornecido (para White Label), usa ele
      if (tenantSlug != null && tenantSlug.isNotEmpty) {
        print('📦 White Label - Usando tenantSlug fixo: $tenantSlug');

        try {
          final response = await _supabase
              .from('tenants')
              .select('id, name, slug, is_active')
              .eq('slug', tenantSlug)
              .eq('is_active', true)
              .maybeSingle();

          print('🔍 Resposta do Supabase: $response');

          if (response != null) {
            print(
                '✅ Tenant White Label encontrado: ${response['name']} (${response['id']})');
            return response['id'] as String;
          } else {
            print(
                '❌ Nenhum tenant White Label encontrado para o slug: $tenantSlug');

            // Tentar buscar sem o filtro is_active para debug
            print('🔍 Buscando sem filtro is_active...');
            final debugResponse = await _supabase
                .from('tenants')
                .select('id, name, slug, is_active')
                .eq('slug', tenantSlug)
                .maybeSingle();

            print('🔍 Debug response: $debugResponse');

            return null;
          }
        } catch (e) {
          print('❌ Erro na query do tenant: $e');
          return null;
        }
      }

      // Para desenvolvimento local, usar tenant padrão
      if (cleanUrl.startsWith('localhost') ||
          cleanUrl.startsWith('127.0.0.1')) {
        print('🏠 Ambiente local detectado - buscando tenant padrão ativo');
        final response = await _supabase
            .from('tenants')
            .select('id, name, slug')
            .eq('is_active', true)
            .order('created_at')
            .limit(1)
            .maybeSingle();

        if (response != null) {
          print('✅ Tenant padrão encontrado: ${response['name']}');
          return response['id'] as String;
        }
      }

      // Busca tenant pelo slug (para multi-tenant dinâmico, se aplicável)
      final response = await _supabase
          .from('tenants')
          .select('id, name, slug')
          .eq('slug', cleanUrl)
          .eq('is_active', true)
          .maybeSingle();

      if (response != null) {
        print('✅ Tenant encontrado: ${response['name']} (${response['id']})');
        return response['id'] as String;
      } else {
        print('❌ Nenhum tenant encontrado para: $cleanUrl');
      }
    } catch (e) {
      print('❌ Erro ao detectar tenant: $e');
    }

    return null;
  }

  /// Busca informações completas do tenant
  static Future<Map<String, dynamic>?> getTenantInfo(String tenantId) async {
    try {
      print('📋 Buscando informações do tenant: $tenantId');

      final response = await _supabase
          .from('tenants')
          .select('*')
          .eq('id', tenantId)
          .maybeSingle();

      if (response != null) {
        print('✅ Informações do tenant carregadas');
        return response;
      } else {
        print('❌ Tenant não encontrado: $tenantId');
      }
    } catch (e) {
      print('❌ Erro ao buscar tenant: $e');
    }

    return null;
  }

  /// Verifica se usuário tem acesso ao tenant
  static Future<bool> userHasAccessToTenant(
    String userId,
    String tenantId,
  ) async {
    try {
      print('🔐 Verificando acesso: user=$userId, tenant=$tenantId');

      final response = await _supabase
          .from('tenant_users')
          .select('id, role')
          .eq('user_id', userId)
          .eq('tenant_id', tenantId)
          .maybeSingle();

      if (response != null) {
        print('✅ Usuário tem acesso (role: ${response['role']})');
        return true;
      } else {
        print('⚠️ Usuário não tem acesso ao tenant');
        return false;
      }
    } catch (e) {
      print('❌ Erro ao verificar acesso: $e');
    }

    return false;
  }

  /// Registra usuário como cliente do tenant
  ///
  /// Role padrão: 'customer'
  static Future<bool> registerCustomerToTenant(
    String userId,
    String tenantId,
  ) async {
    try {
      print(
          '👤 Registrando usuário como cliente: user=$userId, tenant=$tenantId');

      await _supabase.from('tenant_users').insert({
        'user_id': userId,
        'tenant_id': tenantId,
        'role': 'customer',
      });

      print('✅ Usuário registrado como cliente');
      return true;
    } catch (e) {
      print('❌ Erro ao registrar cliente: $e');

      // Verifica se o erro é de duplicação (usuário já existe)
      if (e.toString().contains('duplicate') ||
          e.toString().contains('already exists')) {
        print('⚠️ Usuário já está registrado neste tenant');
        return true; // Considera sucesso pois usuário já existe
      }
    }

    return false;
  }

  /// Busca o papel (role) do usuário no tenant
  static Future<String?> getUserRole(
    String userId,
    String tenantId,
  ) async {
    try {
      final response = await _supabase
          .from('tenant_users')
          .select('role')
          .eq('user_id', userId)
          .eq('tenant_id', tenantId)
          .maybeSingle();

      if (response != null) {
        return response['role'] as String;
      }
    } catch (e) {
      print('❌ Erro ao buscar role do usuário: $e');
    }

    return null;
  }

  /// Lista todos os tenants que o usuário tem acesso
  static Future<List<Map<String, dynamic>>> getUserTenants(
      String userId) async {
    try {
      final response = await _supabase
          .from('tenant_users')
          .select('tenant_id, role, tenants(*)')
          .eq('user_id', userId);

      return List<Map<String, dynamic>>.from(response as List);
    } catch (e) {
      print('❌ Erro ao buscar tenants do usuário: $e');
    }

    return [];
  }

  /// Busca configurações específicas do tenant
  static Future<Map<String, dynamic>?> getTenantSettings(
      String tenantId) async {
    try {
      final response = await _supabase
          .from('tenant_settings')
          .select('*')
          .eq('tenant_id', tenantId)
          .maybeSingle();

      return response;
    } catch (e) {
      print('❌ Erro ao buscar configurações do tenant: $e');
    }

    return null;
  }

  // ============================================
  // 📦 QUERIES PARA HOME
  // ============================================

  /// Busca banners ativos do tenant
  static Future<List<Map<String, dynamic>>> getTenantBanners(
    String tenantId, {
    String? location,
  }) async {
    try {
      print('🎨 Buscando banners do tenant: $tenantId');
      if (location != null) {
        print('   - Localização: $location');
      }

      var query = _supabase
          .from('banners')
          .select()
          .eq('tenant_id', tenantId)
          .eq('status', 'active')
          .gte('date_end', DateTime.now().toIso8601String());

      // Filtrar por localização se fornecida
      if (location != null) {
        query = query.eq('location', location);
      }

      final response = await query.order('created_at', ascending: false);

      final banners = List<Map<String, dynamic>>.from(response as List);
      print('✅ ${banners.length} banners encontrados');

      return banners;
    } catch (e) {
      print('❌ Erro ao buscar banners: $e');
      return [];
    }
  }

  /// Busca produtos ativos do tenant com preços
  static Future<List<Map<String, dynamic>>> getTenantProducts(
    String tenantId, {
    String? categoryId,
    String productType = 'delivery',
    bool? isFeatured,
    bool? isOnSale,
  }) async {
    try {
      print('🍕 Buscando produtos do tenant: $tenantId');
      print('   - Tipo: $productType');
      if (categoryId != null) print('   - Categoria: $categoryId');
      if (isFeatured != null) print('   - Destaque: $isFeatured');
      if (isOnSale != null) print('   - Em oferta: $isOnSale');

      var query = _supabase
          .from('products')
          .select('*, product_categories(*), product_prices(*)')
          .eq('tenant_id', tenantId)
          .eq('is_active', true)
          .eq('is_published', true)
          .eq('product_type', productType);

      if (categoryId != null) {
        query = query.eq('product_category_id', categoryId);
      }

      if (isFeatured != null) {
        query = query.eq('is_featured', isFeatured);
      }

      final response = await query.order('name_pt');

      var products = List<Map<String, dynamic>>.from(response as List);

      // Processar produtos e preços
      products = products.map((product) {
        // Pegar o preço atual do product_prices
        final prices = product['product_prices'] as List?;
        Map<String, dynamic>? currentPrice;

        if (prices != null && prices.isNotEmpty) {
          // Pegar o preço mais recente
          currentPrice = prices.first;
        }

        // Determinar se está em oferta
        bool hasOffer = false;
        double? finalPrice;
        double? originalPrice;

        if (currentPrice != null) {
          finalPrice =
              double.tryParse(currentPrice['price']?.toString() ?? '0');

          // Verifica se tem promoção ativa
          if (currentPrice['is_promotional'] == true &&
              currentPrice['promotional_price'] != null) {
            final promoStart = currentPrice['promotional_start_date'];
            final promoEnd = currentPrice['promotional_end_date'];
            final now = DateTime.now();

            if ((promoStart == null ||
                    DateTime.parse(promoStart).isBefore(now)) &&
                (promoEnd == null || DateTime.parse(promoEnd).isAfter(now))) {
              originalPrice = finalPrice;
              finalPrice = double.tryParse(
                  currentPrice['promotional_price']?.toString() ?? '0');
              hasOffer = true;
            }
          }

          // Verifica se tem desconto (compare_price)
          if (!hasOffer && currentPrice['compare_price'] != null) {
            final comparePrice = double.tryParse(
                currentPrice['compare_price']?.toString() ?? '0');
            if (comparePrice != null && comparePrice > (finalPrice ?? 0)) {
              originalPrice = comparePrice;
              hasOffer = true;
            }
          }

          // Verifica is_on_sale
          if (!hasOffer && currentPrice['is_on_sale'] == true) {
            final saleStart = currentPrice['sale_start_date'];
            final saleEnd = currentPrice['sale_end_date'];
            final now = DateTime.now();

            if ((saleStart == null ||
                    DateTime.parse(saleStart).isBefore(now)) &&
                (saleEnd == null || DateTime.parse(saleEnd).isAfter(now))) {
              hasOffer = true;
            }
          }
        } else {
          // Fallback: usar preço direto da tabela products
          finalPrice = double.tryParse(product['price']?.toString() ?? '0');
        }

        // Adicionar campos processados ao produto
        return {
          ...product,
          'price': finalPrice?.toString() ?? '0',
          'original_price': originalPrice?.toString(),
          'has_offer': hasOffer,
          'category_id': product['product_category_id'],
        };
      }).toList();

      // Filtrar por oferta se solicitado
      if (isOnSale == true) {
        products = products.where((p) => p['has_offer'] == true).toList();
      }

      print('✅ ${products.length} produtos encontrados');

      return products;
    } catch (e) {
      print('❌ Erro ao buscar produtos: $e');
      return [];
    }
  }

  /// Busca categorias ativas do tenant
  static Future<List<Map<String, dynamic>>> getTenantCategories(
    String tenantId, {
    String categoryType = 'delivery',
  }) async {
    try {
      print('📂 Buscando categorias do tenant: $tenantId');
      print('   - Tipo: $categoryType');

      final response = await _supabase
          .from('product_categories')
          .select()
          .eq('tenant_id', tenantId)
          .eq('is_active', true)
          .eq('category_type', categoryType)
          .order('sort_order');

      final categories = List<Map<String, dynamic>>.from(response as List);
      print('✅ ${categories.length} categorias encontradas');

      return categories;
    } catch (e) {
      print('❌ Erro ao buscar categorias: $e');
      return [];
    }
  }

  // ============================================
  // ❤️ FAVORITOS
  // ============================================

  /// Adiciona produto aos favoritos
  static Future<bool> addToFavorites({
    required String userId,
    required String productId,
    required String tenantId,
  }) async {
    try {
      print('❤️ Adicionando produto aos favoritos...');
      print('   - User: $userId');
      print('   - Product: $productId');
      print('   - Tenant: $tenantId');

      await _supabase.from('user_favorites').insert({
        'user_id': userId,
        'product_id': productId,
        'tenant_id': tenantId,
      });

      print('✅ Produto adicionado aos favoritos');
      return true;
    } catch (e) {
      print('❌ Erro ao adicionar favorito: $e');

      // Se já existe, considera sucesso
      if (e.toString().contains('duplicate') ||
          e.toString().contains('unique')) {
        print('⚠️ Produto já está nos favoritos');
        return true;
      }

      return false;
    }
  }

  /// Remove produto dos favoritos
  static Future<bool> removeFromFavorites({
    required String userId,
    required String productId,
    required String tenantId,
  }) async {
    try {
      print('💔 Removendo produto dos favoritos...');

      await _supabase
          .from('user_favorites')
          .delete()
          .eq('user_id', userId)
          .eq('product_id', productId)
          .eq('tenant_id', tenantId);

      print('✅ Produto removido dos favoritos');
      return true;
    } catch (e) {
      print('❌ Erro ao remover favorito: $e');
      return false;
    }
  }

  /// Verifica se produto está nos favoritos
  static Future<bool> isFavorite({
    required String userId,
    required String productId,
    required String tenantId,
  }) async {
    try {
      final response = await _supabase
          .from('user_favorites')
          .select()
          .eq('user_id', userId)
          .eq('product_id', productId)
          .eq('tenant_id', tenantId)
          .maybeSingle();

      return response != null;
    } catch (e) {
      print('❌ Erro ao verificar favorito: $e');
      return false;
    }
  }

  /// Lista todos os favoritos do usuário em um tenant
  static Future<List<Map<String, dynamic>>> getUserFavorites({
    required String userId,
    required String tenantId,
  }) async {
    try {
      final response = await _supabase
          .from('user_favorites')
          .select('*, products(*)')
          .eq('user_id', userId)
          .eq('tenant_id', tenantId)
          .order('created_at', ascending: false);

      return List<Map<String, dynamic>>.from(response as List);
    } catch (e) {
      print('❌ Erro ao buscar favoritos: $e');
      return [];
    }
  }

  // ============================================
  // MÉTODOS DE AVALIAÇÕES DE PRODUTOS
  // ============================================

  /// Busca todas as avaliações de um produto
  static Future<List<Map<String, dynamic>>> getProductReviews({
    required String productId,
  }) async {
    try {
      final response = await _supabase
          .from('reviews')
          .select('*')
          .eq('product_id', productId)
          .eq('is_approved', true)
          .order('created_at', ascending: false);

      return List<Map<String, dynamic>>.from(response as List);
    } catch (e) {
      print('❌ Erro ao buscar avaliações: $e');
      return [];
    }
  }

  /// Busca estatísticas de avaliações de um produto
  static Future<Map<String, dynamic>> getProductReviewsStats({
    required String productId,
  }) async {
    try {
      final reviews = await getProductReviews(productId: productId);

      if (reviews.isEmpty) {
        return {
          'total_reviews': 0,
          'average_rating': 0.0,
          'five_star_count': 0,
          'four_star_count': 0,
          'three_star_count': 0,
          'two_star_count': 0,
          'one_star_count': 0,
        };
      }

      final totalReviews = reviews.length;
      final sumRatings = reviews.fold<int>(
          0, (sum, review) => sum + (review['rating'] as int));
      final averageRating = sumRatings / totalReviews;

      return {
        'total_reviews': totalReviews,
        'average_rating': double.parse(averageRating.toStringAsFixed(1)),
        'five_star_count': reviews.where((r) => r['rating'] == 5).length,
        'four_star_count': reviews.where((r) => r['rating'] == 4).length,
        'three_star_count': reviews.where((r) => r['rating'] == 3).length,
        'two_star_count': reviews.where((r) => r['rating'] == 2).length,
        'one_star_count': reviews.where((r) => r['rating'] == 1).length,
      };
    } catch (e) {
      print('❌ Erro ao buscar estatísticas de avaliações: $e');
      return {
        'total_reviews': 0,
        'average_rating': 0.0,
        'five_star_count': 0,
        'four_star_count': 0,
        'three_star_count': 0,
        'two_star_count': 0,
        'one_star_count': 0,
      };
    }
  }

  /// Adiciona uma nova avaliação
  static Future<bool> addProductReview({
    required String userId,
    required String productId,
    required int rating,
    String? title,
    String? comment,
    bool isVerified = false,
  }) async {
    try {
      await _supabase.from('reviews').insert({
        'user_id': userId,
        'product_id': productId,
        'rating': rating,
        'title': title,
        'comment': comment,
        'is_verified': isVerified,
        'is_approved': true,
      });
      print('✅ Avaliação adicionada com sucesso');
      return true;
    } catch (e) {
      print('❌ Erro ao adicionar avaliação: $e');
      return false;
    }
  }

  /// Atualiza uma avaliação existente
  static Future<bool> updateProductReview({
    required String reviewId,
    required int rating,
    String? title,
    String? comment,
  }) async {
    try {
      await _supabase.from('reviews').update({
        'rating': rating,
        'title': title,
        'comment': comment,
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('id', reviewId);
      print('✅ Avaliação atualizada com sucesso');
      return true;
    } catch (e) {
      print('❌ Erro ao atualizar avaliação: $e');
      return false;
    }
  }

  /// Remove uma avaliação
  static Future<bool> deleteProductReview({
    required String reviewId,
  }) async {
    try {
      await _supabase.from('reviews').delete().eq('id', reviewId);
      print('✅ Avaliação removida com sucesso');
      return true;
    } catch (e) {
      print('❌ Erro ao remover avaliação: $e');
      return false;
    }
  }

  /// Verifica se o usuário já avaliou um produto
  static Future<Map<String, dynamic>?> getUserReviewForProduct({
    required String userId,
    required String productId,
  }) async {
    try {
      final response = await _supabase
          .from('reviews')
          .select('*')
          .eq('user_id', userId)
          .eq('product_id', productId)
          .maybeSingle();

      return response != null ? Map<String, dynamic>.from(response) : null;
    } catch (e) {
      print('❌ Erro ao buscar avaliação do usuário: $e');
      return null;
    }
  }

  /// Busca produtos com base em um termo de pesquisa
  static Future<List<Map<String, dynamic>>> searchProducts(
    String tenantId,
    String searchTerm, {
    int limit = 50,
  }) async {
    try {
      print('🔍 Buscando produtos para: "$searchTerm"');
      print('   - Tenant: $tenantId');
      print('   - Limite: $limit');

      final response = await _supabase.rpc(
        'search_products',
        params: {
          'p_tenant_id': tenantId,
          'p_search_term': searchTerm,
          'p_limit': limit,
        },
      );

      var products = List<Map<String, dynamic>>.from(response as List);

      print('✅ ${products.length} produtos encontrados na pesquisa');

      return products;
    } catch (e) {
      print('❌ Erro ao buscar produtos: $e');
      return [];
    }
  }

  /// Obtém termos de busca populares do tenant
  static Future<List<Map<String, dynamic>>> getPopularSearchTerms(
    String tenantId, {
    int limit = 10,
  }) async {
    try {
      print('📊 Buscando termos populares do tenant: $tenantId');

      final response = await _supabase.rpc(
        'get_popular_search_terms',
        params: {
          'p_tenant_id': tenantId,
          'p_limit': limit,
        },
      );

      var terms = List<Map<String, dynamic>>.from(response as List);

      print('✅ ${terms.length} termos populares encontrados');

      return terms;
    } catch (e) {
      print('❌ Erro ao buscar termos populares: $e');
      return [];
    }
  }

  /// Obtém histórico de pesquisas do usuário
  static Future<List<Map<String, dynamic>>> getUserSearchHistory(
    String userId,
    String tenantId, {
    int limit = 10,
  }) async {
    try {
      print('📝 Buscando histórico de pesquisas do usuário: $userId');

      final response = await _supabase.rpc(
        'get_user_search_history',
        params: {
          'p_user_id': userId,
          'p_tenant_id': tenantId,
          'p_limit': limit,
        },
      );

      var history = List<Map<String, dynamic>>.from(response as List);

      print('✅ ${history.length} itens no histórico encontrados');

      return history;
    } catch (e) {
      print('❌ Erro ao buscar histórico de pesquisas: $e');
      return [];
    }
  }

  /// Registra uma pesquisa no sistema
  static Future<void> registerSearch(
    String userId,
    String tenantId,
    String searchTerm,
  ) async {
    try {
      print('📝 Registrando pesquisa: "$searchTerm"');
      print('   - Usuário: $userId');
      print('   - Tenant: $tenantId');

      await _supabase.rpc(
        'register_search',
        params: {
          'p_user_id': userId,
          'p_tenant_id': tenantId,
          'p_search_term': searchTerm,
        },
      );

      print('✅ Pesquisa registrada com sucesso');
    } catch (e) {
      print('❌ Erro ao registrar pesquisa: $e');
    }
  }

  // Função para buscar opções de filtros dinâmicos
  static Future<Map<String, List<Map<String, dynamic>>>> getFilterOptions(
    String tenantId,
  ) async {
    try {
      print('🔍 Buscando opções de filtros para tenant: $tenantId');

      final response = await Supabase.instance.client.rpc(
        'get_filter_options',
        params: {
          'p_tenant_id': tenantId,
        },
      );

      if (response == null) {
        print('⚠️ Resposta nula do RPC get_filter_options');
        return {};
      }

      // Converter o JSON response para Map
      final Map<String, dynamic> jsonResponse =
          Map<String, dynamic>.from(response);

      // Converter cada lista de filtros
      Map<String, List<Map<String, dynamic>>> result = {};

      jsonResponse.forEach((key, value) {
        if (value is List) {
          result[key] = value
              .map((item) => Map<String, dynamic>.from(item as Map))
              .toList();
          print('✅ $key: ${result[key]!.length} opções encontradas');
        } else {
          result[key] = [];
          print('⚠️ $key: valor não é uma lista');
        }
      });

      return result;
    } catch (e) {
      print('❌ Erro ao buscar opções de filtros: $e');
      return {};
    }
  }

  // Função para aplicar filtros aos produtos
  static Future<List<Map<String, dynamic>>> getFilteredProducts(
    String tenantId, {
    String? categoryId,
    String? brand,
    String? color,
    String? size,
    double? minPrice,
    double? maxPrice,
    String? searchTerm,
    String? contextType, // Contexto de origem: 'ofertas', 'destaques', etc.
    String?
        sortBy, // Ordenação: 'relevance', 'newest', 'best_sellers', 'price_asc', 'price_desc', 'discount'
    int limit = 50,
    int offset = 0,
  }) async {
    try {
      print('🔍 Aplicando filtros:');
      print('   - Tenant ID: $tenantId');
      print('   - Categoria: $categoryId');
      print('   - Marca: $brand');
      print('   - Cor: $color');
      print('   - Tamanho: $size');
      print('   - Preço min: $minPrice');
      print('   - Preço max: $maxPrice');
      print('   - Busca: $searchTerm');
      print('   - Contexto: $contextType');
      print('   - Ordenação: $sortBy');

      final response = await Supabase.instance.client.rpc(
        'apply_product_filters',
        params: {
          'p_tenant_id': tenantId,
          'p_category_id': categoryId,
          'p_brand': brand,
          'p_color': color,
          'p_size': size,
          'p_min_price': minPrice,
          'p_max_price': maxPrice,
          'p_search_term': searchTerm,
          'p_context_type': contextType,
          'p_sort_by': sortBy,
          'p_limit': limit,
          'p_offset': offset,
        },
      );

      if (response == null) {
        print('⚠️ Resposta nula do RPC');
        return [];
      }

      // Converter List<dynamic> para List<Map<String, dynamic>>
      final result = (response as List)
          .map((item) => Map<String, dynamic>.from(item as Map))
          .toList();

      print('✅ ${result.length} produtos filtrados encontrados');
      return result;
    } catch (e) {
      print('❌ Erro ao aplicar filtros: $e');
      return [];
    }
  }
}
