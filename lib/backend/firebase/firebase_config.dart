import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

Future initFirebase() async {
  if (kIsWeb) {
    // Configuração Web do Firebase
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "AIzaSyBO9r-8ytpXqsS6RmdlJ-I9Y4pKugXrqhE",
        authDomain: "taigostei-uftpny.firebaseapp.com",
        projectId: "taigostei-uftpny",
        storageBucket: "taigostei-uftpny.firebasestorage.app",
        messagingSenderId: "81545867499",
        appId:
            "1:81545867499:web:xxxxx", // Nota: substituir pelo appId real caso configure o Web App
      ),
    );
  } else {
    // Android/iOS: Usa google-services.json / GoogleService-Info.plist
    await Firebase.initializeApp();
  }

  print('🔥 Firebase inicializado com sucesso');
}
