import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/timer_provider.dart';
import '../models/timer_settings.dart';
import '../utils/constants.dart';
import '../widgets/retro_button.dart';
import '../widgets/slider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late int _workDuration;
  late int _shortBreakDuration;
  late int _longBreakDuration;
  late int _sessionsBeforeLongBreak;

  @override
  void initState() {
    super.initState();
    final timer = context.read<TimerProvider>();
    _workDuration = timer.settings.workDuration;
    _shortBreakDuration = timer.settings.shortBreakDuration;
    _longBreakDuration = timer.settings.longBreakDuration;
    _sessionsBeforeLongBreak = timer.settings.sessionsBeforeLongBreak;
  }

  void _saveSettings() {
    final timer = context.read<TimerProvider>();
    timer.updateSettings(
      TimerSettings(
        workDuration: _workDuration,
        shortBreakDuration: _shortBreakDuration,
        longBreakDuration: _longBreakDuration,
        sessionsBeforeLongBreak: _sessionsBeforeLongBreak,
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Focus Slider
                    _buildRetroSliderRow(
                      label: 'Focus',
                      value: _workDuration,
                      min: 1,
                      max: 60,
                      backgroundColor: AppColors.settingsFocusBg,
                      activeTrackColor: AppColors.sliderFocusActive,
                      textColor: Colors.white,
                      isPrimary: true,
                      onChanged: (val) => setState(() => _workDuration = val),
                    ),
                    const SizedBox(height: 20),
                    // Short Break Slider
                    _buildRetroSliderRow(
                      label: 'Short\nBreak',
                      value: _shortBreakDuration,
                      min: 1,
                      max: 30,
                      backgroundColor: AppColors.panelOuterBg,
                      activeTrackColor: AppColors.sliderBreakActive,
                      textColor: AppColors.settingsTextDark,
                      isPrimary: false,
                      onChanged: (val) =>
                          setState(() => _shortBreakDuration = val),
                    ),
                    const SizedBox(height: 20),
                    // Long Break Slider
                    _buildRetroSliderRow(
                      label: 'Long\nBreak',
                      value: _longBreakDuration,
                      min: 1,
                      max: 60,
                      backgroundColor: AppColors.panelOuterBg,
                      activeTrackColor: AppColors.sliderBreakActive,
                      textColor: AppColors.settingsTextDark,
                      isPrimary: false,
                      onChanged: (val) =>
                          setState(() => _longBreakDuration = val),
                    ),
                    const SizedBox(height: 20),
                    // Sessions Slider (Replaced Knob)
                    _buildRetroSliderRow(
                      label: 'Sessions Before Long Break',
                      value: _sessionsBeforeLongBreak,
                      min: 1,
                      max: 8,
                      backgroundColor: AppColors.panelOuterBg,
                      activeTrackColor: AppColors.rotaryKnob, // Orange
                      textColor: AppColors.settingsTextDark,
                      isPrimary: true,
                      unit: 'rounds',
                      onChanged: (val) =>
                          setState(() => _sessionsBeforeLongBreak = val),
                    ),

                    const SizedBox(height: 48),
                    _buildResetSection(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, color: Colors.black, size: 28),
          ),
          const SizedBox(width: 8),
          const Text(
            'SETTINGS',
            style: TextStyle(
              fontFamily: AppAssets.fontLcd,
              fontSize: 32,
              color: Colors.black,
              letterSpacing: 2,
            ),
          ),
          const Spacer(),
          SizedBox(
            height: 40,
            width: 84, // Constrain width for RetroButton
            child: RetroButton(
              isPrimary: true,
              onTap: _saveSettings,
              child: const Text(
                'SAVE',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRetroSliderRow({
    required String label,
    required int value,
    required int min,
    required int max,
    required Color backgroundColor,
    required Color activeTrackColor,
    required Color textColor,
    required bool isPrimary,
    required ValueChanged<int> onChanged,
    String unit = 'mins',
  }) {
    // Layout matching Frame2: Container -> Row [Label, Slider, Value]
    return Container(
      height: 100, // Fixed height to accommodate the tall thumb
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(4),
        boxShadow: const [
          BoxShadow(
            color: Color(0x60000000), // Darker shadow for depth
            offset: Offset(2, 2),
            blurRadius: 0,
          ),
          BoxShadow(
            color: Color(0xFFFAF8F7), // Light highlight
            offset: Offset(-2, -2),
            blurRadius: 0,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Label
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: TextStyle(
                fontFamily: AppAssets.fontLcd,
                fontSize: 14,
                color: textColor,
                height: 1.2,
              ),
            ),
          ),
          // Slider
          Expanded(
            child: SliderTheme(
              data: SliderThemeData(
                trackHeight: 8,
                activeTrackColor: activeTrackColor,
                inactiveTrackColor: AppColors.panelInnerBg,
                thumbShape: RetroSliderThumbShape(isPrimary: isPrimary),
                overlayShape: const RoundSliderOverlayShape(
                  overlayRadius: 0,
                ), // No overlay
                trackShape:
                    _RetroTrackShape(), // Custom track shape for rounded corners
              ),
              child: Slider(
                value: value.toDouble(),
                min: min.toDouble(),
                max: max.toDouble(),
                onChanged: (v) => onChanged(v.round()),
              ),
            ),
          ),
          // Value
          SizedBox(
            width: 70, // Slightly wider for unit text
            child: Text(
              '$value \n$unit',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: AppAssets.fontLcd,
                fontSize: 15,
                color: textColor,
                height: 1.2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResetSection() {
    return Center(
      child: TextButton(
        onPressed: () {
          // Reset logic
          context.read<TimerProvider>().resetHourTracker();
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Hours reset!')));
        },
        child: const Text(
          'RESET ALL STATS',
          style: TextStyle(color: Colors.grey),
        ),
      ),
    );
  }
}

class _RetroTrackShape extends RoundedRectSliderTrackShape {
  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required TextDirection textDirection,
    required Offset thumbCenter,
    Offset? secondaryOffset,
    bool isDiscrete = false,
    bool isEnabled = false,
    double additionalActiveTrackHeight = 0,
  }) {
    super.paint(
      context,
      offset,
      parentBox: parentBox,
      sliderTheme: sliderTheme,
      enableAnimation: enableAnimation,
      textDirection: textDirection,
      thumbCenter: thumbCenter,
      isEnabled: isEnabled,
    );
  }
}
