//File: /lib/viewmodels/poliza_viewmodel.dart
import 'package:flutter/foundation.dart';
import '../services/poliza_service.dart';
import '../models/poliza_model.dart';
import '../models/automovil_model.dart';
import '../models/propietario_model.dart';

class PolizaViewModel extends ChangeNotifier {
  final PolizaService _service = PolizaService();
  List<Poliza> polizas = [];
  List<Automovil> automovilesSinSeguro = [];
  List<Propietario> propietariosSinAutomoviles = [];
  int editingSeguroId = 0;
  String propietario = '';
  double valorSeguroAuto = 0.0;
  String modeloAuto = 'Hyundai';
  String edadPropietario = '18-23';
  int accidentes = 0;
  double costoTotal = 0.0;
  int propietarioId = 0;
  int automovilId = 0;

  Future<void> obtenerPolizas() async {
    try {
      polizas = await _service.obtenerPolizas();
      notifyListeners();
    } catch (e) {
      print('Error al obtener pólizas: $e');
      throw e;
    }
  }

  Future<void> obtenerAutomovilesSinSeguro() async {
    try {
      automovilesSinSeguro = await _service.obtenerAutomovilesSinSeguro();
      notifyListeners();
    } catch (e) {
      print('Error al obtener automóviles sin seguro: $e');
      throw e;
    }
  }

  Future<void> obtenerPropietariosSinAutomoviles() async {
    try {
      propietariosSinAutomoviles = await _service.obtenerPropietariosSinAutomoviles();
      notifyListeners();
    } catch (e) {
      print('Error al obtener propietarios sin automóviles: $e');
      throw e;
    }
  }

  Future<void> guardarPoliza() async {
    try {
      final poliza = Poliza(
        id: editingSeguroId,
        propietario: propietario,
        valorSeguroAuto: valorSeguroAuto,
        modeloAuto: modeloAuto,
        edadPropietario: edadPropietario,
        accidentes: accidentes,
        costoTotal: costoTotal,
        propietarioId: propietarioId,
        automovilId: automovilId,
      );
      if (editingSeguroId == 0) {
        final nuevaPoliza = await _service.crearPoliza(poliza);
        polizas.add(nuevaPoliza);
      } else {
        final polizaActualizada = await _service.actualizarPoliza(editingSeguroId, poliza);
        final index = polizas.indexWhere((p) => p.id == editingSeguroId);
        if (index != -1) {
          polizas[index] = polizaActualizada;
        }
      }
      notifyListeners();
    } catch (e) {
      print('Error al guardar póliza: $e');
      throw e;
    }
  }

  Future<void> eliminarSeguro(int seguroId) async {
    try {
      await _service.eliminarSeguro(seguroId);
      polizas.removeWhere((p) => p.id == seguroId);
      await obtenerAutomovilesSinSeguro(); // Actualizar lista de autos sin seguro
      notifyListeners();
    } catch (e) {
      print('Error al eliminar seguro: $e');
      throw e;
    }
  }

  Future<void> eliminarAutomovil(int automovilId) async {
    try {
      await _service.eliminarAutomovil(automovilId);
      polizas.removeWhere((p) => p.automovilId == automovilId);
      await obtenerAutomovilesSinSeguro();
      await obtenerPropietariosSinAutomoviles(); // Actualizar propietarios sin autos
      notifyListeners();
    } catch (e) {
      print('Error al eliminar automovil: $e');
      throw e;
    }
  }

  Future<void> eliminarPropietario(int propietarioId) async {
    try {
      await _service.eliminarPropietario(propietarioId);
      polizas.removeWhere((p) => p.propietarioId == propietarioId);
      automovilesSinSeguro.removeWhere((a) => a.propietarioId == propietarioId);
      await obtenerPropietariosSinAutomoviles();
      notifyListeners();
    } catch (e) {
      print('Error al eliminar propietario: $e');
      throw e;
    }
  }

  Future<void> agregarSeguroAautomovil(int automovilId) async {
    try {
      final nuevaPoliza = await _service.crearSeguroParaAutomovil(automovilId);
      polizas.add(nuevaPoliza);
      automovilesSinSeguro.removeWhere((a) => a.id == automovilId);
      notifyListeners();
    } catch (e) {
      print('Error al agregar seguro: $e');
      throw e;
    }
  }

  void cargarPoliza(Poliza poliza) {
    editingSeguroId = poliza.id;
    propietario = poliza.propietario;
    valorSeguroAuto = poliza.valorSeguroAuto;
    modeloAuto = poliza.modeloAuto;
    edadPropietario = poliza.edadPropietario;
    accidentes = poliza.accidentes;
    costoTotal = poliza.costoTotal;
    propietarioId = poliza.propietarioId;
    automovilId = poliza.automovilId;
    notifyListeners();
  }

  void nuevo() {
    editingSeguroId = 0;
    propietario = '';
    valorSeguroAuto = 0.0;
    modeloAuto = 'Hyundai';
    edadPropietario = '18-23';
    accidentes = 0;
    costoTotal = 0.0;
    propietarioId = 0;
    automovilId = 0;
    notifyListeners();
  }

  String get baseUrl => _service.baseUrl;

}