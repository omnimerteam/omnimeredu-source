import 'package:screen_brightness/screen_brightness.dart';
import 'package:flutter/services.dart';
import '../core/utils/logger.dart';

/// Service để điều chỉnh độ sáng màn hình
class BrightnessService {
  final ScreenBrightness _screenBrightness = ScreenBrightness();
  double? _originalBrightness;

  /// Get current brightness
  Future<double> getCurrentBrightness() async {
    try {
      return await _screenBrightness.current;
    } catch (e) {
      AppLogger.error('Failed to get brightness', e);
      return 0.5; // Default value
    }
  }

  /// Set screen brightness (0.0 to 1.0)
  Future<void> setBrightness(double brightness) async {
    try {
      // Clamp brightness between 0.0 and 1.0
      final clampedBrightness = brightness.clamp(0.0, 1.0);
      await _screenBrightness.setScreenBrightness(clampedBrightness);
      AppLogger.info('Brightness set to $clampedBrightness');
    } on PlatformException catch (e) {
      AppLogger.error('Failed to set brightness', e);
      throw BrightnessException('Cannot set brightness: ${e.message}');
    }
  }

  /// Set brightness to maximum (for QR display)
  Future<void> setMaxBrightness() async {
    try {
      // Save original brightness
      _originalBrightness = await getCurrentBrightness();
      await setBrightness(1.0);
      AppLogger.info('Brightness set to maximum. Original: $_originalBrightness');
    } catch (e) {
      AppLogger.error('Failed to set max brightness', e);
    }
  }

  /// Restore original brightness
  Future<void> restoreOriginalBrightness() async {
    if (_originalBrightness != null) {
      try {
        await setBrightness(_originalBrightness!);
        AppLogger.info('Brightness restored to $_originalBrightness');
        _originalBrightness = null;
      } catch (e) {
        AppLogger.error('Failed to restore brightness', e);
      }
    }
  }

  /// Reset brightness to system default
  Future<void> resetBrightness() async {
    try {
      await _screenBrightness.resetScreenBrightness();
      _originalBrightness = null;
      AppLogger.info('Brightness reset to system default');
    } catch (e) {
      AppLogger.error('Failed to reset brightness', e);
    }
  }
}

class BrightnessException implements Exception {
  final String message;
  BrightnessException(this.message);

  @override
  String toString() => message;
}

