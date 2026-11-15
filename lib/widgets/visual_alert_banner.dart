import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/accessibility_provider.dart';

enum AlertType { success, warning, error, info }

class VisualAlertBanner extends StatefulWidget {
  final String message;
  final AlertType type;
  final Duration duration;

  const VisualAlertBanner({
    super.key,
    required this.message,
    this.type = AlertType.info,
    this.duration = const Duration(seconds: 4),
  });

  /// Muestra el banner en la parte superior de la pantalla
  static void show(
    BuildContext context, {
    required String message,
    AlertType type = AlertType.info,
    Duration duration = const Duration(seconds: 4),
  }) {
    final accessibility = context.read<AccessibilityProvider>();
    if (!accessibility.visualAlerts) return;

    final overlay = Overlay.of(context);
    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (_) => _AlertOverlay(
        message: message,
        type: type,
        duration: duration,
        onDismiss: () => entry.remove(),
      ),
    );

    overlay.insert(entry);
  }

  @override
  State<VisualAlertBanner> createState() => _VisualAlertBannerState();
}

class _VisualAlertBannerState extends State<VisualAlertBanner> {
  @override
  Widget build(BuildContext context) {
    return _buildBanner(widget.type, widget.message);
  }

  Widget _buildBanner(AlertType type, String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: _colorForType(type),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(_iconForType(type), color: Colors.white, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _colorForType(AlertType type) {
    switch (type) {
      case AlertType.success:
        return const Color(0xFF2D5016);
      case AlertType.warning:
        return const Color(0xFFE65100);
      case AlertType.error:
        return const Color(0xFFD32F2F);
      case AlertType.info:
        return const Color(0xFF1565C0);
    }
  }

  IconData _iconForType(AlertType type) {
    switch (type) {
      case AlertType.success:
        return Icons.check_circle_outline;
      case AlertType.warning:
        return Icons.warning_amber_outlined;
      case AlertType.error:
        return Icons.error_outline;
      case AlertType.info:
        return Icons.info_outline;
    }
  }
}

// Widget interno para el overlay
class _AlertOverlay extends StatefulWidget {
  final String message;
  final AlertType type;
  final Duration duration;
  final VoidCallback onDismiss;

  const _AlertOverlay({
    required this.message,
    required this.type,
    required this.duration,
    required this.onDismiss,
  });

  @override
  State<_AlertOverlay> createState() => _AlertOverlayState();
}

class _AlertOverlayState extends State<_AlertOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(_controller);

    _controller.forward();

    Future.delayed(widget.duration, () {
      if (mounted) {
        _controller.reverse().then((_) => widget.onDismiss());
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color _colorForType(AlertType type) {
    switch (type) {
      case AlertType.success:
        return const Color(0xFF2D5016);
      case AlertType.warning:
        return const Color(0xFFE65100);
      case AlertType.error:
        return const Color(0xFFD32F2F);
      case AlertType.info:
        return const Color(0xFF1565C0);
    }
  }

  IconData _iconForType(AlertType type) {
    switch (type) {
      case AlertType.success:
        return Icons.check_circle_outline;
      case AlertType.warning:
        return Icons.warning_amber_outlined;
      case AlertType.error:
        return Icons.error_outline;
      case AlertType.info:
        return Icons.info_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 12,
      left: 16,
      right: 16,
      child: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Material(
            color: Colors.transparent,
            child: GestureDetector(
              onTap: () {
                _controller.reverse().then((_) => widget.onDismiss());
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: _colorForType(widget.type),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(50),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(
                      _iconForType(widget.type),
                      color: Colors.white,
                      size: 26,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        widget.message,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const Icon(Icons.close, color: Colors.white70, size: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
