// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:myapp/services/appstate.dart';
import 'package:myapp/services/userservices.dart';
import 'package:myapp/values/theme.dart';
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
                  return null;
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
                      //TODO: Aceptar agregar tarea
                      if (_formularioKey.currentState!.validate()) {
                        
                        bool respuesta = await Provider
                          .of<Appstate>(context, listen: false)
                          .saveProducts(_tituloController.text, _selectedLugar!);
                        
                        // await UserServices().saveProduct(
                        //   _tituloController.text,
                        //   _selectedLugar!
                        // );

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
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_nuevoLugarController.text.isNotEmpty) {
                  //TODO: Agregar lugar a Firebase
                  setState(() {
                    _lugares.add(_nuevoLugarController.text);
                    _selectedLugar = _nuevoLugarController.text;
                  });
                  _nuevoLugarController.clear();
                  Navigator.pop(context);
                }
              },
              child: const Text('Guardar'),
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