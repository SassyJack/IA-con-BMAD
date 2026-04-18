import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serenti/app/logic/settings/settings_cubit.dart';
import 'package:serenti/app/view/theme/serenti_colors.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute(builder: (_) => const SettingsPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SerentiColors.verdeMenta,
      appBar: AppBar(
        title: const Text('Configuración de Milo'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              _IntensityCard(
                intensity: state.notificationIntensity,
                onChanged: (value) {
                  context.read<SettingsCubit>().updateNotificationIntensity(value);
                },
              ),
              const SizedBox(height: 24),
              const _InfoCard(
                title: 'Privacidad Absoluta',
                description: 'Tus datos de comportamiento nunca salen de este dispositivo. Todo se procesa localmente.',
                icon: Icons.lock_outline,
              ),
            ],
          );
        },
      ),
    );
  }
}

class _IntensityCard extends StatelessWidget {
  const _IntensityCard({
    required this.intensity,
    required this.onChanged,
  });

  final double intensity;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.notifications_active_outlined, color: Colors.orange),
              SizedBox(width: 12),
              Text(
                'Intensidad de Acompañamiento',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Ajusta qué tan seguido quieres que Milo te envíe mensajes de apoyo.',
            style: TextStyle(color: Colors.black54),
          ),
          const SizedBox(height: 24),
          Slider(
            value: intensity,
            min: 0.0,
            max: 2.0,
            divisions: 4,
            activeColor: Colors.orange,
            inactiveColor: Colors.orange.withOpacity(0.2),
            onChanged: onChanged,
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Sutil', style: TextStyle(fontSize: 12, color: Colors.grey)),
              Text('Equilibrado', style: TextStyle(fontSize: 12, color: Colors.grey)),
              Text('Frecuente', style: TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.title,
    required this.description,
    required this.icon,
  });

  final String title;
  final String description;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: SerentiColors.azulCielo.withOpacity(0.5),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
