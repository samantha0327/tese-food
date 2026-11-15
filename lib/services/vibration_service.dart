import 'package:vibration/vibration.dart';

class VibrationService {
  /// Vibración corta — para confirmaciones simples
  static Future<void> light() async {
    final hasVibrator = await Vibration.hasVibrator();
    if (hasVibrator == true) {
      Vibration.vibrate(duration: 100);
    }
  }

  /// Vibración media — para acciones importantes
  static Future<void> medium() async {
    final hasVibrator = await Vibration.hasVibrator();
    if (hasVibrator == true) {
      Vibration.vibrate(duration: 300);
    }
  }

  /// Vibración larga — para alertas como pedido listo
  static Future<void> strong() async {
    final hasVibrator = await Vibration.hasVibrator();
    if (hasVibrator == true) {
      Vibration.vibrate(pattern: [0, 400, 200, 400]);
    }
  }

  /// Vibración de éxito — patrón doble
  static Future<void> success() async {
    final hasVibrator = await Vibration.hasVibrator();
    if (hasVibrator == true) {
      Vibration.vibrate(pattern: [0, 200, 100, 200]);
    }
  }
}
