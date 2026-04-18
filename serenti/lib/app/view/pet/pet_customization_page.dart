import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isar_database/isar_database.dart';
import 'package:serenti/app/logic/onboarding/onboarding_bloc.dart';
import 'package:serenti/app/logic/pet/pet_bloc.dart';
import 'package:serenti/l10n/l10n.dart';

class PetCustomizationPage extends StatelessWidget {
  const PetCustomizationPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const PetCustomizationPage());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PetBloc, PetState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == PetStatus.success) {
          // Notify OnboardingBloc that this step is complete
          context.read<OnboardingBloc>().add(const OnboardingCompleteStep('personalization'));
        } else if (state.status == PetStatus.failure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text(state.errorMessage ?? 'Error al guardar')),
            );
        }
      },
      child: const PetCustomizationView(),
    );
  }
}

class PetCustomizationView extends StatefulWidget {
  const PetCustomizationView({super.key});

  @override
  State<PetCustomizationView> createState() => _PetCustomizationViewState();
}

class _PetCustomizationViewState extends State<PetCustomizationView> {
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: context.read<PetBloc>().state.name);
    _nameController.addListener(() {
      context.read<PetBloc>().add(PetNameChanged(_nameController.text));
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // Off-white/Crema background
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              Text(
                context.l10n.petCustomizationTitle,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF2D3142),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                context.l10n.petCustomizationSubtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, color: Color(0xFF4F5D75)),
              ),
              const Spacer(),
              _PetNameInput(controller: _nameController),
              const SizedBox(height: 24),
              const _PetGenderSelection(),
              const Spacer(),
              _SubmitButton(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _PetNameInput extends StatelessWidget {
  const _PetNameInput({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PetBloc, PetState>(
      buildWhen: (previous, current) => previous.name != current.name,
      builder: (context, state) {
        return TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: context.l10n.petNameLabel,
            errorText: state.name.isNotEmpty && !state.isNameValid
                ? context.l10n.petNameError
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
        );
      },
    );
  }
}

class _PetGenderSelection extends StatelessWidget {
  const _PetGenderSelection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.petGenderLabel,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 12),
        BlocBuilder<PetBloc, PetState>(
          buildWhen: (previous, current) => previous.gender != current.gender,
          builder: (context, state) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _GenderChip(
                  label: context.l10n.petGenderMale,
                  gender: PetGender.male,
                  isSelected: state.gender == PetGender.male,
                ),
                _GenderChip(
                  label: context.l10n.petGenderFemale,
                  gender: PetGender.female,
                  isSelected: state.gender == PetGender.female,
                ),
                _GenderChip(
                  label: context.l10n.petGenderNeutral,
                  gender: PetGender.neutral,
                  isSelected: state.gender == PetGender.neutral,
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _GenderChip extends StatelessWidget {
  const _GenderChip({
    required this.label,
    required this.gender,
    required this.isSelected,
  });

  final String label;
  final PetGender gender;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          context.read<PetBloc>().add(PetGenderChanged(gender));
        }
      },
      selectedColor: const Color(0xFFA2D2FF), // Azul Serenti
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
    );
  }
}

class _SubmitButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PetBloc, PetState>(
      buildWhen: (previous, current) => 
        previous.status != current.status || 
        previous.isFormValid != current.isFormValid,
      builder: (context, state) {
        return ElevatedButton(
          onPressed: state.isFormValid && state.status != PetStatus.loading
              ? () => context.read<PetBloc>().add(const PetProfileSubmitted())
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFA2D2FF), // Azul Serenti
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
          ),
          child: state.status == PetStatus.loading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : Text(context.l10n.petCustomizationSubmit),
        );
      },
    );
  }
}
