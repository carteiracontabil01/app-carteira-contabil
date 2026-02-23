import '/flutter_flow/flutter_flow_util.dart';
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
      apiUrl: 'https://jfnvyjkcezmwlcogqvdr.supabase.co/auth/v1/user',
      callType: ApiCallType.PUT,
      headers: {
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImpmbnZ5amtjZXptd2xjb2dxdmRyIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTcwOTAxMDA1MSwiZXhwIjoyMDI0NTg2MDUxfQ.jUgeR228wItOmh39QxO5gNQacD5U5b6YbQowih95R38',
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
