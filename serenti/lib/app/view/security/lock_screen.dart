import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serenti/app/logic/security/security_bloc.dart';

class LockScreen extends StatefulWidget {
  const LockScreen({super.key});

  @override
  State<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  String _pin = '';

  @override
  void initState() {
    super.initState();
    final state = context.read<SecurityBloc>().state;
    if (state.isBiometricEnabled) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<SecurityBloc>().add(SecurityAuthenticateWithBiometrics());
      });
    }
  }

  void _onKeyPress(String value) {
    HapticFeedback.lightImpact();
    if (_pin.length < 4) {
      setState(() {
        _pin += value;
      });
    }

    if (_pin.length == 4) {
      context.read<SecurityBloc>().add(SecurityAuthenticateWithPin(_pin));
      setState(() {
        _pin = '';
      });
    }
  }

  void _onDelete() {
    HapticFeedback.lightImpact();
    if (_pin.isNotEmpty) {
      setState(() {
        _pin = _pin.substring(0, _pin.length - 1);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SecurityBloc, SecurityState>(
      listener: (context, state) {
        if (state.errorMessage.isNotEmpty) {
          HapticFeedback.vibrate();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFE3F2FD),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height -
                      MediaQuery.of(context).padding.top -
                      MediaQuery.of(context).padding.bottom -
                      48,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      const Spacer(),
                      const Icon(
                        Icons.lock_outline,
                        size: 64,
                        color: Color(0xFF1976D2),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Bienvenido de nuevo',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0D47A1),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Ingresa tu PIN para desbloquear',
                        style: TextStyle(color: Colors.black54),
                      ),
                      const SizedBox(height: 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(4, (index) {
                          final isFilled = index < _pin.length;
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 12),
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isFilled ? const Color(0xFF1976D2) : Colors.white,
                              border: Border.all(color: const Color(0xFF1976D2)),
                            ),
                          );
                        }),
                      ),
                      const Spacer(),
                      _NumericKeypad(
                        onKeyPress: _onKeyPress,
                        onDelete: _onDelete,
                        onBiometric: context.read<SecurityBloc>().state.isBiometricEnabled
                            ? () => context.read<SecurityBloc>().add(SecurityAuthenticateWithBiometrics())
                            : null,
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NumericKeypad extends StatelessWidget {
  const _NumericKeypad({
    required this.onKeyPress,
    required this.onDelete,
    this.onBiometric,
  });

  final void Function(String) onKeyPress;
  final VoidCallback onDelete;
  final VoidCallback? onBiometric;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < 3; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                for (var j = 1; j <= 3; j++)
                  _KeyButton(
                    label: '${(i * 3) + j}',
                    onPressed: () => onKeyPress('${(i * 3) + j}'),
                  ),
              ],
            ),
          ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            if (onBiometric != null)
              _KeyButton(
                icon: Icons.fingerprint,
                onPressed: onBiometric!,
              )
            else
              const SizedBox(width: 80),
            _KeyButton(
              label: '0',
              onPressed: () => onKeyPress('0'),
            ),
            _KeyButton(
              icon: Icons.backspace_outlined,
              onPressed: onDelete,
            ),
          ],
        ),
      ],
    );
  }
}

class _KeyButton extends StatelessWidget {
  const _KeyButton({
    this.label,
    this.icon,
    required this.onPressed,
  });

  final String? label;
  final IconData? icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(40),
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(40),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: label != null
              ? Text(
                  label!,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0D47A1),
                  ),
                )
              : Icon(
                  icon,
                  size: 28,
                  color: const Color(0xFF0D47A1),
                ),
        ),
      ),
    );
  }
}
