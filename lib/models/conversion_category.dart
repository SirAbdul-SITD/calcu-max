import 'package:flutter/material.dart';

enum ConversionCategory {
  length,
  weight,
  time,
  speed,
  distance,
  currency,
}

extension ConversionCategoryExtension on ConversionCategory {
  String get displayName {
    switch (this) {
      case ConversionCategory.length:
        return 'Length';
      case ConversionCategory.weight:
        return 'Weight';
      case ConversionCategory.time:
        return 'Time';
      case ConversionCategory.speed:
        return 'Speed';
      case ConversionCategory.distance:
        return 'Distance';
      case ConversionCategory.currency:
        return 'Currency';
    }
  }

  IconData get icon {
    switch (this) {
      case ConversionCategory.length:
        return Icons.straighten;
      case ConversionCategory.weight:
        return Icons.fitness_center;
      case ConversionCategory.time:
        return Icons.access_time;
      case ConversionCategory.speed:
        return Icons.speed;
      case ConversionCategory.distance:
        return Icons.social_distance;
      case ConversionCategory.currency:
        return Icons.attach_money;
    }
  }
}
