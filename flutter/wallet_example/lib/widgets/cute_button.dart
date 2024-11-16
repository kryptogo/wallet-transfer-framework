import 'package:flutter/material.dart';

class CuteButton extends StatelessWidget {
  const CuteButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.icon,
    this.width,
    this.height = 48,
    this.isLoading = false,
    this.borderRadius = 12,
    this.padding = const EdgeInsets.symmetric(horizontal: 24),
  });

  final VoidCallback? onPressed;
  final String label;
  final IconData? icon;
  final double? width;
  final double height;
  final Color backgroundColor = const Color.fromARGB(255, 215, 214, 209);
  final Color foregroundColor = const Color.fromARGB(255, 22, 21, 46);
  final bool isLoading;
  final double borderRadius;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: width,
      height: height,
      child: RawMaterialButton(
        onPressed: isLoading ? null : onPressed,
        fillColor: backgroundColor,
        elevation: 0,
        textStyle: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: foregroundColor,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: isLoading
            ? SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(foregroundColor),
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 18),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: foregroundColor,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
