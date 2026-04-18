import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isar_database/isar_database.dart';
import 'package:serenti/app/logic/pet/pet_bloc.dart';

class PetAvatar extends StatelessWidget {
  const PetAvatar({super.key, this.size = 120});

  final double size;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PetBloc, PetState>(
      builder: (context, state) {
        IconData icon;
        Color color;
        String label;

        switch (state.currentMood) {
          case MiloMood.joy:
            icon = Icons.sentiment_very_satisfied;
            color = Colors.orangeAccent;
            label = '¡Milo está feliz!';
          case MiloMood.rest:
            icon = Icons.bedtime;
            color = Colors.indigoAccent;
            label = 'Milo está descansando';
          case MiloMood.shelter:
            icon = Icons.shield;
            color = Colors.blueGrey;
            label = 'Milo te está protegiendo';
          case MiloMood.idle:
          default:
            icon = Icons.pets;
            color = const Color(0xFF4CAF50);
            label = 'Milo está tranquilo';
        }

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return ScaleTransition(scale: animation, child: child);
              },
              child: Icon(
                icon,
                key: ValueKey(state.currentMood),
                size: size,
                color: color,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              state.name.isNotEmpty ? '${state.name}: $label' : label,
              style: TextStyle(
                fontSize: 14,
                color: color.withOpacity(0.8),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        );
      },
    );
  }
}
