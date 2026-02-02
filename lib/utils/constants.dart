import 'package:flutter/material.dart';
import '../providers/timer_provider.dart'; // Needed for SessionType enum if used in AppColors

// --- Constants ---
class AppColors {
  static const background = Color(0xFFE8E4DD);
  static const timerDisplayBg = Colors.black;
  static const timerText = Colors.white;

  // Retro Design Colors
  static const panelOuterBg = Color(0xFFD4CFC9);
  static const panelInnerBg = Color(0xFF3F3D3A);

  // Primary Button (Orange)
  static const btnPrimaryDepth = Color(0xFFC67300);
  static const btnPrimaryFaceTop = Color(0xFFF2AC4A);
  static const btnPrimaryFaceBottom = Color(0xFFFAC375);

  // Destructive Button (Red)
  static const btnDestructiveDepth = Color(0xFF8B0000); // Dark Red
  static const btnDestructiveFaceTop = Color(0xFFFF6B6B); // Light Red
  static const btnDestructiveFaceBottom = Color(0xFFEE5253); // Red

  // Secondary Button (Beige)
  static const btnSecondaryDepth = Color(0xFFAAA28A);
  static const btnSecondaryFaceTop = Color(0xFFE2DAC6);
  static const btnSecondaryFaceBottom = Color(0xFFD6CFBA);

  static const indicatorActive = Color(0xFFBBE62E);
  static const indicatorInactive = Color(0xFF4A5520);
  static const iconActive = Color(0xFF5D3A00);
  static const iconInactive = Color(0xFF5A5343);

  static Color getStatusColor(SessionType type) {
    switch (type) {
      case SessionType.work:
        return indicatorActive;
      case SessionType.shortBreak:
        return const Color(0xFF4ECDC4);
      case SessionType.longBreak:
        return const Color(0xFF6C5CE7);
    }
  }

  // Settings Screen Colors
  static const settingsFocusBg = Color(0xFFB7B4AB);
  static const sliderFocusActive = Color(0xFFEF7743);
  static const sliderBreakActive = Color(0xFFBCAF88);
  static const rotaryKnob = Color(0xFFEF7542);
  static const sessionDisplayBg = Color(0xFF050505);
  static const settingsTextDark = Color(0xFF686256);
}

class AppAssets {
  static const fontLcd = 'LcdSolid';
}
