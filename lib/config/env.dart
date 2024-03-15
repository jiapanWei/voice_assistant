import "package:envied/envied.dart";

part 'env.g.dart';

@Envied(path: '../voice_assistant/.env')
abstract class Env {
  @EnviedField(varName: 'API_KEY', obfuscate: true)
  static String apiKey = _Env.apiKey;
}
