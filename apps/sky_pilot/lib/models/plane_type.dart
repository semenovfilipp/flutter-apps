import 'package:flutter/material.dart';

enum PlaneType {
  classic,
  fast,
  agile,
}

class PlaneModel {
  final PlaneType type;
  final String name;
  final double speed;
  final double size;
  final Color color;
  final String description;

  const PlaneModel({
    required this.type,
    required this.name,
    required this.speed,
    required this.size,
    required this.color,
    required this.description,
  });

  static const List<PlaneModel> availablePlanes = [
    PlaneModel(
      type: PlaneType.classic,
      name: 'Classic',
      speed: 200.0,
      size: 50.0,
      color: Colors.blue,
      description: 'Balanced speed and maneuverability',
    ),
    PlaneModel(
      type: PlaneType.fast,
      name: 'Speedy',
      speed: 300.0,
      size: 45.0,
      color: Colors.red,
      description: 'High speed, harder to control',
    ),
    PlaneModel(
      type: PlaneType.agile,
      name: 'Nimble',
      speed: 150.0,
      size: 40.0,
      color: Colors.green,
      description: 'Slower but very responsive',
    ),
  ];

  static PlaneModel getPlaneByType(PlaneType type) {
    return availablePlanes.firstWhere((plane) => plane.type == type);
  }
}
