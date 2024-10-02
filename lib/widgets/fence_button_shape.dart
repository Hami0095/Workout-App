import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class FenceButtonShape extends StatelessWidget {
  final Widget child;

  const FenceButtonShape({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: FenceShapePainter(),
      child: Container(
        // Adjust height and padding here
        height: 60, // Adjust height as needed
        padding: const EdgeInsets.symmetric(
            vertical: 10, horizontal: 20), // Reduce vertical padding
        alignment: Alignment.center, // Center the text
        child: child,
      ),
    );
  }
}

class FenceShapePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.orange
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, size.height)
      ..lineTo(size.width * 0.15, size.height * 0.5) // Adjust these points
      ..lineTo(size.width * 0.85, size.height * 0.5) // Adjust these points
      ..lineTo(size.width, size.height)
      ..lineTo(size.width * 0.5, size.height * 0.8)
      ..lineTo(size.width * 0.15, size.height * 0.5)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
