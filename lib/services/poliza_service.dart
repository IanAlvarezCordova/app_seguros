//File: lib/services/poliza_service.dart
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/poliza_model.dart';
import '../models/automovil_model.dart';

class PolizaService {
  final String baseUrl = 'https://bdd-dto-seguros.onrender.com/api'; // Ajusta según tu backend

  Future<Poliza> crearPoliza(Poliza poliza) async {
    // Validaciones
    final words = poliza.propietario.trim().split(' ');
    if (words.length != 2) {
      throw Exception('El propietario debe tener nombre y apellido');
    }
    if (poliza.valorSeguroAuto <= 0) {
      throw Exception('El valor del auto debe ser mayor que 0');
    }
    if (poliza.accidentes < 0) {
      throw Exception('El número de accidentes no puede ser negativo');
    }
    if (poliza.costoTotal < 0) {
      throw Exception('El costo total no puede ser negativo');
    }
    if (![
      'Hyundai',
      'Tesla',
      'Toyota',
      'Ford',
      'Chevrolet',
      'BMW',
      'Mercedes',
      'Kia',
      'Nissan',
      'Volkswagen',
      'Audi',
      'Honda',
      'Otro'
    ].contains(poliza.modeloAuto)) {
      throw Exception('Modelo de auto no válido');
    }

    // 1. Crear Propietario
    final propietarioData = {
      "nombreCompleto": poliza.propietario,
      "edad": _parseEdad(poliza.edadPropietario),
      "automovilIds": []
    };
    final propietarioResponse = await http.post(
      Uri.parse('$baseUrl/propietarios'),
      headers: {"Content-Type": "application/json"},
      body: json.encode(propietarioData),
    );
    if (propietarioResponse.statusCode != 200) {
      throw Exception('Error al crear propietario: ${propietarioResponse.body}');
    }
    final propietario = json.decode(propietarioResponse.body);
    final propietarioId = propietario['id'];

    // 2. Crear Automovil
    final automovilData = {
      "modelo": poliza.modeloAuto,
      "valor": poliza.valorSeguroAuto,
      "accidentes": poliza.accidentes,
      "propietarioId": propietarioId
    };
    final automovilResponse = await http.post(
      Uri.parse('$baseUrl/automoviles'),
      headers: {"Content-Type": "application/json"},
      body: json.encode(automovilData),
    );
    if (automovilResponse.statusCode != 200) {
      throw Exception('Error al crear automovil: ${automovilResponse.body}');
    }
    final automovil = json.decode(automovilResponse.body);
    final automovilId = automovil['id'];

    // 3. Crear Seguro
    final seguroData = {
      "automovilId": automovilId,
      "costoTotal": poliza.costoTotal
    };
    final seguroResponse = await http.post(
      Uri.parse('$baseUrl/seguros'),
      headers: {"Content-Type": "application/json"},
      body: json.encode(seguroData),
    );
    if (seguroResponse.statusCode != 200) {
      throw Exception('Error al crear seguro: ${seguroResponse.body}');
    }
    final seguro = json.decode(seguroResponse.body);

    return Poliza(
      id: seguro['id'],
      propietario: poliza.propietario,
      valorSeguroAuto: poliza.valorSeguroAuto,
      modeloAuto: poliza.modeloAuto,
      edadPropietario: poliza.edadPropietario,
      accidentes: poliza.accidentes,
      costoTotal: seguro['costoTotal'].toDouble(),
      propietarioId: propietarioId,
      automovilId: automovilId,
    );
  }

