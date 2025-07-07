/*
// File: /lib/views/poliza_list_view.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/poliza_viewmodel.dart';
import 'poliza_view.dart';

class PolizaListView extends StatefulWidget {
  @override
  _PolizaListViewState createState() => _PolizaListViewState();
}

class _PolizaListViewState extends State<PolizaListView> {
  @override
  void initState() {
    super.initState();
    Provider.of<PolizaViewModel>(context, listen: false).obtenerPolizas();
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<PolizaViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de Pólizas", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.teal,
      ),
      body: vm.polizas.isEmpty
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: [
            DataColumn(label: Text('Propietario')),
            DataColumn(label: Text('Modelo Auto')),
            DataColumn(label: Text('Edad')),
            DataColumn(label: Text('Accidentes')),
            DataColumn(label: Text('Costo Total')),
            DataColumn(label: Text('Acciones')),
          ],
          rows: vm.polizas
              .map(
                (poliza) => DataRow(cells: [
              DataCell(Text(poliza.propietario)),
              DataCell(Text(poliza.modeloAuto)),
              DataCell(Text(poliza.edadPropietario)),
              DataCell(Text(poliza.accidentes.toString())),
              DataCell(Text(poliza.costoTotal.toStringAsFixed(2))),
              DataCell(IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  // Cargar datos de la póliza en el formulario
                  final vm = Provider.of<PolizaViewModel>(context, listen: false);
                  vm.propietario = poliza.propietario;
                  vm.valorSeguroAuto = poliza.valorSeguroAuto;
                  vm.modeloAuto = poliza.modeloAuto;
                  vm.edadPropietario = poliza.edadPropietario;
                  vm.accidentes = poliza.accidentes;
                  vm.costoTotal = poliza.costoTotal;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PolizaView(
                        onSave: () => vm.actualizarPoliza(poliza.id),
                      ),
                    ),
                  );
                },
              )),
            ]),
          )
              .toList(),
        ),
      ),
    );
  }
}
* */