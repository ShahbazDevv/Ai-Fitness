import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

class GlassButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isGradient;
  final bool isLoading;
  final double? width;
  final double height;
  final IconData? icon;
  final Widget? trailingIcon;

  const GlassButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isGradient = false,
    this.isLoading = false,
    this.width,
    this.height = 54,
    this.icon,
    this.trailingIcon,
  });

  @override
  State<GlassButton> createState() => _GlassButtonState();
}

class _GlassButtonState extends State<GlassButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final style = ElevatedButton.styleFrom(
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.white,
      shadowColor: Colors.transparent,
      elevation: 0,
      padding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(27),
      ),
    );

    final innerContent = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.isLoading)
          const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          )
        else ...[
          if (widget.icon != null) ...[
            Icon(widget.icon, size: 20, color: Colors.white),
            const SizedBox(width: 8),
          ],
          Text(
            widget.text,
            style: AppTextStyles.titleMd.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          if (widget.trailingIcon != null) ...[
            const SizedBox(width: 8),
            widget.trailingIcon!,
          ],
        ],
      ],
    );

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: child,
        );
      },
      child: Container(
        width: widget.width ?? double.infinity,
        height: widget.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(27),
          gradient: widget.isGradient ? AppColors.redGradient : null,
          color: widget.isGradient ? null : AppColors.surface.withValues(alpha: 0.6),
          border: widget.isGradient ? null : Border.all(color: AppColors.borderLight, width: 1.5),
          boxShadow: widget.isGradient
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 0),
                  ),
                ]
              : null,
        ),
        child: ElevatedButton(
          style: style,
          onPressed: widget.isLoading
              ? null
              : () {
                  _controller.forward().then((_) => _controller.reverse());
                  widget.onPressed();
                },
          child: innerContent,
        ),
      ),
    );
  }
}
