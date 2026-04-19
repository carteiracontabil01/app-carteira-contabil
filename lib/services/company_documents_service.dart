import '/backend/supabase/supabase.dart';

class CompanySharedDocumentsPage {
  CompanySharedDocumentsPage({
    required this.data,
    required this.total,
    required this.page,
    required this.pageSize,
    required this.totalPages,
    required this.hasNext,
    required this.hasPrevious,
    required this.totalFolders,
    required this.totalFiles,
  });

  final List<CompanyDocumentNode> data;
  final int total;
  final int page;
  final int pageSize;
  final int totalPages;
  final bool hasNext;
  final bool hasPrevious;
  final int totalFolders;
  final int totalFiles;

  static CompanySharedDocumentsPage empty({
    int page = 1,
    int pageSize = 20,
  }) {
    return CompanySharedDocumentsPage(
      data: const [],
      total: 0,
      page: page,
      pageSize: pageSize,
      totalPages: 0,
      hasNext: false,
      hasPrevious: false,
      totalFolders: 0,
      totalFiles: 0,
    );
  }
}

class CompanyDocumentNode {
  const CompanyDocumentNode({
    required this.id,
    required this.companyId,
    required this.companyCnpj,
    required this.parentId,
    required this.nodeType,
    required this.name,
    required this.documentType,
    required this.expirationDate,
    required this.visibility,
    required this.isSystem,
    required this.sortOrder,
    required this.storageBucket,
    required this.storageKey,
    required this.mimeType,
    required this.fileSizeBytes,
    required this.checksum,
    required this.createdAt,
    required this.createdBy,
    required this.updatedAt,
    required this.updatedBy,
  });

  final String id;
  final String companyId;
  final String? companyCnpj;
  final String? parentId;
  final String nodeType;
  final String name;
  final String? documentType;
  final DateTime? expirationDate;
  final String? visibility;
  final bool isSystem;
  final int? sortOrder;
  final String? storageBucket;
  final String? storageKey;
  final String? mimeType;
  final int? fileSizeBytes;
  final String? checksum;
  final DateTime? createdAt;
  final String? createdBy;
  final DateTime? updatedAt;
  final String? updatedBy;

  bool get isFolder => nodeType.toUpperCase() == 'FOLDER';
  bool get isFile => nodeType.toUpperCase() == 'FILE';

  factory CompanyDocumentNode.fromMap(Map<String, dynamic> map) {
    return CompanyDocumentNode(
      id: map['id']?.toString() ?? '',
      companyId: map['company_id']?.toString() ?? '',
      companyCnpj: map['company_cnpj']?.toString(),
      parentId: map['parent_id']?.toString(),
      nodeType: map['node_type']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
      documentType: map['document_type']?.toString(),
      expirationDate: _toDate(map['expiration_date']),
      visibility: map['visibility']?.toString(),
      isSystem: map['is_system'] == true,
      sortOrder: _toIntOrNull(map['sort_order']),
      storageBucket: map['storage_bucket']?.toString(),
      storageKey: map['storage_key']?.toString(),
      mimeType: map['mime_type']?.toString(),
      fileSizeBytes: _toIntOrNull(map['file_size_bytes']),
      checksum: map['checksum']?.toString(),
      createdAt: _toDate(map['created_at']),
      createdBy: map['created_by']?.toString(),
      updatedAt: _toDate(map['updated_at']),
      updatedBy: map['updated_by']?.toString(),
    );
  }

  static DateTime? _toDate(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    return DateTime.tryParse(value.toString());
  }

  static int? _toIntOrNull(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString());
  }
}

class CompanyDocumentsService {
  static final SupabaseClient _supabase = Supabase.instance.client;

  static Future<CompanySharedDocumentsPage> getSharedDocumentsPaginated({
    required String companyId,
    String? parentId,
    int page = 1,
    int pageSize = 20,
    String? search,
  }) async {
    try {
      final response = await _supabase.rpc(
        'get_company_shared_documents_paginated',
        params: <String, dynamic>{
          'p_company_id': companyId,
          'p_parent_id': parentId,
          'p_page': page,
          'p_page_size': pageSize,
          'p_search': search,
        },
      );

      if (response is! Map) {
        return CompanySharedDocumentsPage.empty(page: page, pageSize: pageSize);
      }

      final root = Map<String, dynamic>.from(response);
      final dataRaw = root['data'];
      final dataList = dataRaw is List ? dataRaw : <dynamic>[];
      final nodes = <CompanyDocumentNode>[];
      for (final item in dataList) {
        if (item is Map) {
          nodes.add(CompanyDocumentNode.fromMap(Map<String, dynamic>.from(item)));
        }
      }

      return CompanySharedDocumentsPage(
        data: nodes,
        total: _toInt(root['total']),
        page: _toInt(root['page'], fallback: page),
        pageSize: _toInt(root['page_size'], fallback: pageSize),
        totalPages: _toInt(root['total_pages']),
        hasNext: root['has_next'] == true || root['has_next'] == 'true',
        hasPrevious:
            root['has_previous'] == true || root['has_previous'] == 'true',
        totalFolders: _toInt(root['total_folders']),
        totalFiles: _toInt(root['total_files']),
      );
    } catch (_) {
      return CompanySharedDocumentsPage.empty(page: page, pageSize: pageSize);
    }
  }

  static Future<String?> createSignedFileUrl(CompanyDocumentNode node) async {
    if (!node.isFile) return null;
    final bucket = (node.storageBucket ?? '').trim();
    final key = (node.storageKey ?? '').trim();
    if (bucket.isEmpty || key.isEmpty) return null;

    if (key.startsWith('http://') || key.startsWith('https://')) {
      return key;
    }

    try {
      final signed = await _supabase.storage.from(bucket).createSignedUrl(key, 120);
      if (signed.isEmpty) return null;
      return signed;
    } catch (_) {
      return null;
    }
  }

  static int _toInt(dynamic value, {int fallback = 0}) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? fallback;
  }
}
