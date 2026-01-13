import 'dart:async';
import 'package:flutter/material.dart';
import '../models/ball.dart';
import '../models/physics_config.dart';
import '../services/game_service.dart';
import '../services/storage_service.dart';
import '../widgets/game_canvas.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late GameService _gameService;
  late StorageService _storageService;
  Timer? _gameTimer;
  int _highScore = 0;
  Offset? _dragStart;
  Offset? _dragEnd;

  @override
  void initState() {
    super.initState();
    _storageService = StorageService();
    _loadHighScore();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initializeGame();
  }

  Future<void> _loadHighScore() async {
    final score = await _storageService.getHighScore();
    setState(() {
      _highScore = score;
    });
  }

  Future<void> _initializeGame() async {
    final size = MediaQuery.of(context).size;
    final ball = Ball(
      position: Offset(size.width / 2, size.height / 2),
      velocity: const Offset(0, 0),
    );

    final physicsConfig = await _storageService.getPhysicsConfig();

    _gameService = GameService(
      ball: ball,
      physicsConfig: physicsConfig,
      screenSize: size,
    );
  }

  void _startGameLoop() {
    const fps = 60;
    const frameDuration = Duration(milliseconds: 1000 ~/ fps);

    _gameTimer?.cancel();
    _gameTimer = Timer.periodic(frameDuration, (timer) {
      setState(() {
        _gameService.update(frameDuration.inMilliseconds / 1000);
      });

      if (_gameService.bounceCount > _highScore) {
        _highScore = _gameService.bounceCount;
        _storageService.saveHighScore(_highScore);
      }

      if (_gameService.isGameOver) {
        _stopGameLoop();
        _showGameOverDialog();
      }
    });
  }

  void _showGameOverDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text(
          'Game Over!',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E88E5),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.sports_basketball,
              size: 64,
              color: Color(0xFF1E88E5),
            ),
            const SizedBox(height: 20),
            Text(
              'Your Score: ${_gameService.bounceCount}',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'High Score: $_highScore',
              style: const TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text('Exit'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _resetGame();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1E88E5),
              foregroundColor: Colors.white,
            ),
            child: const Text('Play Again'),
          ),
        ],
      ),
    );
  }

  void _stopGameLoop() {
    _gameTimer?.cancel();
  }

  void _resetGame() {
    _stopGameLoop();
    setState(() {
      _gameService.reset();
      _dragStart = null;
      _dragEnd = null;
    });
  }

  void _onPanStart(DragStartDetails details) {
    if (!_gameService.ball.isLaunched) {
      setState(() {
        _dragStart = details.localPosition;
        _dragEnd = details.localPosition;
      });
    }
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (!_gameService.ball.isLaunched && _dragStart != null) {
      setState(() {
        _dragEnd = details.localPosition;
      });
    }
  }

  void _onPanEnd(DragEndDetails details) {
    if (!_gameService.ball.isLaunched && _dragStart != null && _dragEnd != null) {
      final direction = _dragEnd! - _dragStart!;
      if (direction.distance > 10) {
        _gameService.launchBall(direction);
        _startGameLoop();
        setState(() {
          _dragStart = null;
          _dragEnd = null;
        });
      }
    }
  }

  @override
  void dispose() {
    _stopGameLoop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BouncePhysics'),
        backgroundColor: const Color(0xFF1E88E5),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _resetGame,
          ),
        ],
      ),
      body: Stack(
        children: [
          GestureDetector(
            onPanStart: _onPanStart,
            onPanUpdate: _onPanUpdate,
            onPanEnd: _onPanEnd,
            child: Container(
              color: const Color(0xFF263238),
              child: GameCanvas(
                ball: _gameService.ball,
                obstacles: _gameService.obstacles,
              ),
            ),
          ),
          if (_dragStart != null && _dragEnd != null)
            CustomPaint(
              painter: _AimLinePainter(
                start: _dragStart!,
                end: _dragEnd!,
              ),
            ),
          Positioned(
            top: 20,
            left: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bounces: ${_gameService.bounceCount}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'High Score: $_highScore',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (!_gameService.ball.isLaunched)
            const Center(
              child: Text(
                'Swipe to launch the ball!',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _AimLinePainter extends CustomPainter {
  final Offset start;
  final Offset end;

  _AimLinePainter({required this.start, required this.end});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.yellow.withValues(alpha: 0.7)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    canvas.drawLine(start, end, paint);

    final arrowPaint = Paint()
      ..color = Colors.yellow
      ..style = PaintingStyle.fill;

    canvas.drawCircle(end, 8, arrowPaint);
  }

  @override
  bool shouldRepaint(_AimLinePainter oldDelegate) => true;
}
