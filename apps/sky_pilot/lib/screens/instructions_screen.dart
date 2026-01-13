import 'package:flutter/material.dart';

class InstructionsScreen extends StatelessWidget {
  const InstructionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('How to Play'),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.shade300,
              Colors.blue.shade600,
            ],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const SizedBox(height: 20),
            _InstructionCard(
              icon: Icons.touch_app,
              title: 'Controls',
              description:
                  'Tap or drag anywhere on the screen to move your plane up and down. '
                  'Your plane will smoothly follow your finger position.',
              color: Colors.blue,
            ),
            const SizedBox(height: 20),
            _InstructionCard(
              icon: Icons.assignment,
              title: 'Objective',
              description:
                  'Avoid obstacles (clouds and birds) while flying forward. '
                  'Your score increases with distance traveled. '
                  'The game ends if you hit an obstacle.',
              color: Colors.green,
            ),
            const SizedBox(height: 20),
            _InstructionCard(
              icon: Icons.speed,
              title: 'Difficulty',
              description:
                  'The game speed increases every 100 points. '
                  'Stay alert and test your reflexes as the challenge grows!',
              color: Colors.orange,
            ),
            const SizedBox(height: 20),
            _InstructionCard(
              icon: Icons.airplanemode_active,
              title: 'Planes',
              description:
                  'Choose from 3 different planes, each with unique characteristics:\n\n'
                  '• Classic: Balanced speed and control\n'
                  '• Speedy: Fast but harder to control\n'
                  '• Nimble: Slower but very responsive',
              color: Colors.purple,
            ),
            const SizedBox(height: 20),
            _InstructionCard(
              icon: Icons.emoji_events,
              title: 'Scoring',
              description:
                  'You earn 10 points for each obstacle you successfully pass. '
                  'Try to beat your high score and compete with your previous records!',
              color: Colors.amber,
            ),
            const SizedBox(height: 20),
            _InstructionCard(
              icon: Icons.pause,
              title: 'Pause',
              description:
                  'Tap the pause button at the top of the screen during gameplay '
                  'to pause the game. You can resume or return to the main menu.',
              color: Colors.red,
            ),
            const SizedBox(height: 40),
            Center(
              child: ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.check_circle, size: 28),
                label: const Text(
                  'Got It!',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.blue.shade700,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _InstructionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color color;

  const _InstructionCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    size: 32,
                    color: color,
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Text(
              description,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade800,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
