
import 'package:flutter/material.dart';
import 'package:myapp/models/product.dart';
import 'package:myapp/values/theme.dart';

// ignore: must_be_immutable
class HomePage extends StatelessWidget {
  HomePage({super.key});

  List<Product> products = [
    Product(title: 'Producto 1', place: 'D1'),
    Product(title: 'Producto 2', place: 'Olimpica'),
    Product(title: 'Producto 3', place: 'Ara'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lista Compras App')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context){
              return const ModalNewProduct();
            });
        }, 
        child: const Icon(Icons.add),
        ),
      body: ListView(
        children: [
          for (Product product in products)
          ListTile(
            title: Text(product.title!),
            subtitle: Text(product.place!),
          )
          
        ],
      )
    );
  }
}

class ModalNewProduct extends StatefulWidget {
  
  const ModalNewProduct({
    super.key,
  });
  
  @override
  State<ModalNewProduct> createState() => _ModalNuevoProductoState();
}

class _ModalNuevoProductoState extends State<ModalNewProduct> {
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _lugarController = TextEditingController();

  String? _selectedLugar;
  final List<String> _lugares = ['D1', 'OLIMPICA', 'ARA'];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      //height: 300,
      color: blanco,
      child: Form(
        child: Column(
          children: [
            TextFormField(
              controller: _tituloController,
              decoration: 
              const InputDecoration(labelText: 'Nombre del producto'),
            ),
            Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedLugar,
                      decoration: const InputDecoration(labelText: 'Lugar del producto'),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedLugar = newValue;
                        });
                      },
                      items: _lugares.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      //TODO: Manejar evento del button
                    },
                  ),
                ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Producto agregado correctamente'),
                      ),
                    );
                  },
                  child: const Text('Aceptar'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  }, child: const Text('Cancelar'),
                ),
              ],
            )
          ],
          )
        ),
    );
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _lugarController.dispose();
    super.dispose();
  }
}