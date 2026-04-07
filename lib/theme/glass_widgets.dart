import 'dart:ui';
import 'package:flutter/material.dart';

class GlassContainer extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final VoidCallback? onTap;

  const GlassContainer({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding = const EdgeInsets.all(16.0),
    this.margin,
    this.borderRadius = 24.0,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    final content = ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          width: width,
          height: height,
          padding: padding,
          decoration: BoxDecoration(
            color: isDark 
                ? Colors.white.withAlpha(13) 
                : Colors.white.withAlpha(102),
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: isDark 
                  ? Colors.white.withAlpha(26) 
                  : Colors.white.withAlpha(153),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(13),
                blurRadius: 20,
                spreadRadius: -5,
              ),
            ],
          ),
          child: child,
        ),
      ),
    );

    if (onTap != null) {
      return Padding(
        padding: margin ?? EdgeInsets.zero,
        child: GestureDetector(
          onTap: onTap,
          child: content,
        ),
      );
    }

    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: content,
    );
  }
}
