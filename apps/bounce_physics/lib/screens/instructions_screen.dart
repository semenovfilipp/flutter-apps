import 'package:flutter/material.dart';

class InstructionsScreen extends StatelessWidget {
  const InstructionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Instructions'),
        backgroundColor: const Color(0xFF1E88E5),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Center(
            child: Icon(
              Icons.help_outline,
              size: 80,
              color: Color(0xFF1E88E5),
            ),
          ),
          const SizedBox(height: 20),
          const Center(
            child: Text(
              'How to Play',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 30),
          _InstructionCard(
            icon: Icons.touch_app,
            title: 'Launch the Ball',
            description: 'Tap and drag on the screen to aim, then release to launch the ball in that direction.',
          ),
          const SizedBox(height: 20),
          _InstructionCard(
            icon: Icons.sports_basketball,
            title: 'Bounce Around',
            description: 'The ball will bounce off walls and obstacles. Each bounce increases your score!',
          ),
          const SizedBox(height: 20),
          _InstructionCard(
            icon: Icons.settings,
            title: 'Customize Physics',
            description: 'Visit Physics Settings to adjust gravity, bounce damping, and friction to create different gameplay experiences.',
          ),
          const SizedBox(height: 20),
          _InstructionCard(
            icon: Icons.refresh,
            title: 'Reset',
            description: 'Use the reset button in the game screen to restart with a new ball launch.',
          ),
          const SizedBox(height: 20),
          _InstructionCard(
            icon: Icons.emoji_events,
            title: 'High Score',
            description: 'Your highest bounce count is automatically saved. Try to beat your record!',
          ),
          const SizedBox(height: 30),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Column(
              children: [
                Icon(
                  Icons.lightbulb_outline,
                  color: Color(0xFFFF9800),
                  size: 40,
                ),
                SizedBox(height: 10),
                Text(
                  'Tips',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  '• Longer swipes create faster launches\n'
                  '• Try different launch angles\n'
                  '• Adjust physics settings for easier or harder gameplay\n'
                  '• Watch how the ball interacts with obstacles',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InstructionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _InstructionCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF1E88E5).withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 32,
                color: const Color(0xFF1E88E5),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
