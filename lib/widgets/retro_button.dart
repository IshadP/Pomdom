import 'package:flutter/material.dart';
import '../utils/constants.dart';

class RetroButton extends StatefulWidget {
  final bool isPrimary;
  final bool isDestructive;
  final VoidCallback onTap;
  final Widget child;
  final double? width;
  final double? height;

  const RetroButton({
    super.key,
    required this.isPrimary,
    this.isDestructive = false,
    required this.onTap,
    required this.child,
    this.width,
    this.height,
  });

  @override
  State<RetroButton> createState() => _RetroButtonState();
}

class _RetroButtonState extends State<RetroButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final depthColor = widget.isDestructive
        ? AppColors.btnDestructiveDepth
        : (widget.isPrimary
              ? AppColors.btnPrimaryDepth
              : AppColors.btnSecondaryDepth);

    final faceGradient = LinearGradient(
      begin: const Alignment(1.00, 0.50),
      end: const Alignment(0.00, 0.50),
      colors: widget.isDestructive
          ? [
              AppColors.btnDestructiveFaceTop,
              AppColors.btnDestructiveFaceBottom,
            ]
          : (widget.isPrimary
                ? [AppColors.btnPrimaryFaceTop, AppColors.btnPrimaryFaceBottom]
                : [
                    AppColors.btnSecondaryFaceTop,
                    AppColors.btnSecondaryFaceBottom,
                  ]),
    );

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInOut,
        margin: EdgeInsets.only(top: _isPressed ? 6 : 0),
        width: widget.width,
        height: widget.height,
        // The outer container mimics the "depth" or side of the keycap
        padding: EdgeInsets.only(
          top: 2,
          left: 2,
          right: 2,
          bottom: _isPressed
              ? 2
              : 8, // Animate bottom padding to simulate press
        ),
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          color: depthColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Container(
          // The inner container is the top face of the keycap
          width: double.infinity,
          height: double.infinity, // Fill available space
          decoration: ShapeDecoration(
            gradient: faceGradient,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            shadows: _isPressed
                ? []
                : [
                    // Subtle highlight on top edge for 3D effect
                    BoxShadow(
                      color: Colors.white.withOpacity(0.4),
                      blurRadius: 0,
                      offset: const Offset(0, 1),
                      spreadRadius: 0,
                    ),
                  ],
          ),
          child: Center(child: widget.child),
        ),
      ),
    );
  }
}
