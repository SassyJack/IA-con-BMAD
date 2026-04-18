import 'package:flutter/material.dart';
import 'package:serenti/app/view/theme/serenti_colors.dart';
import 'package:url_launcher/url_launcher.dart';

class CrisisPage extends StatelessWidget {
  const CrisisPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute(
      builder: (_) => const CrisisPage(),
      settings: const RouteSettings(name: '/crisis'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Centro de Apoyo'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              SerentiColors.alertGradient.first.withOpacity(0.2),
              Colors.white,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              _HeaderSection(),
              const SizedBox(height: 32),
              _EmergencyLinesSection(),
              const SizedBox(height: 32),
              _BreathingExerciseSection(),
              const SizedBox(height: 32),
              _SelfCareTipsSection(),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeaderSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          Icons.anchor,
          size: 64,
          color: SerentiColors.alertGradient.last,
        ),
        const SizedBox(height: 16),
        Text(
          'No estás solo',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: SerentiColors.alertGradient.last,
              ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Aquí tienes herramientas para ayudarte a recuperar la calma.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.black54),
        ),
      ],
    );
  }
}

class _EmergencyLinesSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Líneas de Ayuda',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        _EmergencyButton(
          label: 'Línea de Emergencia (123)',
          phoneNumber: '123',
          icon: Icons.local_police_outlined,
          color: Colors.redAccent,
        ),
        const SizedBox(height: 12),
        _EmergencyButton(
          label: 'Línea de Vida (Salud Mental)',
          phoneNumber: '106', // Ejemplo para Bogotá, Colombia
          icon: Icons.favorite_outline,
          color: SerentiColors.alertGradient.last,
        ),
      ],
    );
  }
}

class _EmergencyButton extends StatelessWidget {
  const _EmergencyButton({
    required this.label,
    required this.phoneNumber,
    required this.icon,
    required this.color,
  });

  final String label;
  final String phoneNumber;
  final IconData icon;
  final Color color;

  Future<void> _makeCall() async {
    final url = Uri.parse('tel:$phoneNumber');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _makeCall,
        icon: Icon(icon),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}

class _BreathingExerciseSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: SerentiColors.alertGradient.first.withOpacity(0.1),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: SerentiColors.alertGradient.first),
      ),
      child: Column(
        children: [
          const Text(
            'Técnica 4-7-8',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 16),
          _BreathingAnimation(),
          const SizedBox(height: 16),
          const Text(
            'Inhala (4s), Mantén (7s), Exhala (8s)',
            style: TextStyle(color: Colors.black54),
          ),
        ],
      ),
    );
  }
}

class _BreathingAnimation extends StatefulWidget {
  @override
  State<_BreathingAnimation> createState() => _BreathingAnimationState();
}

class _BreathingAnimationState extends State<_BreathingAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: SerentiColors.alertGradient.first.withOpacity(0.5),
          boxShadow: [
            BoxShadow(
              color: SerentiColors.alertGradient.first.withOpacity(0.3),
              blurRadius: 20,
              spreadRadius: 5,
            ),
          ],
        ),
        child: const Center(
          child: Icon(Icons.air, color: Colors.white, size: 40),
        ),
      ),
    );
  }
}

class _SelfCareTipsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tips = [
      'Bebe un vaso de agua lentamente.',
      'Nombra 5 cosas que puedes ver ahora mismo.',
      'Lávate la cara con agua fría.',
      'Recuerda: esto es temporal y pasará.',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Consejos Rápidos',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ...tips.map((tip) => _TipItem(tip: tip)).toList(),
      ],
    );
  }
}

class _TipItem extends StatelessWidget {
  const _TipItem({required this.tip});
  final String tip;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(Icons.check_circle_outline,
              size: 20, color: SerentiColors.alertGradient.last),
          const SizedBox(width: 12),
          Expanded(child: Text(tip)),
        ],
      ),
    );
  }
}
