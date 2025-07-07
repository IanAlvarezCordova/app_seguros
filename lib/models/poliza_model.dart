// File: /lib/models/poliza_model.dart
class Poliza {
  final int id;
  final String propietario;
  final double valorSeguroAuto;
  final String modeloAuto;
  final String edadPropietario;
  final int accidentes;
  final double costoTotal;
  final int propietarioId;
  final int automovilId;

  Poliza({
    this.id = 0,
    required this.propietario,
    required this.valorSeguroAuto,
    required this.modeloAuto,
    required this.edadPropietario,
    required this.accidentes,
    required this.costoTotal,
    this.propietarioId = 0,
    this.automovilId = 0,
  });

  factory Poliza.fromJson(Map<String, dynamic> json) {
    print('JSON recibido: $json'); // Depuración para inspeccionar el JSON
    return Poliza(
      id: json["id"] ?? 0,
      propietario: json["propietario"] ?? json["nombreCompleto"] ?? "",
      valorSeguroAuto: (json["valorSeguroAuto"] ?? json["valor"] ?? 0.0).toDouble(),
      modeloAuto: json["modeloAuto"] ?? json["modelo"] ?? "",
      edadPropietario: json["edadPropietario"] ?? json["edad"] ?? "",
      accidentes: json["accidentes"] ?? 0,
      costoTotal: (json["costoTotal"] ?? 0.0).toDouble(),
      propietarioId: json["propietarioId"] ?? 0,
      automovilId: json["automovilId"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "propietario": propietario,
    "valorSeguroAuto": valorSeguroAuto,
    "modeloAuto": modeloAuto,
    "edadPropietario": edadPropietario,
    "accidentes": accidentes,
    "costoTotal": costoTotal,
    "propietarioId": propietarioId,
    "automovilId": automovilId,
  };
}