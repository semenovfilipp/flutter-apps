import 'package:shared_preferences/shared_preferences.dart';
import '../models/physics_config.dart';

class StorageService {
  static const String _highScoreKey = 'high_score';
  static const String _physicsConfigKey = 'physics_config';

  Future<int> getHighScore() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_highScoreKey) ?? 0;
  }

  Future<void> saveHighScore(int score) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_highScoreKey, score);
  }

  Future<PhysicsConfig> getPhysicsConfig() async {
    final prefs = await SharedPreferences.getInstance();
    final configString = prefs.getString(_physicsConfigKey);

    if (configString == null) {
      return PhysicsConfig();
    }

    return PhysicsConfig.fromJson({
      'gravity': prefs.getDouble('${_physicsConfigKey}_gravity') ?? 500.0,
      'bounceDamping': prefs.getDouble('${_physicsConfigKey}_bounceDamping') ?? 0.8,
      'friction': prefs.getDouble('${_physicsConfigKey}_friction') ?? 0.99,
    });
  }

  Future<void> savePhysicsConfig(PhysicsConfig config) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('${_physicsConfigKey}_gravity', config.gravity);
    await prefs.setDouble('${_physicsConfigKey}_bounceDamping', config.bounceDamping);
    await prefs.setDouble('${_physicsConfigKey}_friction', config.friction);
  }
}
