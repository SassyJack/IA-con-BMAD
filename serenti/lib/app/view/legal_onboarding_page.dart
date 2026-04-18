import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serenti/app/logic/legal/legal_bloc.dart';

class LegalOnboardingPage extends StatefulWidget {
  const LegalOnboardingPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute(builder: (_) => const LegalOnboardingPage());
  }

  @override
  State<LegalOnboardingPage> createState() => _LegalOnboardingPageState();
}

class _LegalOnboardingPageState extends State<LegalOnboardingPage> {
  bool _isAccepted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3F2FD), // Azul Serenti (Refugio Visual)
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              const Icon(
                Icons.security_outlined,
                size: 80,
                color: Color(0xFF1976D2),
              ),
              const SizedBox(height: 24),
              const Text(
                'Tu Privacidad es Nuestra Prioridad',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0D47A1),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: SingleChildScrollView(
                    child: Column(
                      children: const [
                        Text(
                          'Aviso de Privacidad (Ley 1581)',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Serenti protege tus datos de salud mental procesándolos 100% localmente. '
                          'Al aceptar, permites que la mascota Milo aprenda de tus metadatos cifrados.',
                        ),
                        SizedBox(height: 16),
                        Divider(),
                        SizedBox(height: 8),
                        Text(
                          'Medical Disclaimer',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.redAccent,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Esta aplicación NO es un diagnóstico médico oficial. '
                          'Si te encuentras en una emergencia, por favor contacta a las líneas de ayuda locales.',
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Checkbox(
                    value: _isAccepted,
                    onChanged: (val) => setState(() => _isAccepted = val ?? false),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const Expanded(
                    child: Text(
                      'He leído y acepto los términos y el aviso de privacidad.',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _isAccepted
                    ? () => context.read<LegalBloc>().add(AcceptConsent())
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1976D2),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: const Text(
                  'Continuar',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
