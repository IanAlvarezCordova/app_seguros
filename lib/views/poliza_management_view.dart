// File: lib/views/poliza_management_view.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/poliza_viewmodel.dart';
import '../models/poliza_model.dart';
import '../models/automovil_model.dart';

class PolizaManagementView extends StatefulWidget {
  @override
  _PolizaManagementViewState createState() => _PolizaManagementViewState();
}

class _PolizaManagementViewState extends State<PolizaManagementView> {
  final _propietarioController = TextEditingController();
  final _valorController = TextEditingController();
  final _accidentesController = TextEditingController();
  final _costoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final vm = Provider.of<PolizaViewModel>(context, listen: false);
    vm.obtenerPolizas();
    vm.obtenerAutomovilesSinSeguro();
  }

  @override
  void dispose() {
    _propietarioController.dispose();
    _valorController.dispose();
    _accidentesController.dispose();
    _costoController.dispose();
    super.dispose();
  }

  void _showFormDialog(BuildContext context, PolizaViewModel vm) {
    _propietarioController.text = vm.propietario;
    _valorController.text = vm.valorSeguroAuto.toString();
    _accidentesController.text = vm.accidentes.toString();
    _costoController.text = vm.costoTotal.toString();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            vm.editingSeguroId == 0 ? "Nueva Póliza" : "Editar Póliza",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTextField(
                  controller: _propietarioController,
                  label: "Propietario (Nombre Apellido)",
                  onChanged: (val) => vm.propietario = val,
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return "El campo es requerido";
                    }
                    final words = val.trim().split(' ');
                    if (words.length != 2) {
                      return "Debe ingresar nombre y apellido";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 12),
                _buildTextField(
                  controller: _valorController,
                  label: "Valor del Auto",
                  keyboardType: TextInputType.number,
                  onChanged: (val) => vm.valorSeguroAuto = double.tryParse(val) ?? 0.0,
                ),
                SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: vm.modeloAuto,
                  decoration: InputDecoration(
                    labelText: "Modelo del Auto",
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  items: ['Hyundai', 'Tesla', 'Toyota', 'Otro']
                      .map((m) => DropdownMenuItem(value: m, child: Text(m)))
                      .toList(),
                  onChanged: (val) {
                    vm.modeloAuto = val!;
                    vm.notifyListeners();
                  },
                ),
                SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: vm.edadPropietario,
                  decoration: InputDecoration(
                    labelText: "Edad del Propietario",
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  items: ['18-23', '23-55', '55+']
                      .map((e) => DropdownMenuItem(value: e, child: Text(_textoEdad(e))))
                      .toList(),
                  onChanged: (val) {
                    vm.edadPropietario = val!;
                    vm.notifyListeners();
                  },
                ),
                SizedBox(height: 12),
                _buildTextField(
                  controller: _accidentesController,
                  label: "Número de Accidentes",
                  keyboardType: TextInputType.number,
                  onChanged: (val) => vm.accidentes = int.tryParse(val) ?? 0,
                ),
                SizedBox(height: 12),
                _buildTextField(
                  controller: _costoController,
                  label: "Costo Total (opcional)",
                  keyboardType: TextInputType.number,
                  onChanged: (val) => vm.costoTotal = double.tryParse(val) ?? 0.0,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancelar", style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                final propietario = _propietarioController.text.trim();
                final words = propietario.split(' ');
                if (words.length != 2) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("El propietario debe tener nombre y apellido"),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }
                _guardarPoliza(context, vm);
              },
              child: Text(vm.editingSeguroId == 0 ? "Crear" : "Actualizar"),
            ),
          ],
        );
      },
    );
  }

  void _guardarPoliza(BuildContext context, PolizaViewModel vm) async {
    try {
      await vm.guardarPoliza();
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(vm.editingSeguroId == 0 ? "Póliza creada" : "Póliza actualizada"),
          backgroundColor: Colors.teal,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
      );
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType? keyboardType,
    required Function(String) onChanged,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      onChanged: (val) {
        onChanged(val);
        Provider.of<PolizaViewModel>(context, listen: false).notifyListeners();
      },
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  String _textoEdad(String rango) {
    switch (rango) {
      case '18-23':
        return '18 a 23 años';
      case '23-55':
        return '23 a 55 años';
      default:
        return '55+ años';
    }
  }

  Color _getModelColor(String modelo) {
    switch (modelo) {
      case 'Hyundai':
        return Colors.blue.shade700;
      case 'Tesla':
        return Colors.black87;
      case 'Toyota':
        return Colors.green.shade700;
      default:
        return Colors.grey.shade600;
    }
  }

  Future<bool?> _showConfirmDialog(BuildContext context, String message) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text("Confirmar", style: TextStyle(color: Colors.teal)),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text("Cancelar", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () => Navigator.pop(context, true),
            child: Text("Confirmar"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<PolizaViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Gestión de Pólizas", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.teal,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              vm.obtenerPolizas();
              vm.obtenerAutomovilesSinSeguro();
            },
            tooltip: 'Refrescar',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        onPressed: () {
          vm.nuevo();
          _showFormDialog(context, vm);
        },
        child: Icon(Icons.add),
        tooltip: 'Nueva Póliza',
      ),
      body: Container(
        color: Colors.grey.shade50,
        padding: EdgeInsets.all(16),
        child: vm.polizas.isEmpty && vm.automovilesSinSeguro.isEmpty
            ? Center(child: CircularProgressIndicator(color: Colors.teal))
            : SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: DataTable(
                    columnSpacing: 16,
                    dataRowHeight: 60,
                    headingRowColor: MaterialStateProperty.all(Colors.teal.shade100),
                    columns: [
                      DataColumn(
                          label: Text('ID Seguro',
                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal))),
                      DataColumn(
                          label: Text('Propietario',
                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal))),
                      DataColumn(
                          label: Text('Modelo Auto',
                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal))),
                      DataColumn(
                          label: Text('Valor Auto',
                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal))),
                      DataColumn(
                          label: Text('Accidentes',
                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal))),
                      DataColumn(
                          label: Text('Edad',
                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal))),
                      DataColumn(
                          label: Text('Costo Seguro',
                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal))),
                      DataColumn(
                          label: Text('Acciones',
                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal))),
                    ],
                    rows: vm.polizas.map((poliza) {
                      return DataRow(
                        cells: [
                          DataCell(Text(poliza.id == 0 ? '-' : poliza.id.toString())),
                          DataCell(Text(poliza.propietario.isEmpty ? 'Sin nombre' : poliza.propietario)),
                          DataCell(Chip(
                            label: Text(poliza.modeloAuto.isEmpty ? 'Sin modelo' : poliza.modeloAuto),
                            backgroundColor: _getModelColor(poliza.modeloAuto),
                            labelStyle: TextStyle(color: Colors.white),
                          )),
                          DataCell(Text('\$${poliza.valorSeguroAuto.toStringAsFixed(2)}')),
                          DataCell(Text(poliza.accidentes.toString())),
                          DataCell(Text(poliza.edadPropietario.isEmpty ? 'Sin edad' : poliza.edadPropietario)),
                          DataCell(
                            poliza.costoTotal == 0.0
                                ? Row(
                              children: [
                                Icon(Icons.warning, color: Colors.red, size: 20),
                                SizedBox(width: 8),
                                Text('Sin seguro', style: TextStyle(color: Colors.red)),
                              ],
                            )
                                : Text('\$${poliza.costoTotal.toStringAsFixed(2)}'),
                          ),
                          DataCell(
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Tooltip(
                                  message: 'Editar Póliza',
                                  child: IconButton(
                                    icon: Icon(Icons.edit, color: Colors.teal),
                                    onPressed: () {
                                      vm.cargarPoliza(poliza);
                                      _showFormDialog(context, vm);
                                    },
                                  ),
                                ),
                                if (poliza.id != 0)
                                  Tooltip(
                                    message: 'Eliminar Seguro',
                                    child: IconButton(
                                      icon: Icon(Icons.delete, color: Colors.red),
                                      onPressed: () async {
                                        bool? confirm = await _showConfirmDialog(
                                            context, '¿Eliminar este seguro?');
                                        if (confirm == true) {
                                          try {
                                            await vm.eliminarSeguro(poliza.id);
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                content: Text("Seguro eliminado"),
                                                backgroundColor: Colors.teal,
                                              ),
                                            );
                                          } catch (e) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                content: Text("Error: $e"),
                                                backgroundColor: Colors.red,
                                              ),
                                            );
                                          }
                                        }
                                      },
                                    ),
                                  ),
                                Tooltip(
                                  message: 'Eliminar Automóvil',
                                  child: IconButton(
                                    icon: Icon(Icons.directions_car, color: Colors.blue),
                                    onPressed: () async {
                                      bool? confirm = await _showConfirmDialog(
                                          context, '¿Eliminar este automóvil?');
                                      if (confirm == true) {
                                        try {
                                          await vm.eliminarAutomovil(poliza.automovilId);
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text("Automóvil eliminado"),
                                              backgroundColor: Colors.teal,
                                            ),
                                          );
                                        } catch (e) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text("Error: $e"),
                                              backgroundColor: Colors.red,
                                            ),
                                          );
                                        }
                                      }
                                    },
                                  ),
                                ),
                                Tooltip(
                                  message: 'Eliminar Propietario',
                                  child: IconButton(
                                    icon: Icon(Icons.person_remove, color: Colors.orange),
                                    onPressed: () async {
                                      bool? confirm = await _showConfirmDialog(
                                          context, '¿Eliminar este propietario?');
                                      if (confirm == true) {
                                        try {
                                          await vm.eliminarPropietario(poliza.propietarioId);
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text("Propietario eliminado"),
                                              backgroundColor: Colors.teal,
                                            ),
                                          );
                                        } catch (e) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text("Error: $e"),
                                              backgroundColor: Colors.red,
                                            ),
                                          );
                                        }
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
              SizedBox(height: 24),
              Text(
                "Automóviles sin Seguro",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal),
              ),
              SizedBox(height: 8),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: DataTable(
                    columnSpacing: 16,
                    dataRowHeight: 60,
                    headingRowColor: MaterialStateProperty.all(Colors.teal.shade100),
                    columns: [
                      DataColumn(
                          label: Text('ID',
                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal))),
                      DataColumn(
                          label: Text('Modelo',
                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal))),
                      DataColumn(
                          label: Text('Valor',
                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal))),
                      DataColumn(
                          label: Text('Accidentes',
                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal))),
                      DataColumn(
                          label: Text('Propietario',
                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal))),
                      DataColumn(
                          label: Text('Acciones',
                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal))),
                    ],
                    rows: vm.automovilesSinSeguro.map((auto) {
                      return DataRow(
                        cells: [
                          DataCell(Text(auto.id.toString())),
                          DataCell(Chip(
                            label: Text(auto.modelo),
                            backgroundColor: _getModelColor(auto.modelo),
                            labelStyle: TextStyle(color: Colors.white),
                          )),
                          DataCell(Text('\$${auto.valor.toStringAsFixed(2)}')),
                          DataCell(Text(auto.accidentes.toString())),
                          DataCell(Text(auto.propietarioNombre)),
                          DataCell(
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.teal,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              onPressed: () async {
                                try {
                                  await vm.agregarSeguroAautomovil(auto.id);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text("Seguro agregado"),
                                      backgroundColor: Colors.teal,
                                    ),
                                  );
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text("Error: $e"),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              },
                              child: Text("Agregar Seguro"),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}