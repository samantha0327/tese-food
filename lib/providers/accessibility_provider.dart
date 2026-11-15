import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum TextSizeOption { small, normal, large }

class AccessibilityProvider extends ChangeNotifier {
  bool _highContrast = false;
  bool _vibrationEnabled = true;
  bool _visualAlerts = true;
  TextSizeOption _textSize = TextSizeOption.normal;

  bool get highContrast => _highContrast;
  bool get vibrationEnabled => _vibrationEnabled;
  bool get visualAlerts => _visualAlerts;
  TextSizeOption get textSize => _textSize;

  // Factor de escala para texto
  double get textScaleFactor {
    switch (_textSize) {
      case TextSizeOption.small:
        return 0.85;
      case TextSizeOption.normal:
        return 1.0;
      case TextSizeOption.large:
        return 1.25;
    }
  }

  // Colores según el modo
  Color get backgroundColor =>
      _highContrast ? const Color(0xFF000000) : const Color(0xFFF5F0E8);

  Color get primaryColor =>
      _highContrast ? const Color(0xFF00FF00) : const Color(0xFF2D5016);

  Color get cardColor =>
      _highContrast ? const Color(0xFF1A1A1A) : const Color(0xFFFFFFFF);

  Color get textColor =>
      _highContrast ? const Color(0xFFFFFFFF) : const Color(0xFF1A1A1A);

  Color get secondaryTextColor =>
      _highContrast ? const Color(0xFFCCCCCC) : const Color(0xFF6B6B6B);

  Color get accentColor =>
      _highContrast ? const Color(0xFFFFFF00) : const Color(0xFF4A7C2F);

  AccessibilityProvider() {
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    _highContrast = prefs.getBool('highContrast') ?? false;
    _vibrationEnabled = prefs.getBool('vibrationEnabled') ?? true;
    _visualAlerts = prefs.getBool('visualAlerts') ?? true;
    final textSizeIndex = prefs.getInt('textSize') ?? 1;
    _textSize = TextSizeOption.values[textSizeIndex];
    notifyListeners();
  }

  Future<void> setHighContrast(bool value) async {
    _highContrast = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('highContrast', value);
    notifyListeners();
  }

  Future<void> setVibration(bool value) async {
    _vibrationEnabled = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('vibrationEnabled', value);
    notifyListeners();
  }

  Future<void> setVisualAlerts(bool value) async {
    _visualAlerts = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('visualAlerts', value);
    notifyListeners();
  }

  Future<void> setTextSize(TextSizeOption option) async {
    _textSize = option;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('textSize', option.index);
    notifyListeners();
  }
}
