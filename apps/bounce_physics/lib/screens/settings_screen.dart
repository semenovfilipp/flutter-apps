import 'package:flutter/material.dart';
import '../models/physics_config.dart';
import '../services/storage_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _storageService = StorageService();
  late PhysicsConfig _config;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadConfig();
  }

  Future<void> _loadConfig() async {
    final config = await _storageService.getPhysicsConfig();
    setState(() {
      _config = config;
      _isLoading = false;
    });
  }

  Future<void> _saveConfig() async {
    await _storageService.savePhysicsConfig(_config);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Settings saved!'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _resetToDefaults() {
    setState(() {
      _config = PhysicsConfig();
    });
    _saveConfig();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Physics Settings'),
        backgroundColor: const Color(0xFF1E88E5),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.restore),
            onPressed: _resetToDefaults,
            tooltip: 'Reset to defaults',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Adjust physics parameters',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 30),
          _SettingSlider(
            title: 'Gravity',
            subtitle: 'How fast the ball falls',
            value: _config.gravity,
            min: 100,
            max: 1000,
            divisions: 90,
            onChanged: (value) {
              setState(() {
                _config = _config.copyWith(gravity: value);
              });
            },
          ),
          const Divider(height: 40),
          _SettingSlider(
            title: 'Bounce Damping',
            subtitle: 'Energy loss on bounce (lower = more bounce)',
            value: _config.bounceDamping,
            min: 0.3,
            max: 1.0,
            divisions: 70,
            onChanged: (value) {
              setState(() {
                _config = _config.copyWith(bounceDamping: value);
              });
            },
          ),
          const Divider(height: 40),
          _SettingSlider(
            title: 'Friction',
            subtitle: 'Air resistance (lower = more resistance)',
            value: _config.friction,
            min: 0.90,
            max: 1.0,
            divisions: 100,
            onChanged: (value) {
              setState(() {
                _config = _config.copyWith(friction: value);
              });
            },
          ),
          const SizedBox(height: 40),
          Center(
            child: ElevatedButton(
              onPressed: _saveConfig,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E88E5),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 50,
                  vertical: 15,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                'Save Settings',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingSlider extends StatelessWidget {
  final String title;
  final String subtitle;
  final double value;
  final double min;
  final double max;
  final int divisions;
  final ValueChanged<double> onChanged;

  const _SettingSlider({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              value.toStringAsFixed(2),
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF1E88E5),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Text(
          subtitle,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: divisions,
          activeColor: const Color(0xFF1E88E5),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
