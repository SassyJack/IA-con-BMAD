import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.system);

  Timer? _timer;

  void startAutoTheme() {
    _checkTheme();
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(minutes: 1), (_) => _checkTheme());
  }

  void _checkTheme() {
    final now = DateTime.now();
    final hour = now.hour;

    // Dark mode from 22:00 to 06:00
    if (hour >= 22 || hour < 6) {
      if (state != ThemeMode.dark) emit(ThemeMode.dark);
    } else {
      if (state != ThemeMode.light) emit(ThemeMode.light);
    }
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
