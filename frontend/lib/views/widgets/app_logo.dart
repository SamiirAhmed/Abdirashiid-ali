import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  final double size;
  
  const AppLogo({super.key, this.size = 100});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.blue.shade700,
                const Color(0xFF2ECC71), // Emerald green replacement
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(size * 0.25),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Center(
            child: Icon(
              Icons.task_alt,
              size: size * 0.6,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 12),
        ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: [
              Colors.blue.shade800,
              const Color(0xFF27AE60),
            ],
          ).createShader(bounds),
          child: Text(
            'Rashka',
            style: TextStyle(
              fontSize: size * 0.3,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
              color: Colors.white, // Required for ShaderMask to work
            ),
          ),
        ),
      ],
    );
  }
}
