import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';

/// Global theme definition for Relief Radar.
class AppTheme {
  AppTheme._();

  // Core Brand & Tactical Palette
  static const Color primaryCyan = Color(0xFF00E5FF);
  static const Color deepCharcoal = Color(0xFF151C24);
  static const Color surfaceCharcoal = Color(0xFF1E2732);
  static const Color borderCharcoal = Color(0xFF283545);
  static const Color backgroundObsidian = Color(0xFF0C1015);

  /// High-contrast offline monospace tactical typography for HUD readouts, coordinates, and timers.
  static TextStyle tacticalMono({
    Color color = primaryCyan,
    double fontSize = 12.0,
    FontWeight fontWeight = FontWeight.w600,
  }) {
    return TextStyle(
      fontFamily: 'ShareTechMono',
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
      letterSpacing: 0.6,
    );
  }

  /// Sleek, Play Store-ready dark theme with electric cyan accents, offline tactical Rajdhani typography,
  /// and glassmorphism defaults.
  static ThemeData get darkTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: primaryCyan,
      brightness: Brightness.dark,
      primary: primaryCyan,
      onPrimary: backgroundObsidian,
      surface: surfaceCharcoal,
      onSurface: Colors.white,
    );

    const String fontFam = 'Rajdhani';
    const tacticalTextTheme = TextTheme(
      displayLarge: TextStyle(
        fontFamily: fontFam,
        color: Colors.white,
        fontWeight: FontWeight.w700,
        fontSize: 32,
      ),
      displayMedium: TextStyle(
        fontFamily: fontFam,
        color: Colors.white,
        fontWeight: FontWeight.w700,
        fontSize: 28,
      ),
      displaySmall: TextStyle(
        fontFamily: fontFam,
        color: Colors.white,
        fontWeight: FontWeight.w700,
        fontSize: 24,
      ),
      headlineMedium: TextStyle(
        fontFamily: fontFam,
        color: Colors.white,
        fontWeight: FontWeight.w700,
        fontSize: 20,
      ),
      headlineSmall: TextStyle(
        fontFamily: fontFam,
        color: Colors.white,
        fontWeight: FontWeight.w600,
        fontSize: 18,
      ),
      titleLarge: TextStyle(
        fontFamily: fontFam,
        color: Colors.white,
        fontWeight: FontWeight.w700,
        fontSize: 18,
        letterSpacing: 0.4,
      ),
      titleMedium: TextStyle(
        fontFamily: fontFam,
        color: Colors.white,
        fontWeight: FontWeight.w600,
        fontSize: 16,
        letterSpacing: 0.3,
      ),
      titleSmall: TextStyle(
        fontFamily: fontFam,
        color: primaryCyan,
        fontWeight: FontWeight.w700,
        fontSize: 14,
        letterSpacing: 0.5,
      ),
      bodyLarge: TextStyle(
        fontFamily: fontFam,
        color: Colors.white,
        fontWeight: FontWeight.w600,
        fontSize: 15,
      ),
      bodyMedium: TextStyle(
        fontFamily: fontFam,
        color: Color(0xFFE2E8F0),
        fontWeight: FontWeight.w500,
        fontSize: 13.5,
      ),
      bodySmall: TextStyle(
        fontFamily: fontFam,
        color: Color(0xFF94A3B8),
        fontWeight: FontWeight.w500,
        fontSize: 12,
      ),
      labelLarge: TextStyle(
        fontFamily: fontFam,
        color: Colors.white,
        fontWeight: FontWeight.w700,
        fontSize: 13,
        letterSpacing: 0.8,
      ),
      labelMedium: TextStyle(
        fontFamily: fontFam,
        color: primaryCyan,
        fontWeight: FontWeight.w700,
        fontSize: 11.5,
        letterSpacing: 0.6,
      ),
      labelSmall: TextStyle(
        fontFamily: fontFam,
        color: Color(0xFF94A3B8),
        fontWeight: FontWeight.w600,
        fontSize: 10,
        letterSpacing: 0.5,
      ),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: fontFam,
      scaffoldBackgroundColor: deepCharcoal,
      primaryColor: primaryCyan,
      colorScheme: colorScheme,
      textTheme: tacticalTextTheme,
      cardTheme: CardThemeData(
        color: surfaceCharcoal.withValues(alpha: 0.70),
        elevation: 3.0,
        shadowColor: primaryCyan.withValues(alpha: 0.15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
          side: const BorderSide(
            color: borderCharcoal,
            width: 1.0,
          ),
        ),
        clipBehavior: Clip.antiAlias,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: surfaceCharcoal.withValues(alpha: 0.78),
        surfaceTintColor: Colors.transparent,
        modalBackgroundColor: surfaceCharcoal.withValues(alpha: 0.78),
        elevation: 16.0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
        ),
        clipBehavior: Clip.antiAlias,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryCyan,
        foregroundColor: backgroundObsidian,
        elevation: 6.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: deepCharcoal,
        foregroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: deepCharcoal,
        selectedItemColor: primaryCyan,
        unselectedItemColor: Color(0xFF64748B),
        elevation: 8,
      ),
      dividerTheme: const DividerThemeData(
        color: borderCharcoal,
        thickness: 1.0,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: surfaceCharcoal.withValues(alpha: 0.88),
        surfaceTintColor: Colors.transparent,
        elevation: 16.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
          side: const BorderSide(color: borderCharcoal, width: 1.0),
        ),
      ),
    );
  }

  /// Displays a floating tactical glassmorphic SnackBar with glowing border and iconography.
  static void showTacticalSnackbar(
    BuildContext context,
    String message, {
    bool isSuccess = true,
    Color? customColor,
    IconData? icon,
    Duration duration = const Duration(seconds: 4),
    SnackBarAction? action,
  }) {
    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger == null) return;

    final themeColor =
        customColor ??
        (isSuccess ? const Color(0xFF2E7D32) : const Color(0xFFC62828));
    final defaultIcon = isSuccess
        ? Icons.check_circle_outline_rounded
        : Icons.warning_amber_rounded;

    messenger.clearSnackBars();
    messenger.showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        duration: duration,
        action: action,
        content: GlassContainer(
          borderRadius: BorderRadius.circular(14.0),
          glowColor: themeColor,
          borderColor: themeColor.withValues(alpha: 0.65),
          borderWidth: 1.2,
          backgroundColor: const Color(0xFF151C24).withValues(alpha: 0.92),
          padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: themeColor.withValues(alpha: 0.16),
                  border: Border.all(
                    color: themeColor.withValues(alpha: 0.55),
                    width: 1.2,
                  ),
                ),
                child: Icon(
                  icon ?? defaultIcon,
                  color: themeColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(
                    fontFamily: 'Rajdhani',
                    color: Colors.white,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Generic frosted Glassmorphism Container with backdrop blur and customizable borders, shadows, and neon glow.
class GlassContainer extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? glowColor;
  final double borderWidth;
  final double blurSigma;
  final List<BoxShadow>? boxShadow;
  final Clip clipBehavior;

  const GlassContainer({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.borderRadius,
    this.backgroundColor,
    this.borderColor,
    this.glowColor,
    this.borderWidth = 1.0,
    this.blurSigma = 14.0,
    this.boxShadow,
    this.clipBehavior = Clip.antiAlias,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBorderRadius = borderRadius ?? BorderRadius.circular(16.0);
    final effectiveBgColor =
        backgroundColor ?? const Color(0xFF151C24).withValues(alpha: 0.82);
    final effectiveBorderColor =
        borderColor ??
        (glowColor != null
            ? glowColor!.withValues(alpha: 0.45)
            : const Color(0xFF00E5FF).withValues(alpha: 0.32));
    final effectiveBoxShadow =
        boxShadow ??
        (glowColor != null
            ? [
                BoxShadow(
                  color: glowColor!.withValues(alpha: 0.22),
                  blurRadius: 18,
                  spreadRadius: 1,
                  offset: const Offset(0, 4),
                ),
              ]
            : [
                BoxShadow(
                  color: const Color(0xFF00E5FF).withValues(alpha: 0.12),
                  blurRadius: 16,
                  spreadRadius: 1,
                  offset: const Offset(0, 4),
                ),
              ]);

    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: effectiveBorderRadius,
        boxShadow: effectiveBoxShadow,
      ),
      child: ClipRRect(
        borderRadius: effectiveBorderRadius,
        clipBehavior: clipBehavior,
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: blurSigma,
            sigmaY: blurSigma,
          ),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              color: effectiveBgColor,
              borderRadius: effectiveBorderRadius,
              border: Border.all(
                color: effectiveBorderColor,
                width: borderWidth,
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

/// Tactile animated button that smoothly scales down on tap for enhanced haptic feedback feel.
class TactileScaleButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double pressedScale;
  final Duration duration;

  const TactileScaleButton({
    super.key,
    required this.child,
    required this.onTap,
    this.pressedScale = 0.96,
    this.duration = const Duration(milliseconds: 110),
  });

  @override
  State<TactileScaleButton> createState() => _TactileScaleButtonState();
}

class _TactileScaleButtonState extends State<TactileScaleButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: widget.onTap == null
          ? null
          : (_) => setState(() => _isPressed = true),
      onTapUp: widget.onTap == null
          ? null
          : (_) {
              setState(() => _isPressed = false);
              widget.onTap?.call();
            },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? widget.pressedScale : 1.0,
        duration: widget.duration,
        curve: Curves.easeOutCubic,
        child: widget.child,
      ),
    );
  }
}

