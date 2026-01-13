import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/plane_type.dart';
import '../services/game_service.dart';
import '../services/score_service.dart';
import '../widgets/plane_widget.dart';
import '../widgets/obstacle_widget.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final GameService _gameService = GameService();
  final ScoreService _scoreService = ScoreService();
  Timer? _gameLoop;
  DateTime? _lastUpdate;
  PlaneType _selectedPlaneType = PlaneType.classic;

  @override
  void initState() {
    super.initState();
    _loadSelectedPlane();
  }

  Future<void> _loadSelectedPlane() async {
    final prefs = await SharedPreferences.getInstance();
    final planeIndex = prefs.getInt('selected_plane') ?? 0;
    setState(() {
      _selectedPlaneType = PlaneType.values[planeIndex];
      _gameService.setPlaneType(_selectedPlaneType);
    });
  }

  void _startGame() {
    final size = MediaQuery.of(context).size;
    _gameService.initialize(size.width, size.height);
    _lastUpdate = DateTime.now();

    _gameLoop = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      final now = DateTime.now();
      final delta = now.difference(_lastUpdate!).inMilliseconds / 1000.0;
      _lastUpdate = now;

      setState(() {
        _gameService.update(delta);
      });

      if (_gameService.isGameOver) {
        _endGame();
      }
    });
  }

  void _endGame() {
    _gameLoop?.cancel();
    _scoreService.saveScore(_gameService.score);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Game Over'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.sentiment_dissatisfied, size: 60, color: Colors.orange),
            const SizedBox(height: 20),
            Text(
              'Score: ${_gameService.score}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _gameService.reset();
                _startGame();
              });
            },
            child: const Text('Play Again'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Main Menu'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _gameLoop?.cancel();
    _gameService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final plane = PlaneModel.getPlaneByType(_selectedPlaneType);

    if (_gameLoop == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _startGame());
    }

    return Scaffold(
      body: GestureDetector(
        onTapDown: (details) {
          _gameService.movePlane(details.localPosition.dy);
        },
        onVerticalDragUpdate: (details) {
          _gameService.movePlane(details.localPosition.dy);
        },
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.lightBlue.shade200,
                Colors.lightBlue.shade400,
              ],
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                top: 50,
                left: 20,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Score: ${_gameService.score}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 50,
                right: 20,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Speed: ${_gameService.gameSpeed.toStringAsFixed(1)}x',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              for (var obstacle in _gameService.obstacles)
                Positioned(
                  left: obstacle.x,
                  top: obstacle.y,
                  child: ObstacleWidget(obstacle: obstacle),
                ),
              Positioned(
                left: _gameService.planeX,
                top: _gameService.planeY,
                child: PlaneWidget(plane: plane),
              ),
              Positioned(
                top: 50,
                left: MediaQuery.of(context).size.width / 2 - 40,
                child: IconButton(
                  icon: const Icon(Icons.pause, color: Colors.white, size: 32),
                  onPressed: () {
                    _gameLoop?.cancel();
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) => AlertDialog(
                        title: const Text('Paused'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              _lastUpdate = DateTime.now();
                              _startGame();
                            },
                            child: const Text('Resume'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.pop(context);
                            },
                            child: const Text('Main Menu'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
