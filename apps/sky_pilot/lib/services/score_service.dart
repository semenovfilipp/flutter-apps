import 'package:shared_preferences/shared_preferences.dart';

class ScoreService {
  static const String _highScoreKey = 'skypilot_high_score';
  static const String _scoresListKey = 'skypilot_scores_list';

  Future<int> getHighScore() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_highScoreKey) ?? 0;
  }

  Future<void> saveScore(int score) async {
    final prefs = await SharedPreferences.getInstance();
    final currentHighScore = await getHighScore();

    if (score > currentHighScore) {
      await prefs.setInt(_highScoreKey, score);
    }

    final scores = await getTopScores();
    scores.add(score);
    scores.sort((a, b) => b.compareTo(a));

    final topScores = scores.take(10).toList();
    await prefs.setStringList(
      _scoresListKey,
      topScores.map((s) => s.toString()).toList(),
    );
  }

  Future<List<int>> getTopScores() async {
    final prefs = await SharedPreferences.getInstance();
    final scoreStrings = prefs.getStringList(_scoresListKey) ?? [];
    return scoreStrings.map((s) => int.parse(s)).toList();
  }

  Future<void> clearScores() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_highScoreKey);
    await prefs.remove(_scoresListKey);
  }
}
