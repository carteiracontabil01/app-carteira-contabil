import '/flutter_flow/flutter_flow_util.dart';
import '/backend/supabase/supabase.dart';
import 'api_manager.dart';

export 'api_manager.dart' show ApiCallResponse;

class ResetPassCall {
  static Future<ApiCallResponse> call({
    String? accessUserToken = '',
    String? email = '',
    String? password = '',
  }) async {
    final ffApiRequestBody = '''
{
  "email": "${email}",
  "password": "${password}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'ResetPass',
      apiUrl: '${SupaFlow.supabaseUrl}/auth/v1/user',
      callType: ApiCallType.PUT,
      headers: {
        'apikey': SupaFlow.supabaseAnonKey,
        'Authorization': 'Bearer ${accessUserToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}
