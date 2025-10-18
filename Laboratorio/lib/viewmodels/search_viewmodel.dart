import 'package:flutter/material.dart';
import '../models/persona.dart';
import '../services/api_service.dart';

class SearchViewModel extends ChangeNotifier {
  final ApiService _apiService;
  List<Paciente> all = [];
  List<Paciente> filtered = [];
  bool isLoading = false;

  SearchViewModel(this._apiService);

  /// Carga los pacientes desde la API protegida
  Future<void> loadPacientes() async {
    isLoading = true;
    notifyListeners();

    try {
      all = await _apiService.fetchPacientes();
      filtered = all;
    } catch (e) {
      print('Error al cargar pacientes: $e');
      all = [];
      filtered = [];
    }

    isLoading = false;
    notifyListeners();
  }

  /// Filtra pacientes localmente por nombre o apellido
  void filter(String query) {
    final lowerQuery = query.toLowerCase();
    filtered = all.where((p) {
      final nombreCompleto = '${p.nombre} ${p.apellidos}'.toLowerCase();
      return nombreCompleto.contains(lowerQuery);
    }).toList();
    notifyListeners();
  }
}
