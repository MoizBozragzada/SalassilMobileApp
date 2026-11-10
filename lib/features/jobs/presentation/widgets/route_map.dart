import 'package:flutter/material.dart';

/// Static drawn map used until a real map provider is integrated.
/// Shows streets, blocks, the active route, the driver and the destination.
class RouteMap extends StatelessWidget {
  const RouteMap({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _MapPainter(),
      child: const SizedBox.expand(),
    );
  }
}

class _MapPainter extends CustomPainter {
  static const _maroon = Color(0xFF9B0A30);

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = const Color(0xFFE9EDF5),
    );

    // City blocks.
    final block = Paint()..color = const Color(0xFFDCE3F0);
    final park = Paint()..color = const Color(0xFFD6EADB);
    void rect(double l, double t, double r, double b, Paint p) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTRB(l * w, t * h, r * w, b * h),
          const Radius.circular(6),
        ),
        p,
      );
    }

    rect(0.14, 0.28, 0.58, 0.47, block);
    rect(0.14, 0.51, 0.58, 0.64, block);
    rect(0.14, 0.67, 0.58, 0.80, block);
    rect(0.65, 0.28, 0.88, 0.47, block);
    rect(0.64, 0.51, 0.88, 0.66, block);
    rect(0.90, 0.28, 1.0, 0.47, block);
    rect(0.90, 0.51, 1.0, 0.66, park);
    rect(0.64, 0.69, 1.0, 0.80, block);

    // Streets.
    final road = Paint()
      ..color = Colors.white
      ..strokeWidth = 26
      ..strokeCap = StrokeCap.butt;
    for (final x in [0.09, 0.61, 0.89]) {
      canvas.drawLine(Offset(x * w, 0), Offset(x * w, h), road);
    }
    for (final y in [0.26, 0.49, 0.66, 0.82]) {
      canvas.drawLine(Offset(0, y * h), Offset(w, y * h), road);
    }

    // Route: driver -> corner -> corner -> destination.
    final start = Offset(0.09 * w, 0.68 * h);
    final c1 = Offset(0.09 * w, 0.49 * h);
    final c2 = Offset(0.61 * w, 0.49 * h);
    final c3 = Offset(0.61 * w, 0.26 * h);
    final end = Offset(0.97 * w, 0.26 * h);
    final path = Path()
      ..moveTo(start.dx, start.dy)
      ..lineTo(c1.dx, c1.dy)
      ..lineTo(c2.dx, c2.dy)
      ..lineTo(c3.dx, c3.dy)
      ..lineTo(end.dx, end.dy);
    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 12
        ..strokeJoin = StrokeJoin.miter
        ..color = const Color(0xFF6E0721),
    );
    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 7
        ..strokeJoin = StrokeJoin.miter
        ..color = const Color(0xFFDC1F3C),
    );

    // Destination pin.
    final pin = Offset(0.985 * w, 0.26 * h);
    canvas.drawCircle(pin, 16, Paint()..color = _maroon);
    canvas.drawCircle(pin, 6, Paint()..color = Colors.white);

    // Driver location with halo.
    canvas.drawCircle(
        start, 24, Paint()..color = const Color(0xFF2F6BFF).withValues(alpha: 0.2));
    canvas.drawCircle(start, 11, Paint()..color = Colors.white);
    canvas.drawCircle(start, 8, Paint()..color = const Color(0xFF2F6BFF));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
