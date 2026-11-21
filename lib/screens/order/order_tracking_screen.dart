import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/accessibility_provider.dart';

class OrderTrackingScreen extends StatefulWidget {
  final String orderNumber;

  const OrderTrackingScreen({super.key, required this.orderNumber});

  @override
  State<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen> {
  // 0 = En cocina, 1 = Preparando, 2 = Listo
  int _currentStep = 0;

  final List<_TrackingStep> _steps = [
    _TrackingStep(
      label: 'En cocina',
      icon: Icons.soup_kitchen_outlined,
      description: 'Tu pedido fue recibido y está en la cocina.',
    ),
    _TrackingStep(
      label: 'Preparando',
      icon: Icons.restaurant_outlined,
      description: 'Estamos preparando tu pedido con cuidado.',
    ),
    _TrackingStep(
      label: 'Listo',
      icon: Icons.check_circle_outline,
      description: '¡Tu pedido está listo para recoger!',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final access = context.watch<AccessibilityProvider>();
    final isReady = _currentStep == 2;

    return Scaffold(
      backgroundColor: access.backgroundColor,
      appBar: AppBar(
        backgroundColor: access.primaryColor,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () =>
              Navigator.of(context).popUntil((route) => route.isFirst),
        ),
        title: Text(
          'Mi pedido',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20 * access.textScaleFactor,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Número de pedido
            _buildOrderHeader(access),

            const SizedBox(height: 28),

            // Barra de progreso
            _buildProgressBar(access),

            const SizedBox(height: 28),

            // Detalle del estado actual
            _buildCurrentStatus(access, isReady),

            const SizedBox(height: 28),

            // Pasos detallados
            _buildStepsList(access),

            const SizedBox(height: 32),

            // Botón simulación (solo para demo)
            if (!isReady) _buildSimulateButton(access),
          ],
        ),
      ),
    );
  }

  // ── Encabezado con número de pedido ──────────────────────────────────────

  Widget _buildOrderHeader(AccessibilityProvider access) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: access.primaryColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            'Mi pedido',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14 * access.textScaleFactor,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '#${widget.orderNumber}',
            style: TextStyle(
              color: Colors.white,
              fontSize: 42 * access.textScaleFactor,
              fontWeight: FontWeight.w900,
              letterSpacing: 3,
            ),
          ),
        ],
      ),
    );
  }

  // ── Barra de progreso horizontal ─────────────────────────────────────────

  Widget _buildProgressBar(AccessibilityProvider access) {
    return Row(
      children: List.generate(_steps.length * 2 - 1, (i) {
        if (i.isOdd) {
          final stepIndex = i ~/ 2;
          final isCompleted = stepIndex < _currentStep;
          return Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              height: 4,
              color: isCompleted
                  ? access.primaryColor
                  : access.highContrast
                      ? Colors.white24
                      : Colors.grey.shade300,
            ),
          );
        }

        final stepIndex = i ~/ 2;
        final isActive = stepIndex == _currentStep;
        final isCompleted = stepIndex < _currentStep;

        return Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: isCompleted || isActive
                    ? access.primaryColor
                    : access.highContrast
                        ? const Color(0xFF1A1A1A)
                        : Colors.grey.shade200,
                shape: BoxShape.circle,
                border: isActive
                    ? Border.all(
                        color: access.highContrast
                            ? Colors.white
                            : access.primaryColor,
                        width: 3,
                      )
                    : null,
                boxShadow: isActive && !access.highContrast
                    ? [
                        BoxShadow(
                          color: access.primaryColor.withAlpha(80),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        )
                      ]
                    : null,
              ),
              child: Icon(
                isCompleted ? Icons.check : _steps[stepIndex].icon,
                size: 22,
                color: isCompleted || isActive
                    ? Colors.white
                    : access.secondaryTextColor,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              _steps[stepIndex].label,
              style: TextStyle(
                fontSize: 11 * access.textScaleFactor,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.normal,
                color: isActive
                    ? access.primaryColor
                    : access.secondaryTextColor,
              ),
            ),
          ],
        );
      }),
    );
  }

  // ── Estado actual ─────────────────────────────────────────────────────────

  Widget _buildCurrentStatus(
      AccessibilityProvider access, bool isReady) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isReady
            ? (access.highContrast
                ? const Color(0xFF004D00)
                : const Color(0xFFE8F5E9))
            : access.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isReady
              ? access.primaryColor
              : access.highContrast
                  ? Colors.white24
                  : Colors.transparent,
          width: isReady ? 2 : 1,
        ),
        boxShadow: [
          if (!access.highContrast)
            BoxShadow(
              color: Colors.black.withAlpha(12),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isReady ? Icons.check_circle : Icons.access_time_outlined,
                color: access.primaryColor,
                size: 22,
              ),
              const SizedBox(width: 8),
              Text(
                _steps[_currentStep].description,
                style: TextStyle(
                  fontSize: 15 * access.textScaleFactor,
                  fontWeight: FontWeight.w600,
                  color: access.textColor,
                ),
              ),
            ],
          ),
          if (!isReady) ...[
            const SizedBox(height: 8),
            Text(
              'Tiempo estimado: ${(_steps.length - 1 - _currentStep) * 5} min',
              style: TextStyle(
                fontSize: 13 * access.textScaleFactor,
                color: access.secondaryTextColor,
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ── Lista de pasos ────────────────────────────────────────────────────────

  Widget _buildStepsList(AccessibilityProvider access) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Seguimiento',
          style: TextStyle(
            fontSize: 16 * access.textScaleFactor,
            fontWeight: FontWeight.w700,
            color: access.textColor,
          ),
        ),
        const SizedBox(height: 12),
        ...List.generate(_steps.length, (i) {
          final isCompleted = i < _currentStep;
          final isActive = i == _currentStep;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isCompleted || isActive
                        ? access.primaryColor
                        : access.highContrast
                            ? const Color(0xFF1A1A1A)
                            : Colors.grey.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isCompleted ? Icons.check : _steps[i].icon,
                    size: 20,
                    color: isCompleted || isActive
                        ? Colors.white
                        : access.secondaryTextColor,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _steps[i].label,
                        style: TextStyle(
                          fontSize: 15 * access.textScaleFactor,
                          fontWeight: isActive
                              ? FontWeight.w700
                              : FontWeight.w500,
                          color: isActive
                              ? access.textColor
                              : access.secondaryTextColor,
                        ),
                      ),
                      Text(
                        _steps[i].description,
                        style: TextStyle(
                          fontSize: 12 * access.textScaleFactor,
                          color: access.secondaryTextColor,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isCompleted)
                  Icon(Icons.check_circle,
                      color: access.primaryColor, size: 20),
                if (isActive)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: access.primaryColor.withAlpha(25),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Actual',
                      style: TextStyle(
                        fontSize: 11 * access.textScaleFactor,
                        color: access.primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
          );
        }),
      ],
    );
  }

  // ── Botón de simulación para demo ─────────────────────────────────────────

  Widget _buildSimulateButton(AccessibilityProvider access) {
    return Center(
      child: OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: access.primaryColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding:
              const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
        onPressed: () {
          setState(() {
            if (_currentStep < _steps.length - 1) _currentStep++;
          });
        },
        icon: Icon(Icons.update, color: access.primaryColor),
        label: Text(
          'Simular avance',
          style: TextStyle(
            color: access.primaryColor,
            fontSize: 14 * access.textScaleFactor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _TrackingStep {
  final String label;
  final IconData icon;
  final String description;

  const _TrackingStep({
    required this.label,
    required this.icon,
    required this.description,
  });
}
