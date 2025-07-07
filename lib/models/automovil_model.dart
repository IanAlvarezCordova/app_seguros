// File: /lib/models/automovil_model.dart
class Automovil {
  final int id;
  final String modelo;
  final double valor;
  final int accidentes;
  final int propietarioId;
  final String propietarioNombre;
  final double costoSeguro;

  Automovil({
    required this.id,
    required this.modelo,
    required this.valor,
    required this.accidentes,
    required this.propietarioId,
    required this.propietarioNombre,
    required this.costoSeguro,
  });

  factory Automovil.fromJson(Map<String, dynamic> json) {
    return Automovil(
      id: json['id'] ?? 0,
      modelo: json['modelo'] ?? '',
      valor: (json['valor'] ?? 0.0).toDouble(),
      accidentes: json['accidentes'] ?? 0,
      propietarioId: json['propietarioId'] ?? 0,
      propietarioNombre: json['propietarioNombre'] ?? '',
      costoSeguro: (json['costoSeguro'] ?? 0.0).toDouble(),
    );
  }
}