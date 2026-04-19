import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import '/config/runtime_secrets.dart';

Future initFirebase() async {
  if (kIsWeb) {
    if (!RuntimeSecrets.hasFirebaseWebConfig) {
      throw StateError(
        'Missing Firebase web config. Define FIREBASE_WEB_API_KEY, '
        'FIREBASE_WEB_AUTH_DOMAIN, FIREBASE_WEB_PROJECT_ID, '
        'FIREBASE_WEB_STORAGE_BUCKET, FIREBASE_WEB_MESSAGING_SENDER_ID '
        'and FIREBASE_WEB_APP_ID via --dart-define.',
      );
    }

    // Configuração Web do Firebase
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: RuntimeSecrets.firebaseWebApiKey,
        authDomain: RuntimeSecrets.firebaseWebAuthDomain,
        projectId: RuntimeSecrets.firebaseWebProjectId,
        storageBucket: RuntimeSecrets.firebaseWebStorageBucket,
        messagingSenderId: RuntimeSecrets.firebaseWebMessagingSenderId,
        appId: RuntimeSecrets.firebaseWebAppId,
      ),
    );
  } else {
    // Android/iOS: Usa google-services.json / GoogleService-Info.plist
    await Firebase.initializeApp();
  }

}
