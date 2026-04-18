import 'package:flutter/material.dart';
import 'package:serenti/app/view/theme/serenti_colors.dart';
import 'package:serenti/app/view/crisis/crisis_page.dart';

class CrisisActionButton extends StatelessWidget {
  const CrisisActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: SerentiColors.alertGradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: SerentiColors.alertGradient.last.withOpacity(0.4),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(CrisisPage.route()),
        backgroundColor: Colors.transparent,
        elevation: 0,
        highlightElevation: 0,
        child: const Icon(
          Icons.anchor,
          color: Colors.white,
          size: 32,
        ),
      ),
    );
  }
}
