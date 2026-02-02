import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/timer_provider.dart';
import '../utils/constants.dart';
import '../widgets/retro_button.dart';

class LabelSelectionDialog extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  LabelSelectionDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TimerProvider>(
      builder: (context, timer, _) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            width: 300,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.panelOuterBg,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black45,
                  offset: Offset(4, 4),
                  blurRadius: 0,
                ),
              ],
              border: Border.all(color: AppColors.panelInnerBg, width: 2),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'SELECT LABEL',
                  style: TextStyle(
                    fontFamily: AppAssets.fontLcd,
                    fontSize: 20,
                    color: AppColors.settingsTextDark,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: AppColors.panelInnerBg,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: timer.labels.length,
                    itemBuilder: (context, index) {
                      final label = timer.labels[index];
                      final isSelected = label == timer.selectedLabel;
                      return GestureDetector(
                        onTap: () {
                          timer.selectLabel(label);
                          Navigator.pop(context);
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.sliderFocusActive
                                : AppColors.panelOuterBg,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                label,
                                style: TextStyle(
                                  fontFamily: AppAssets.fontLcd,
                                  color: isSelected
                                      ? Colors.black
                                      : AppColors.settingsTextDark,
                                  fontSize: 16,
                                ),
                              ),
                              if (!isSelected && timer.labels.length > 1)
                                GestureDetector(
                                  onTap: () => timer.deleteLabel(label),
                                  child: const Icon(
                                    Icons.close,
                                    size: 16,
                                    color: AppColors.btnDestructiveDepth,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 48,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: AppColors.panelInnerBg,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Center(
                          child: TextField(
                            controller: _controller,
                            style: const TextStyle(
                              fontFamily: AppAssets.fontLcd,
                              color: Colors.white,
                              fontSize: 16,
                            ),
                            decoration: const InputDecoration(
                              hintText: 'New Label...',
                              hintStyle: TextStyle(
                                color: Colors.white30,
                                fontFamily: AppAssets.fontLcd,
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      height: 48,
                      width: 48,
                      child: RetroButton(
                        isPrimary: true,
                        onTap: () {
                          if (_controller.text.isNotEmpty) {
                            timer.addLabel(_controller.text);
                            _controller.clear();
                          }
                        },
                        child: const Icon(
                          Icons.add,
                          color: AppColors.iconActive,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
