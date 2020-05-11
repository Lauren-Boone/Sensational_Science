import 'package:firebase_remote_config/firebase_remote_config.dart';

Future<RemoteConfig> setupRemoteConfig() async {
  final RemoteConfig remoteConfig = await RemoteConfig.instance;
  return remoteConfig;
}