/// Animated pulse / sonar ripple marker that continuously emits glowing concentric rings
/// around tactical map markers (incidents, user GPS, responder beacons).
class AnimatedPulseMarker extends StatefulWidget {
  final Widget child;
  final Color pulseColor;
  final double pulseRadius;
  final int ringCount;
  final bool isPulsing;
  final Duration duration;

  const AnimatedPulseMarker({
    super.key,
    required this.child,
    this.pulseColor = const Color(0xFF00E5FF),
    this.pulseRadius = 32.0,
    this.ringCount = 2,
    this.isPulsing = true,
    this.duration = const Duration(milliseconds: 2200),
  });

  @override
  State<AnimatedPulseMarker> createState() => _AnimatedPulseMarkerState();
}

class _AnimatedPulseMarkerState extends State<AnimatedPulseMarker>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    if (widget.isPulsing) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(covariant AnimatedPulseMarker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPulsing != oldWidget.isPulsing) {
      if (widget.isPulsing) {
        _controller.repeat();
      } else {
        _controller.stop();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isPulsing) {
      return widget.child;
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: _SonarPulsePainter(
            animationValue: _controller.value,
            pulseColor: widget.pulseColor,
            maxRadius: widget.pulseRadius,
            ringCount: widget.ringCount,
          ),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

class _SonarPulsePainter extends CustomPainter {
  final double animationValue;
  final Color pulseColor;
  final double maxRadius;
  final int ringCount;

  _SonarPulsePainter({
    required this.animationValue,
    required this.pulseColor,
    required this.maxRadius,
    required this.ringCount,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final minRadius = math.max(size.width, size.height) / 2;
    final totalExpansion = maxRadius - minRadius;
    if (totalExpansion <= 0) return;

    for (int i = 0; i < ringCount; i++) {
      final ringProgress = (animationValue + (i / ringCount)) % 1.0;
      final currentRadius = minRadius + (totalExpansion * ringProgress);
      final opacity = (1.0 - ringProgress).clamp(0.0, 1.0);
      final alpha = (opacity * 0.70).clamp(0.0, 1.0);

      // Glowing outer radar ring stroke
      final strokePaint = Paint()
        ..color = pulseColor.withValues(alpha: alpha)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.6 * (1.0 - ringProgress * 0.4);

      canvas.drawCircle(center, currentRadius, strokePaint);

      // Subtle translucent sonar fill
      if (alpha > 0.05) {
        final fillPaint = Paint()
          ..color = pulseColor.withValues(alpha: alpha * 0.12)
          ..style = PaintingStyle.fill;
        canvas.drawCircle(center, currentRadius, fillPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _SonarPulsePainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
        oldDelegate.pulseColor != pulseColor ||
        oldDelegate.maxRadius != maxRadius;
  }
}
