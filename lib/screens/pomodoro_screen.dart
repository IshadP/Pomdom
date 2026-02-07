import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/timer_provider.dart';
import '../utils/constants.dart';
import '../widgets/retro_button.dart';
import '../widgets/label_selection_dialog.dart';
import 'settings_screen.dart';
import 'fullscreen_timer_screen.dart';

// --- Main Screen ---
class PomodoroScreen extends StatefulWidget {
  const PomodoroScreen({super.key});

  @override
  State<PomodoroScreen> createState() => _PomodoroScreenState();
}

class _PomodoroScreenState extends State<PomodoroScreen> {
  @override
  void initState() {
    super.initState();
    _setFullScreen();
  }

  void _setFullScreen() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Consumer<TimerProvider>(
      builder: (context, timer, child) {
        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(screenSize.width * 0.04),
              child: Column(
                children: [
                  Expanded(
                    flex: 3,
                    child: TimerDisplay(
                      formattedTime: timer.formattedTime,
                      selectedLabel: timer.selectedLabel, // Pass label
                      sessionType: timer.sessionType,
                      screenSize: screenSize,
                    ),
                  ),
                  SizedBox(height: screenSize.height * 0.02),
                  ControlPanel(timer: timer, screenSize: screenSize),
                  SizedBox(height: screenSize.height * 0.02),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// --- Sub Widgets ---

class TimerDisplay extends StatelessWidget {
  final String formattedTime;
  final SessionType sessionType;
  final String selectedLabel; // Added
  final Size screenSize;

  const TimerDisplay({
    super.key,
    required this.formattedTime,
    required this.sessionType,
    required this.selectedLabel, // Added
    required this.screenSize,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () => _navigateToSettings(context),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.timerDisplayBg,
          borderRadius: BorderRadius.circular(screenSize.width * 0.04),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 24,
              left: 0,
              right: 0,
              child: Center(
                child: GestureDetector(
                  onTap: () => showDialog(
                    context: context,
                    builder: (context) => LabelSelectionDialog(),
                  ),
                  child: Text(
                    selectedLabel, // Use selectedLabel
                    style: TextStyle(
                      fontFamily: AppAssets.fontLcd,
                      fontSize: 24,
                      color: AppColors.getStatusColor(sessionType),
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ),
            ),
            Center(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenSize.width * 0.1,
                  ),
                  child: Text(
                    formattedTime,
                    style: TextStyle(
                      fontFamily: AppAssets.fontLcd,
                      fontSize: screenSize.width * 0.35,
                      color: AppColors.timerText,
                      letterSpacing: 8,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 12,
              right: 12,
              child: IconButton(
                iconSize: 28,
                // Use splashRadius to keep the tap effect contained
                splashRadius: 24,
                icon: const Icon(
                  Icons.fullscreen_rounded,
                  color: AppColors.timerText,
                ),
                onPressed: () => _navigateToFullscreen(context),
                // Tooltip is great for accessibility
                tooltip: 'Fullscreen',
              ),
            ),
            Positioned(
              bottom: 12,
              left: 12,
              child: IconButton(
                onPressed: () => _navigateToSettings(context),
                icon: const Icon(
                  Icons.settings_rounded,
                  color: AppColors.timerText,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToSettings(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SettingsScreen()),
    );
  }

  void _navigateToFullscreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const FullscreenTimerScreen()),
    );
  }
}

class ControlPanel extends StatelessWidget {
  final TimerProvider timer;
  final Size screenSize;

  const ControlPanel({
    super.key,
    required this.timer,
    required this.screenSize,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate height based on width to ensure buttons are roughly square
    // 4 flex units total (2+1+1).
    // If small button is 1 unit width, we want height to be roughly 1 unit + padding
    final buttonWidthEstimate = (screenSize.width * 0.9) / 4;
    final panelHeight = buttonWidthEstimate + 24; // height + vertical padding

    return Container(
      width: double.infinity,
      height: panelHeight,
      padding: const EdgeInsets.all(4),
      decoration: ShapeDecoration(
        color: AppColors.panelOuterBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        shadows: const [
          BoxShadow(
            color: Color(0x3F000000),
            blurRadius: 0,
            offset: Offset(2, 2),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Color(0xFFFAF8F7),
            blurRadius: 0,
            offset: Offset(-2, -2),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              decoration: ShapeDecoration(
                color: AppColors.panelInnerBg,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(flex: 2, child: _buildPlayPauseButton()),
                  const SizedBox(width: 2),
                  Expanded(flex: 1, child: _buildResetButton()),
                  const SizedBox(width: 2),
                  Expanded(flex: 1, child: _buildSkipButton()),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          StatusIndicator(timer: timer),
        ],
      ),
    );
  }

  Widget _buildPlayPauseButton() {
    return RetroButton(
      isPrimary: true,
      onTap: () {
        if (timer.timerState == TimerState.running) {
          timer.pauseTimer();
        } else {
          timer.startTimer();
        }
      },
      child: Icon(
        timer.timerState == TimerState.running
            ? Icons.pause_rounded
            : Icons.play_arrow_rounded,
        color: AppColors.iconActive,
        size: 44,
      ),
    );
  }

  Widget _buildResetButton() {
    return RetroButton(
      isPrimary: false,
      onTap: timer.resetTimer,
      child: const Icon(
        Icons.replay_rounded,
        color: AppColors.iconInactive,
        size: 44,
      ),
    );
  }

  Widget _buildSkipButton() {
    return RetroButton(
      isPrimary: false,
      onTap: timer.skipSession,
      child: const Icon(
        Icons.skip_next_rounded,
        color: AppColors.iconInactive,
        size: 44,
      ),
    );
  }
}

class StatusIndicator extends StatelessWidget {
  final TimerProvider timer;

  const StatusIndicator({super.key, required this.timer});

  @override
  Widget build(BuildContext context) {
    final isRunning = timer.timerState == TimerState.running;
    final statusColor = AppColors.getStatusColor(timer.sessionType);

    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 8,
        decoration: ShapeDecoration(
          color: isRunning ? statusColor : AppColors.indicatorInactive,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          shadows: isRunning
              ? [
                  BoxShadow(
                    color: statusColor.withValues(alpha: 0.6),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ]
              : null,
        ),
        child: Stack(
          children: [
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: Container(
                width: 4,
                decoration: ShapeDecoration(
                  color: Colors.white.withValues(alpha: 0.3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
