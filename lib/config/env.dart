import "package:envied/envied.dart";

part 'env.g.dart';

@Envied(path: '../voice_assistant/.env')
abstract class Env {
  @EnviedField(varName: 'API_KEY', obfuscate: true)
  static String apiKey = _Env.apiKey;

  @EnviedField(varName: 'FIREBASE_OPTION_API_KEY', obfuscate: true)
  static String firebaseOptionApiKey = _Env.firebaseOptionApiKey;

  @EnviedField(varName: 'APP_ID', obfuscate: true)
  static String appId = _Env.appId;

  @EnviedField(varName: 'MESSAGING_SENDER_ID', obfuscate: true)
  static String messagingSenderId = _Env.messagingSenderId;
}