  Future<Poliza> actualizarPoliza(int seguroId, Poliza poliza) async {
    // Validaciones
    final words = poliza.propietario.trim().split(' ');
    if (words.length != 2) {
      throw Exception('El propietario debe tener nombre y apellido');
    }
    if (poliza.valorSeguroAuto <= 0) {
      throw Exception('El valor del auto debe ser mayor que 0');
    }
    if (poliza.accidentes < 0) {
      throw Exception('El número de accidentes no puede ser negativo');
    }
    if (poliza.costoTotal < 0) {
      throw Exception('El costo total no puede ser negativo');
    }
    if (![
      'Hyundai',
      'Tesla',
      'Toyota',
      'Ford',
      'Chevrolet',
      'BMW',
      'Mercedes',
      'Kia',
      'Nissan',
      'Volkswagen',
      'Audi',
      'Honda',
      'Otro'
    ].contains(poliza.modeloAuto)) {
      throw Exception('Modelo de auto no válido');
    }

    // Actualizar Automovil
    final automovilData = {
      "modelo": poliza.modeloAuto,
      "valor": poliza.valorSeguroAuto,
      "accidentes": poliza.accidentes,
      "propietarioId": poliza.propietarioId
    };
    final automovilResponse = await http.put(
      Uri.parse('$baseUrl/automoviles/${poliza.automovilId}'),
      headers: {"Content-Type": "application/json"},
      body: json.encode(automovilData),
    );
    if (automovilResponse.statusCode != 200) {
      throw Exception('Error al actualizar automovil: ${automovilResponse.body}');
    }

    // Actualizar Propietario
    final propietarioData = {
      "nombreCompleto": poliza.propietario,
      "edad": _parseEdad(poliza.edadPropietario),
      "automovilIds": [poliza.automovilId]
    };
    final propietarioResponse = await http.put(
      Uri.parse('$baseUrl/propietarios/${poliza.propietarioId}'),
      headers: {"Content-Type": "application/json"},
      body: json.encode(propietarioData),
    );
    if (propietarioResponse.statusCode != 200) {
      throw Exception('Error al actualizar propietario: ${propietarioResponse.body}');
    }

    // Actualizar Seguro
    final seguroData = {
      "automovilId": poliza.automovilId,
      "costoTotal": poliza.costoTotal
    };
    final response = await http.put(
      Uri.parse('$baseUrl/seguros/$seguroId'),
      headers: {"Content-Type": "application/json"},
      body: json.encode(seguroData),
    );
    if (response.statusCode != 200) {
      throw Exception('Error al actualizar seguro: ${response.body}');
    }
    final seguro = json.decode(response.body);

    return Poliza(
      id: seguro['id'],
      propietario: poliza.propietario,
      valorSeguroAuto: poliza.valorSeguroAuto,
      modeloAuto: poliza.modeloAuto,
      edadPropietario: poliza.edadPropietario,
      accidentes: poliza.accidentes,
      costoTotal: seguro['costoTotal'].toDouble(),
      propietarioId: poliza.propietarioId,
      automovilId: poliza.automovilId,
    );
  }

  Future<void> eliminarSeguro(int seguroId) async {
    final response = await http.delete(Uri.parse('$baseUrl/seguros/$seguroId'));
    if (response.statusCode != 200) {
      throw Exception('Error al eliminar seguro: ${response.body}');
    }
  }

  Future<void> eliminarAutomovil(int automovilId) async {
    final response = await http.delete(Uri.parse('$baseUrl/automoviles/$automovilId'));
    if (response.statusCode != 200) {
      throw Exception('Error al eliminar automovil: ${response.body}');
    }
  }

  Future<void> eliminarPropietario(int propietarioId) async {
    final response = await http.delete(Uri.parse('$baseUrl/propietarios/$propietarioId'));
    if (response.statusCode != 200) {
      throw Exception('Error al eliminar propietario: ${response.body}');
    }
  }

