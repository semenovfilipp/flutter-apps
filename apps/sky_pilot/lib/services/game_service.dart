import 'dart:async';
import '../models/obstacle.dart';
import '../models/plane_type.dart';

class GameService {
  PlaneType selectedPlane = PlaneType.classic;
  double planeX = 100;
  double planeY = 200;
  double targetY = 200;
  int score = 0;
  bool isGameOver = false;
  double gameSpeed = 1.0;

  List<Obstacle> obstacles = [];
  Timer? _obstacleTimer;
  double _screenWidth = 0;
  double _screenHeight = 0;

  final double obstacleSpawnInterval = 2.0;
  double _timeSinceLastObstacle = 0;

  void initialize(double screenWidth, double screenHeight) {
    _screenWidth = screenWidth;
    _screenHeight = screenHeight;
    reset();
  }

  void reset() {
    planeX = 100;
    planeY = _screenHeight / 2;
    targetY = planeY;
    score = 0;
    isGameOver = false;
    gameSpeed = 1.0;
    obstacles.clear();
    _timeSinceLastObstacle = 0;
  }

  void setPlaneType(PlaneType type) {
    selectedPlane = type;
  }

  void movePlane(double newY) {
    if (!isGameOver) {
      targetY = newY.clamp(
        PlaneModel.getPlaneByType(selectedPlane).size / 2,
        _screenHeight - PlaneModel.getPlaneByType(selectedPlane).size / 2,
      );
    }
  }

  void update(double delta) {
    if (isGameOver) return;

    final plane = PlaneModel.getPlaneByType(selectedPlane);
    final planeSpeed = plane.speed;

    if ((targetY - planeY).abs() > 1) {
      final direction = targetY > planeY ? 1 : -1;
      planeY += direction * planeSpeed * delta;
      planeY = planeY.clamp(0, _screenHeight - plane.size);
    }

    _timeSinceLastObstacle += delta;
    if (_timeSinceLastObstacle >= obstacleSpawnInterval / gameSpeed) {
      obstacles.add(Obstacle.createRandom(_screenWidth, _screenHeight));
      _timeSinceLastObstacle = 0;
    }

    final baseSpeed = 200.0;
    obstacles.removeWhere((obstacle) {
      obstacle.update(delta, baseSpeed * gameSpeed);

      if (obstacle.isOffScreen()) {
        score += 10;
        if (score % 100 == 0) {
          gameSpeed += 0.1;
        }
        return true;
      }

      if (obstacle.collidesWith(planeX, planeY, plane.size)) {
        isGameOver = true;
        return false;
      }

      return false;
    });
  }

  void dispose() {
    _obstacleTimer?.cancel();
  }
}
