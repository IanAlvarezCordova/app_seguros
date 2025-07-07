/*

//File: /lib/views/poliza_view.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seguros_front/views/poliza_list_view.dart';
import '../viewmodels/poliza_viewmodel.dart';

class PolizaView extends StatefulWidget {
  final Future<void> Function()? onSave; // Updated type to Future<void>

  PolizaView({this.onSave});

  @override
  _PolizaViewState createState() => _PolizaViewState();
}

class _PolizaViewState extends State<PolizaView> {
  final _valorController = TextEditingController();
  final _accidentesController = TextEditingController();
  final _propietarioController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final vm = Provider.of<PolizaViewModel>(context, listen: false);
    _valorController.text = vm.valorSeguroAuto.toString();
    _accidentesController.text = vm.accidentes.toString();
    _propietarioController.text = vm.propietario;

    _valorController.addListener(() {
      vm.valorSeguroAuto = double.tryParse(_valorController.text) ?? 0.0;
    });
    _accidentesController.addListener(() {
      vm.accidentes = int.tryParse(_accidentesController.text) ?? 0;
    });
    _propietarioController.addListener(() {
      vm.propietario = _propietarioController.text;
    });
  }

  @override
  void dispose() {
    _valorController.dispose();
    _accidentesController.dispose();
    _propietarioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<PolizaViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Crear/Editar Póliza", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: Icon(Icons.list),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PolizaListView()),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ""),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            _buildInput("Propietario", _propietarioController),
            SizedBox(height: 12),
            _buildInput("Valor del Seguro", _valorController, keyboard: TextInputType.number),
            SizedBox(height: 12),
            Text("Modelo de auto:", style: Theme.of(context).textTheme.titleMedium),
            for (var m in ['Tesla', 'Toyota', 'Hyundai'])
              _buildRadio("Modelo $m", m, vm.modeloAuto, (val) {
                vm.modeloAuto = val!;
                vm.notifyListeners();
              }),
            SizedBox(height: 12),
            Text("Edad propietario:", style: Theme.of(context).textTheme.titleMedium),
            for (var e in ['18-23', '23-55', '55+'])
              _buildRadio(_textoEdad(e), e, vm.edadPropietario, (val) {
                vm.edadPropietario = val!;
                vm.notifyListeners();
              }),
            SizedBox(height: 12),
            _buildInput("Número de accidentes", _accidentesController, keyboard: TextInputType.number),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: StadiumBorder(),
                  padding: EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: Colors.teal,
                ),
                onPressed: () async {
                  try {
                    if (widget.onSave != null) {
                      await widget.onSave!();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Póliza actualizada con éxito")),
                      );
                    } else {
                      await vm.calcularPoliza();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Póliza creada con éxito")),
                      );
                    }
                    Navigator.pop(context);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Error: $e")),
                    );
                  }
                },
                child: Text(
                  widget.onSave != null ? "ACTUALIZAR PÓLIZA" : "CREAR PÓLIZA",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Costo total: ${vm.costoTotal.toStringAsFixed(2)}",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.teal),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInput(String label, TextEditingController controller, {TextInputType? keyboard}) {
    return TextField(
      controller: controller,
      keyboardType: keyboard,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      ),
    );
  }

  Widget _buildRadio(String label, String value, String groupValue, Function(String?) onChanged) {
    return RadioListTile(
      title: Text(label),
      value: value,
      groupValue: groupValue,
      onChanged: onChanged,
      activeColor: Colors.teal,
    );
  }

  String _textoEdad(String rango) {
    switch (rango) {
      case '18-23':
        return 'Mayor igual a 18 y menor a 23';
      case '23-55':
        return 'Mayor igual a 23 y menor a 55';
      default:
        return 'Mayor igual 55';
    }
  }
}
 */