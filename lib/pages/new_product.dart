// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:myapp/models/place.dart';
import 'package:myapp/services/appstate.dart';
import 'package:provider/provider.dart';

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
  final TextEditingController _nuevoLugarController = TextEditingController();

  String? _selectedLugar;

  final GlobalKey<FormState> _formularioKey = GlobalKey<FormState>();
  Appstate? state;

  @override
  Widget build(BuildContext context) {
    state = Provider.of<Appstate>(context, listen: true);
    return Scaffold(
      appBar: AppBar(title: const Text("Agregar producto"),),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                  return null;
                }
              ),
              Row(
                  children: [
                    Expanded(
                      child: FutureBuilder(
                        future: state!.getPlaces(), 
                        builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
                          List<Place>? places = (snapshot.data ?? []).cast<Place>();
                          return DropdownButtonFormField<String>(
                            value: _selectedLugar,
                            decoration: const InputDecoration(labelText: 'Lugar del producto'),
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedLugar = newValue;
                              });
                            },
                            items: places.map<DropdownMenuItem<String>>((Place lugar) {
                                return DropdownMenuItem<String>(
                                  value: lugar.name,
                                  child: Text(lugar.name ?? ''),
                                );
                              }).toList(),
                            
                          );
                        })
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        _mostrarModalAgregarLugar(context);
                      },
                    ),
                  ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      if (_formularioKey.currentState!.validate() && _selectedLugar != null && _selectedLugar!.isNotEmpty) {
                        
                        bool respuesta = await Provider
                          .of<Appstate>(context, listen: false)
                          .saveProduct(_tituloController.text, _selectedLugar!);
                        
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
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Colors.indigo),
                      foregroundColor: WidgetStateProperty.all(Colors.white)
                    ),
                    child: const Text('Aceptar'),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Colors.pink),
                      foregroundColor: WidgetStateProperty.all(Colors.white)
                    ), 
                    child: const Text('Cancelar'),
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

  void _mostrarModalAgregarLugar(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Agregar nuevo lugar'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nuevoLugarController,
                decoration: const InputDecoration(labelText: 'Nombre del lugar'),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Este campo es requerido';
                  }
                  return null;
                },
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                if (_nuevoLugarController.text.isNotEmpty) {
                  bool response = await Provider
                    .of<Appstate>(context, listen: false)
                    .savePlace(_nuevoLugarController.text);

                  if(response) {

                    _nuevoLugarController.clear();
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Lugar agregado correctamente'),
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
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Colors.indigo),
                foregroundColor: WidgetStateProperty.all(Colors.white)
              ),
              child: const Text('Guardar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Colors.pink),
                foregroundColor: WidgetStateProperty.all(Colors.white)
              ),
              child: const Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _lugarController.dispose();
    super.dispose();
  }
}