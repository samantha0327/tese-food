import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/accessibility_provider.dart';
import '../../services/vibration_service.dart';
import '../../widgets/visual_alert_banner.dart';

class AccessibilityScreen extends StatelessWidget {
  const AccessibilityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final access = context.watch<AccessibilityProvider>();

    return Scaffold(
      backgroundColor: access.backgroundColor,
      appBar: AppBar(
        backgroundColor: access.primaryColor,
        foregroundColor: Colors.white,
        title: Text(
          'Accesibilidad',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20 * access.textScaleFactor,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // ── Sección visual ───────────────────────────────────────────
          _SectionHeader(
            title: 'Visual',
            icon: Icons.visibility_outlined,
            access: access,
          ),
          const SizedBox(height: 12),

          // Alto contraste
          _AccessibilityTile(
            icon: Icons.contrast,
            iconColor: access.highContrast
                ? const Color(0xFF00FF00)
                : const Color(0xFF2D5016),
            title: 'Modo alto contraste',
            subtitle:
                'Aumenta el contraste de colores para facilitar la lectura',
            value: access.highContrast,
            access: access,
            onChanged: (val) async {
              await access.setHighContrast(val);
              if (access.vibrationEnabled) await VibrationService.light();
              if (context.mounted) {
                VisualAlertBanner.show(
                  context,
                  message: val
                      ? 'Modo alto contraste activado'
                      : 'Modo alto contraste desactivado',
                  type: AlertType.info,
                );
              }
            },
          ),

          const SizedBox(height: 12),

          // Tamaño de texto
          _TextSizeTile(access: access),

          const SizedBox(height: 24),

          // ── Sección notificaciones ───────────────────────────────────
          _SectionHeader(
            title: 'Notificaciones',
            icon: Icons.notifications_outlined,
            access: access,
          ),
          const SizedBox(height: 12),

          // Alertas visuales
          _AccessibilityTile(
            icon: Icons.flash_on_outlined,
            iconColor: const Color(0xFFE65100),
            title: 'Alertas visuales',
            subtitle:
                'Muestra banners en pantalla para avisos importantes del pedido',
            value: access.visualAlerts,
            access: access,
            onChanged: (val) async {
              await access.setVisualAlerts(val);
              if (access.vibrationEnabled) await VibrationService.light();
              if (context.mounted && val) {
                VisualAlertBanner.show(
                  context,
                  message: '¡Tu pedido #015 está listo! 🎉',
                  type: AlertType.success,
                );
              }
            },
          ),

          const SizedBox(height: 12),

          // Vibración
          _AccessibilityTile(
            icon: Icons.vibration,
            iconColor: const Color(0xFF1565C0),
            title: 'Vibración',
            subtitle:
                'El teléfono vibra al confirmar pedidos y recibir notificaciones',
            value: access.vibrationEnabled,
            access: access,
            onChanged: (val) async {
              await access.setVibration(val);
              if (val) await VibrationService.success();
              if (context.mounted) {
                VisualAlertBanner.show(
                  context,
                  message: val ? 'Vibración activada' : 'Vibración desactivada',
                  type: AlertType.info,
                );
              }
            },
          ),

          const SizedBox(height: 32),

          // ── Nota de inclusión ────────────────────────────────────────
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: access.highContrast
                  ? const Color(0xFF1A1A1A)
                  : const Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: access.primaryColor.withAlpha(80),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.accessibility_new,
                  color: access.primaryColor,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Diseño inclusivo',
                        style: TextStyle(
                          fontSize: 15 * access.textScaleFactor,
                          fontWeight: FontWeight.bold,
                          color: access.textColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Esta app está diseñada para ser usada por todas las personas, incluyendo aquellas con discapacidad auditiva o visual.',
                        style: TextStyle(
                          fontSize: 13 * access.textScaleFactor,
                          color: access.secondaryTextColor,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

// ── Encabezado de sección ──────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  final AccessibilityProvider access;

  const _SectionHeader({
    required this.title,
    required this.icon,
    required this.access,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: access.primaryColor),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 16 * access.textScaleFactor,
            fontWeight: FontWeight.w700,
            color: access.primaryColor,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Divider(color: access.primaryColor.withAlpha(60)),
        ),
      ],
    );
  }
}

// ── Tarjeta de opción con switch ───────────────────────────────────────────────

class _AccessibilityTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final bool value;
  final AccessibilityProvider access;
  final ValueChanged<bool> onChanged;

  const _AccessibilityTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.access,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: access.cardColor,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          if (!access.highContrast)
            BoxShadow(
              color: Colors.black.withAlpha(15),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
        ],
        border: access.highContrast
            ? Border.all(color: Colors.white30)
            : null,
      ),
      child: SwitchListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 6,
        ),
        secondary: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: iconColor.withAlpha(25),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: iconColor, size: 22),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 15 * access.textScaleFactor,
            fontWeight: FontWeight.w600,
            color: access.textColor,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 12 * access.textScaleFactor,
            color: access.secondaryTextColor,
            height: 1.4,
          ),
        ),
        value: value,
        activeThumbColor: access.primaryColor,
        activeTrackColor: access.primaryColor.withAlpha(120),
        onChanged: onChanged,
      ),
    );
  }
}

