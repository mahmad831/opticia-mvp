import 'package:flutter/material.dart';

class GazeCursor extends StatelessWidget {
  final Offset pos; final bool clicking;
  const GazeCursor({super.key, required this.pos, this.clicking=false});
  @override
  Widget build(BuildContext context){
    return Positioned(
      left: pos.dx, top: pos.dy,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 80),
        width: clicking?22:16, height: clicking?22:16,
        decoration: BoxDecoration(
          color: Colors.greenAccent.withOpacity(0.9),
          shape: BoxShape.circle,
          boxShadow: const [BoxShadow(blurRadius: 8)]
        ),
      ),
    );
  }
}
