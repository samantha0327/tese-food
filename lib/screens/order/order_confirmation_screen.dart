import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/accessibility_provider.dart';
import '../../services/vibration_service.dart';
import 'order_tracking_screen.dart';

class OrderConfirmationScreen extends StatefulWidget {
  const OrderConfirmationScreen({super.key});

  @override
  State<OrderConfirmationScreen> createState() =>
      _OrderConfirmationScreenState();
}

class _OrderConfirmationScreenState extends State<OrderConfirmationScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  // Número de pedido simulado
  final String orderNumber = '015';

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _controller.forward();

    // Vibrar al confirmar pedido
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final access = context.read<AccessibilityProvider>();
      if (access.vibrationEnabled) await VibrationService.strong();
      if (!mounted) return;
      // Limpiar carrito
      context.read<CartProvider>().clear();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final access = context.watch<AccessibilityProvider>();

    return Scaffold(
      backgroundColor: access.backgroundColor,
      appBar: AppBar(
        backgroundColor: access.primaryColor,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Text(
          'Número de pedido',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20 * access.textScaleFactor,
          ),
        ),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(28),
          child: Column(
            children: [
              const SizedBox(height: 20),

              // Ícono de éxito animado
              ScaleTransition(
                scale: _scaleAnimation,
                child: Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    color: access.highContrast
                        ? const Color(0xFF004D00)
                        : const Color(0xFFE8F5E9),
                    shape: BoxShape.circle,
                    border: access.highContrast
                        ? Border.all(color: const Color(0xFF00FF00), width: 3)
                        : null,
                  ),
                  child: Icon(
                    Icons.check_circle,
                    size: 72,
                    color: access.primaryColor,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              Text(
                '¡Pedido realizado!',
                style: TextStyle(
                  fontSize: 26 * access.textScaleFactor,
                  fontWeight: FontWeight.w900,
                  color: access.textColor,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 8),

              Text(
                'Tu número de pedido es:',
                style: TextStyle(
                  fontSize: 15 * access.textScaleFactor,
                  color: access.secondaryTextColor,
                ),
              ),

              const SizedBox(height: 16),

              // Número de pedido grande
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: access.primaryColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    if (!access.highContrast)
                      BoxShadow(
                        color: access.primaryColor.withAlpha(80),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                  ],
                ),
                child: Text(
                  '#$orderNumber',
                  style: TextStyle(
                    fontSize: 48 * access.textScaleFactor,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: 4,
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Sección de estado
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: access.cardColor,
                  borderRadius: BorderRadius.circular(16),
                  border: access.highContrast
                      ? Border.all(color: Colors.white24)
                      : null,
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
                    Text(
                      'Estatus:',
                      style: TextStyle(
                        fontSize: 15 * access.textScaleFactor,
                        fontWeight: FontWeight.w700,
                        color: access.textColor,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildStatusBar(access),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Botón ver mi pedido
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: access.primaryColor,
                    minimumSize: const Size(double.infinity, 54),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (_) => OrderTrackingScreen(
                          orderNumber: orderNumber,
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.receipt_long_outlined,
                      color: Colors.white),
                  label: Text(
                    'Ver mi pedido',
                    style: TextStyle(
                      fontSize: 16 * access.textScaleFactor,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Botón volver al inicio
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 54),
                    side: BorderSide(color: access.primaryColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () {
                    // Volver a la pantalla principal
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  child: Text(
                    'Volver al inicio',
                    style: TextStyle(
                      fontSize: 16 * access.textScaleFactor,
                      fontWeight: FontWeight.w600,
                      color: access.primaryColor,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBar(AccessibilityProvider access) {
    final steps = ['En cocina', 'Preparando', 'Listo'];
    final activeStep = 0; // El pedido recién entra a cocina

    return Row(
      children: List.generate(steps.length * 2 - 1, (i) {
        if (i.isOdd) {
          // Línea conectora
          final stepIndex = i ~/ 2;
          final isCompleted = stepIndex < activeStep;
          return Expanded(
            child: Container(
              height: 3,
              color: isCompleted
                  ? access.primaryColor
                  : access.highContrast
                      ? Colors.white24
                      : Colors.grey.shade300,
            ),
          );
        }

        // Círculo de paso
        final stepIndex = i ~/ 2;
        final isActive = stepIndex == activeStep;
        final isCompleted = stepIndex < activeStep;

        return Column(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: isCompleted || isActive
                    ? access.primaryColor
                    : access.highContrast
                        ? const Color(0xFF1A1A1A)
                        : Colors.grey.shade200,
                shape: BoxShape.circle,
                border: isActive
                    ? Border.all(
                        color: access.primaryColor,
                        width: 3,
                      )
                    : null,
              ),
              child: Icon(
                isCompleted
                    ? Icons.check
                    : isActive
                        ? Icons.circle
                        : Icons.circle_outlined,
                size: 18,
                color: isCompleted || isActive
                    ? Colors.white
                    : access.secondaryTextColor,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              steps[stepIndex],
              style: TextStyle(
                fontSize: 11 * access.textScaleFactor,
                fontWeight:
                    isActive ? FontWeight.w700 : FontWeight.normal,
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
}