// ── Selector de tamaño de texto ────────────────────────────────────────────────

class _TextSizeTile extends StatelessWidget {
  final AccessibilityProvider access;

  const _TextSizeTile({required this.access});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: access.cardColor,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          if (!access.highContrast)
            BoxShadow(
              color: Colors.black.withAlpha(15),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
        ],
        border: access.highContrast ? Border.all(color: Colors.white30) : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFF6A1E55).withAlpha(25),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.text_fields,
                  color: Color(0xFF6A1E55),
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tamaño de texto',
                      style: TextStyle(
                        fontSize: 15 * access.textScaleFactor,
                        fontWeight: FontWeight.w600,
                        color: access.textColor,
                      ),
                    ),
                    Text(
                      'Ajusta el tamaño de los textos en toda la app',
                      style: TextStyle(
                        fontSize: 12 * access.textScaleFactor,
                        color: access.secondaryTextColor,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _TextSizeButton(
                label: 'A',
                fontSize: 13,
                option: TextSizeOption.small,
                selected: access.textSize == TextSizeOption.small,
                access: access,
              ),
              const SizedBox(width: 10),
              _TextSizeButton(
                label: 'A',
                fontSize: 17,
                option: TextSizeOption.normal,
                selected: access.textSize == TextSizeOption.normal,
                access: access,
              ),
              const SizedBox(width: 10),
              _TextSizeButton(
                label: 'A',
                fontSize: 22,
                option: TextSizeOption.large,
                selected: access.textSize == TextSizeOption.large,
                access: access,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TextSizeButton extends StatelessWidget {
  final String label;
  final double fontSize;
  final TextSizeOption option;
  final bool selected;
  final AccessibilityProvider access;

  const _TextSizeButton({
    required this.label,
    required this.fontSize,
    required this.option,
    required this.selected,
    required this.access,
  });

  @override
  Widget build(BuildContext context) {
    final labels = {
      TextSizeOption.small: 'Pequeño',
      TextSizeOption.normal: 'Normal',
      TextSizeOption.large: 'Grande',
    };

    return Expanded(
      child: GestureDetector(
        onTap: () async {
          await access.setTextSize(option);
          if (access.vibrationEnabled) await VibrationService.light();
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: selected
                ? access.primaryColor
                : access.primaryColor.withAlpha(20),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: selected
                  ? access.primaryColor
                  : access.primaryColor.withAlpha(60),
              width: selected ? 2 : 1,
            ),
          ),
          child: Column(
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                  color: selected ? Colors.white : access.primaryColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                labels[option]!,
                style: TextStyle(
                  fontSize: 10,
                  color: selected
                      ? Colors.white70
                      : access.secondaryTextColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
