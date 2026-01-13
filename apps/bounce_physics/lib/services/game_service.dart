import 'dart:ui';
import '../models/ball.dart';
import '../models/obstacle.dart';
import '../models/physics_config.dart';

class GameService {
  Ball ball;
  List<Obstacle> obstacles = [];
  PhysicsConfig physicsConfig;
  int bounceCount = 0;
  Size screenSize;
  bool isGameOver = false;

  GameService({
    required this.ball,
    required this.physicsConfig,
    required this.screenSize,
  }) {
    _initializeObstacles();
  }

  void _initializeObstacles() {
    obstacles = [
      Obstacle(
        rect: Rect.fromLTWH(50, screenSize.height * 0.3, 100, 20),
        color: const Color(0xFF4CAF50),
      ),
      Obstacle(
        rect: Rect.fromLTWH(screenSize.width - 150, screenSize.height * 0.4, 100, 20),
        color: const Color(0xFF2196F3),
      ),
      Obstacle(
        rect: Rect.fromLTWH(screenSize.width / 2 - 50, screenSize.height * 0.5, 100, 20),
        color: const Color(0xFFF44336),
      ),
      Obstacle(
        rect: Rect.fromLTWH(100, screenSize.height * 0.65, 80, 20),
        color: const Color(0xFFFF9800),
      ),
      Obstacle(
        rect: Rect.fromLTWH(screenSize.width - 180, screenSize.height * 0.75, 80, 20),
        color: const Color(0xFF9C27B0),
      ),
    ];
  }

  void update(double deltaTime) {
    if (!ball.isLaunched || isGameOver) return;

    ball.velocity = Offset(
      ball.velocity.dx * physicsConfig.friction,
      ball.velocity.dy + physicsConfig.gravity * deltaTime,
    );

    ball.updatePosition(deltaTime);

    _checkWallCollisions();
    _checkObstacleCollisions();
    _checkGameOver();
  }

  void _checkGameOver() {
    const stationaryThreshold = 10.0;

    // Check if ball is on the floor
    final isOnFloor = ball.position.dy + ball.radius >= screenSize.height - 1;

    // Check if ball is essentially not moving
    final isStationary = ball.velocity.dx.abs() < stationaryThreshold &&
                        ball.velocity.dy.abs() < stationaryThreshold;

    // Game over if ball is on floor and not moving
    if (isOnFloor && isStationary) {
      isGameOver = true;
    }
  }

  void _checkWallCollisions() {
    const minBounceVelocity = 50.0;

    // Left wall
    if (ball.position.dx - ball.radius < 0 && ball.velocity.dx < 0) {
      ball.position = Offset(ball.radius, ball.position.dy);
      ball.velocity = Offset(-ball.velocity.dx * physicsConfig.bounceDamping, ball.velocity.dy);
      bounceCount++;
    }

    // Right wall
    if (ball.position.dx + ball.radius > screenSize.width && ball.velocity.dx > 0) {
      ball.position = Offset(screenSize.width - ball.radius, ball.position.dy);
      ball.velocity = Offset(-ball.velocity.dx * physicsConfig.bounceDamping, ball.velocity.dy);
      bounceCount++;
    }

    // Top wall (ceiling)
    if (ball.position.dy - ball.radius < 0 && ball.velocity.dy < 0) {
      ball.position = Offset(ball.position.dx, ball.radius);
      ball.velocity = Offset(ball.velocity.dx, -ball.velocity.dy * physicsConfig.bounceDamping);
      bounceCount++;
    }

    // Floor (bottom)
    if (ball.position.dy + ball.radius > screenSize.height && ball.velocity.dy > 0) {
      ball.position = Offset(ball.position.dx, screenSize.height - ball.radius);
      final newVelocityY = -ball.velocity.dy * physicsConfig.bounceDamping;

      // If bounce would be too weak, stop the ball
      if (newVelocityY.abs() < minBounceVelocity) {
        ball.velocity = Offset(ball.velocity.dx * 0.95, 0);
      } else {
        ball.velocity = Offset(ball.velocity.dx, newVelocityY);
        bounceCount++;
      }
    }
  }

  void _checkObstacleCollisions() {
    for (var obstacle in obstacles) {
      if (_ballIntersectsRect(obstacle.rect)) {
        final ballCenter = ball.position;

        if ((ballCenter.dx < obstacle.rect.left || ballCenter.dx > obstacle.rect.right)) {
          ball.velocity = Offset(-ball.velocity.dx * physicsConfig.bounceDamping, ball.velocity.dy);
        } else {
          ball.velocity = Offset(ball.velocity.dx, -ball.velocity.dy * physicsConfig.bounceDamping);
        }

        _pushBallOutOfObstacle(obstacle.rect);
        bounceCount++;
        break;
      }
    }
  }

  bool _ballIntersectsRect(Rect rect) {
    final closestX = ball.position.dx.clamp(rect.left, rect.right);
    final closestY = ball.position.dy.clamp(rect.top, rect.bottom);

    final distanceX = ball.position.dx - closestX;
    final distanceY = ball.position.dy - closestY;

    return (distanceX * distanceX + distanceY * distanceY) < (ball.radius * ball.radius);
  }

  void _pushBallOutOfObstacle(Rect rect) {
    final ballCenter = ball.position;
    final rectCenter = rect.center;

    final dx = ballCenter.dx - rectCenter.dx;
    final dy = ballCenter.dy - rectCenter.dy;

    if (dx.abs() > dy.abs()) {
      if (dx > 0) {
        ball.position = Offset(rect.right + ball.radius, ball.position.dy);
      } else {
        ball.position = Offset(rect.left - ball.radius, ball.position.dy);
      }
    } else {
      if (dy > 0) {
        ball.position = Offset(ball.position.dx, rect.bottom + ball.radius);
      } else {
        ball.position = Offset(ball.position.dx, rect.top - ball.radius);
      }
    }
  }

  void reset() {
    ball.reset(Offset(screenSize.width / 2, screenSize.height / 2));
    bounceCount = 0;
    isGameOver = false;
  }

  void launchBall(Offset direction) {
    final speed = 300.0;
    final normalizedDirection = Offset(
      direction.dx / direction.distance,
      direction.dy / direction.distance,
    );
    ball.launch(Offset(
      normalizedDirection.dx * speed,
      normalizedDirection.dy * speed,
    ));
  }
}
