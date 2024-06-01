import 'package:flutter/material.dart';
import 'package:myapp/services/userservices.dart';
import 'package:myapp/values/theme.dart';

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

  final GlobalKey<FormState> _formularioKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        //height: 300,
        color: blanco,
        child: Form(
          key: _formularioKey,
          child: SingleChildScrollView(
            child: Column(
            children: [
              TextFormField(
                controller: _tituloController,
                decoration: 
                const InputDecoration(labelText: 'Nombre del producto'),
                validator: (String? dato) {
                  if(dato!.isEmpty) {
                    return 'Este campo es requerido';
                  }
                }
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
                    onPressed: () async {
                      //TODO: Aceptar agregar tarea
                      if (_formularioKey.currentState!.validate()) {
                        bool respuesta = await UserServices().saveNotas(
                          _tituloController.text
                        );

                        if(respuesta) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Producto agregado correctamente'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Algo salió mal'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }

                      
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
          )
          ),
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