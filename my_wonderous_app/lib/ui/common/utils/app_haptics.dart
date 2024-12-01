import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:wonders/logic/common/platform_info.dart';

class AppHaptics {
  static bool debugSound = kDebugMode && enbaleDebugLogs;
  static bool debugLog = kDebugMode && enbaleDebugLogs;

  static bool enbaleDebugLogs = false;

  static void buttonPress() {
    if(!kIsWeb && PlatformInfo.isAndroid) {
      lightImpact();
    }
  }


  static Future<void> lightImpact(){
    return HapticFeedback.lightImpact();

  }

  static Future<void> mediumImpact(){
    return HapticFeedback.mediumImpact();
  }

  static Future<void>haveyImpact(){
    return HapticFeedback.heavyImpact();
  }

  static Future<void> selectionClick(){
    return HapticFeedback.selectionClick();
  }

  static Future<void> vibrate() {
    return HapticFeedback.vibrate();
  }

  static void _debug(String label) {
    if(debugLog) debugPrint("Haptic.$label");
    if(debugSound) {
      SystemSound.play(SystemSoundType.alert);
      SystemSound.play(SystemSoundType.click);
    }
  }


















}