  Future<List<Poliza>> obtenerPolizas() async {
    final segurosResponse = await http.get(Uri.parse('$baseUrl/seguros'));
    if (segurosResponse.statusCode != 200) {
      throw Exception('Error al obtener pólizas: ${segurosResponse.body}');
    }
    final List<dynamic> segurosData = json.decode(segurosResponse.body);

    List<Poliza> polizas = [];

    for (var seguroJson in segurosData) {
      int seguroId = seguroJson['id'] ?? 0;
      double costoTotal = (seguroJson['costoTotal'] ?? 0.0).toDouble();
      int automovilId = seguroJson['automovilId'] ?? 0;

      final automovilResponse = await http.get(Uri.parse('$baseUrl/automoviles/$automovilId'));
      if (automovilResponse.statusCode != 200) {
        throw Exception('Error al obtener automóvil $automovilId: ${automovilResponse.body}');
      }
      final automovilJson = json.decode(automovilResponse.body);

      int propietarioId = automovilJson['propietarioId'] ?? 0;
      final propietarioResponse = await http.get(Uri.parse('$baseUrl/propietarios/$propietarioId'));
      if (propietarioResponse.statusCode != 200) {
        throw Exception('Error al obtener propietario $propietarioId: ${propietarioResponse.body}');
      }
      final propietarioJson = json.decode(propietarioResponse.body);

      polizas.add(Poliza(
        id: seguroId,
        propietario: propietarioJson['nombreCompleto'] ?? '',
        valorSeguroAuto: (automovilJson['valor'] ?? 0.0).toDouble(),
        modeloAuto: automovilJson['modelo'] ?? '',
        edadPropietario: _rangoEdad(propietarioJson['edad'] ?? 0),
        accidentes: automovilJson['accidentes'] ?? 0,
        costoTotal: costoTotal,
        propietarioId: propietarioId,
        automovilId: automovilId,
      ));
    }

    return polizas;
  }

  Future<List<Automovil>> obtenerAutomovilesSinSeguro() async {
    final response = await http.get(Uri.parse('$baseUrl/automoviles'));
    if (response.statusCode != 200) {
      throw Exception('Error al obtener automóviles: ${response.body}');
    }
    final List<dynamic> data = json.decode(response.body);
    final automoviles = data.map((json) => Automovil.fromJson(json)).toList();
    return automoviles.where((auto) => auto.costoSeguro == 0.0).toList();
  }

  Future<Poliza> crearSeguroParaAutomovil(int automovilId) async {
    final seguroData = {
      "automovilId": automovilId,
    };
    final seguroResponse = await http.post(
      Uri.parse('$baseUrl/seguros'),
      headers: {"Content-Type": "application/json"},
      body: json.encode(seguroData),
    );
    if (seguroResponse.statusCode != 200) {
      throw Exception('Error al crear seguro: ${seguroResponse.body}');
    }
    final seguroJson = json.decode(seguroResponse.body);

    final automovilResponse = await http.get(Uri.parse('$baseUrl/automoviles/$automovilId'));
    if (automovilResponse.statusCode != 200) {
      throw Exception('Error al obtener automóvil: ${automovilResponse.body}');
    }
    final automovilJson = json.decode(automovilResponse.body);

    final propietarioResponse = await http.get(Uri.parse('$baseUrl/propietarios/${automovilJson['propietarioId']}'));
    if (propietarioResponse.statusCode != 200) {
      throw Exception('Error al obtener propietario: ${propietarioResponse.body}');
    }
    final propietarioJson = json.decode(propietarioResponse.body);

    return Poliza(
      id: seguroJson['id'],
      propietario: propietarioJson['nombreCompleto'],
      valorSeguroAuto: automovilJson['valor'].toDouble(),
      modeloAuto: automovilJson['modelo'],
      edadPropietario: _rangoEdad(propietarioJson['edad']),
      accidentes: automovilJson['accidentes'],
      costoTotal: seguroJson['costoTotal'].toDouble(),
      propietarioId: automovilJson['propietarioId'],
      automovilId: automovilId,
    );
  }

  int _parseEdad(String rango) {
    if (rango == '18-23') return 20;
    if (rango == '23-55') return 40;
    return 60;
  }

  String _rangoEdad(int edad) {
    if (edad < 23) return '18-23';
    if (edad < 55) return '23-55';
    return '55+';
  }
}