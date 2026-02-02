import 'dart:async'; // Required for Timer
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/timer_provider.dart';
import '../utils/constants.dart';
import '../widgets/retro_button.dart';

class FullscreenTimerScreen extends StatefulWidget {
  const FullscreenTimerScreen({super.key});

  @override
  State<FullscreenTimerScreen> createState() => _FullscreenTimerScreenState();
}

class _FullscreenTimerScreenState extends State<FullscreenTimerScreen> {
  bool _showControls = true;
  Timer? _hideTimer;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    _startHideTimer();
  }

  void _startHideTimer() {
    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() => _showControls = false);
      }
    });
  }

  void _onInteraction() {
    if (!_showControls) {
      setState(() => _showControls = true);
    }
    _startHideTimer();
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    // Optionally restore System UI if needed
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TimerProvider>(
      builder: (context, timer, child) {
        return Scaffold(
          backgroundColor: Colors.black,
          body: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: _onInteraction,
            child: Stack(
              children: [
                // 1. Main Timer Display (Always centered)
                Center(
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40.0),
                      child: Text(
                        timer.formattedTime,
                        style: const TextStyle(
                          fontFamily: AppAssets.fontLcd,
                          color: AppColors.timerText,
                          fontSize: 180,
                          letterSpacing: 10,
                        ),
                      ),
                    ),
                  ),
                ),

                // 2. Session Label (Top Center)
                Positioned(
                  top: 40,
                  left: 0,
                  right: 0,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 500),
                    opacity: _showControls ? 1.0 : 0.0,
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: Text(
                          timer.selectedLabel,
                          style: TextStyle(
                            fontFamily: AppAssets.fontLcd,
                            fontSize: 48,
                            color: AppColors.getStatusColor(timer.sessionType),
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // 3. Control Buttons (Bottom Center)
                Positioned(
                  bottom: 40,
                  left: 0,
                  right: 0,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 500),
                    opacity: _showControls ? 1.0 : 0.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildControlButton(
                          isPrimary: true,
                          onTap: () {
                            _onInteraction();
                            timer.timerState == TimerState.running
                                ? timer.pauseTimer()
                                : timer.startTimer();
                          },
                          icon: timer.timerState == TimerState.running
                              ? Icons.pause_rounded
                              : Icons.play_arrow_rounded,
                          color: AppColors.iconActive,
                        ),
                        const SizedBox(width: 30),
                        _buildControlButton(
                          isPrimary: false,
                          onTap: () => Navigator.pop(context),
                          icon: Icons.fullscreen_exit_rounded,
                          color: AppColors.iconInactive,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildControlButton({
    required bool isPrimary,
    required VoidCallback onTap,
    required IconData icon,
    required Color color,
  }) {
    return SizedBox(
      width: 70,
      height: 70,
      child: RetroButton(
        isPrimary: isPrimary,
        onTap: onTap,
        child: Icon(icon, color: color, size: 35),
      ),
    );
  }
}
