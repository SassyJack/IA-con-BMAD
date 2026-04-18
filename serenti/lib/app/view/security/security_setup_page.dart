import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serenti/app/logic/security/security_bloc.dart';

class SecuritySetupPage extends StatefulWidget {
  const SecuritySetupPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute(builder: (_) => const SecuritySetupPage());
  }

  @override
  State<SecuritySetupPage> createState() => _SecuritySetupPageState();
}

class _SecuritySetupPageState extends State<SecuritySetupPage> {
  String _pin = '';
  String _confirmPin = '';
  bool _isConfirming = false;
  String _error = '';

  void _onKeyPress(String value) {
    HapticFeedback.lightImpact();
    setState(() {
      _error = '';
      if (_isConfirming) {
        if (_confirmPin.length < 4) _confirmPin += value;
      } else {
        if (_pin.length < 4) _pin += value;
      }
    });

    if (!_isConfirming && _pin.length == 4) {
      Future.delayed(const Duration(milliseconds: 300), () {
        setState(() {
          _isConfirming = true;
        });
      });
    } else if (_isConfirming && _confirmPin.length == 4) {
      if (_pin == _confirmPin) {
        context.read<SecurityBloc>().add(SecuritySetPin(_pin));
      } else {
        HapticFeedback.vibrate();
        setState(() {
          _confirmPin = '';
          _error = 'Los PIN no coinciden. Inténtalo de nuevo.';
        });
      }
    }
  }

  void _onDelete() {
    HapticFeedback.lightImpact();
    setState(() {
      if (_isConfirming) {
        if (_confirmPin.isNotEmpty) {
          _confirmPin = _confirmPin.substring(0, _confirmPin.length - 1);
        } else {
          _isConfirming = false;
          _pin = _pin.substring(0, _pin.length - 1);
        }
      } else {
        if (_pin.isNotEmpty) {
          _pin = _pin.substring(0, _pin.length - 1);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final title = _isConfirming ? 'Confirma tu PIN' : 'Crea tu PIN de Seguridad';
    final currentPin = _isConfirming ? _confirmPin : _pin;

    return BlocListener<SecurityBloc, SecurityState>(
      listener: (context, state) {
        if (state.status == SecurityStatus.authenticated) {
          // Navigation logic will be handled by AppView
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFE3F2FD),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const SizedBox(height: 40),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0D47A1),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'El PIN protege tus datos de salud mental.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black54),
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(4, (index) {
                    final isFilled = index < currentPin.length;
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
                if (_error.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  Text(
                    _error,
                    style: const TextStyle(color: Colors.redAccent),
                  ),
                ],
                const Spacer(),
                _NumericKeypad(
                  onKeyPress: _onKeyPress,
                  onDelete: _onDelete,
                ),
                const SizedBox(height: 24),
              ],
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
  });

  final void Function(String) onKeyPress;
  final VoidCallback onDelete;

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
