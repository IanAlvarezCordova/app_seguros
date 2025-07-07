// File: /lib/viewmodels/poliza_viewmodel.dart
import 'package:flutter/material.dart';
import '../models/automovil_model.dart';
import '../models/poliza_model.dart';
import '../services/poliza_service.dart';

class PolizaViewModel extends ChangeNotifier {
  String propietario = '';
  double valorSeguroAuto = 0.0;
  String modeloAuto = 'Hyundai';
  String edadPropietario = '18-23';
  int accidentes = 0;
  double costoTotal = 0.0;
  List<Poliza> polizas = [];
  int editingSeguroId = 0;
  int editingPropietarioId = 0;
  int editingAutomovilId = 0;

  final PolizaService _service = PolizaService();

  void nuevo() {
    propietario = '';
    valorSeguroAuto = 0.0;
    modeloAuto = 'Hyundai';
    edadPropietario = '18-23';
    accidentes = 0;
    costoTotal = 0.0;
    editingSeguroId = 0;
    editingPropietarioId = 0;
    editingAutomovilId = 0;
    notifyListeners();
  }

  void cargarPoliza(Poliza poliza) {
    propietario = poliza.propietario;
    valorSeguroAuto = poliza.valorSeguroAuto;
    // Validar modeloAuto
    modeloAuto = ['Hyundai', 'Tesla', 'Toyota', 'Otro'].contains(poliza.modeloAuto)
        ? poliza.modeloAuto
        : 'Hyundai';
    // Validar edadPropietario
    edadPropietario = ['18-23', '23-55', '55+'].contains(poliza.edadPropietario)
        ? poliza.edadPropietario
        : '18-23';
    accidentes = poliza.accidentes;
    costoTotal = poliza.costoTotal;
    editingSeguroId = poliza.id;
    editingPropietarioId = poliza.propietarioId;
    editingAutomovilId = poliza.automovilId;
    notifyListeners();
  }

  Future<void> guardarPoliza() async {
    final poliza = Poliza(
      id: editingSeguroId,
      propietario: propietario,
      valorSeguroAuto: valorSeguroAuto,
      modeloAuto: modeloAuto,
      edadPropietario: edadPropietario,
      accidentes: accidentes,
      costoTotal: costoTotal,
      propietarioId: editingPropietarioId,
      automovilId: editingAutomovilId,
    );

    try {
      if (editingSeguroId == 0) {
        final polizaCreada = await _service.crearPoliza(poliza);
        polizas.add(polizaCreada);
      } else {
        final polizaActualizada = await _service.actualizarPoliza(editingSeguroId, poliza);
        final index = polizas.indexWhere((p) => p.id == editingSeguroId);
        if (index != -1) {
          polizas[index] = polizaActualizada;
        } else {
          polizas.add(polizaActualizada);
        }
      }
      costoTotal = poliza.costoTotal;
      notifyListeners();
    } catch (e) {
      print('Error: $e');
      throw e;
    }
  }

  Future<void> eliminarSeguro(int seguroId) async {
    try {
      await _service.eliminarSeguro(seguroId);
      polizas.removeWhere((p) => p.id == seguroId);
      notifyListeners();
    } catch (e) {
      print('Error: $e');
      throw e;
    }
  }

  Future<void> eliminarAutomovil(int automovilId) async {
    try {
      await _service.eliminarAutomovil(automovilId);
      polizas.removeWhere((p) => p.automovilId == automovilId);
      notifyListeners();
    } catch (e) {
      print('Error: $e');
      throw e;
    }
  }

  Future<void> eliminarPropietario(int propietarioId) async {
    try {
      await _service.eliminarPropietario(propietarioId);
      polizas.removeWhere((p) => p.propietarioId == propietarioId);
      notifyListeners();
    } catch (e) {
      print('Error: $e');
      throw e;
    }
  }

  Future<void> obtenerPolizas() async {
    try {
      polizas = await _service.obtenerPolizas();
      notifyListeners();
    } catch (e) {
      print('Error: $e');
      throw e;
    }
  }
  List<Automovil> automovilesSinSeguro = [];

  Future<void> obtenerAutomovilesSinSeguro() async {
    try {
      automovilesSinSeguro = await _service.obtenerAutomovilesSinSeguro();
      notifyListeners();
    } catch (e) {
      print('Error: $e');
      throw e;
    }
  }

  Future<void> agregarSeguroAautomovil(int automovilId) async {
    try {
      final poliza = await _service.crearSeguroParaAutomovil(automovilId);
      polizas.add(poliza);
      automovilesSinSeguro.removeWhere((auto) => auto.id == automovilId);
      notifyListeners();
    } catch (e) {
      print('Error: $e');
      throw e;
    }
  }


}