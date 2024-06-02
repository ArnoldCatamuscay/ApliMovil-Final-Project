// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:myapp/models/place.dart';
import 'package:myapp/models/product.dart';
import 'package:myapp/services/appstate.dart';
// import 'package:myapp/services/userservices.dart';
import 'package:myapp/values/theme.dart';
import 'package:provider/provider.dart';

class ModalEditProduct extends StatefulWidget {
  
  const ModalEditProduct({
    super.key,
  });
  
  @override
  State<ModalEditProduct> createState() => _ModalEditProductState();
}

class _ModalEditProductState extends State<ModalEditProduct> {
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _lugarController = TextEditingController();
  final TextEditingController _nuevoLugarController = TextEditingController();

  String? _selectedLugar;
  // final List<String> _lugares = ['D1', 'OLIMPICA', 'ARA'];

  final GlobalKey<FormState> _formularioKey2 = GlobalKey<FormState>();
  Appstate? state;

  @override
  Widget build(BuildContext context) {
    final Product product = ModalRoute.of(context)!.settings.arguments as Product;
    // _tituloController.text = product.title!;
    // _selectedLugar = product.place;

    state = Provider.of<Appstate>(context, listen: true);
    return Scaffold(
      appBar: AppBar(title: const Text("Editar producto"),),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        //height: 300,
        // color: blanco,
        child: Form(
          key: _formularioKey2,
          child: SingleChildScrollView(
            child: Column(
            children: [
              TextFormField(
                // controller: _tituloController,
                initialValue: product.title,
                onChanged: (value) {
                  _tituloController.text = value;
                },
                decoration: const InputDecoration(
                  labelText: 'Nombre del producto', 
                  // hintText: product.title
                ),
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
                            value: _selectedLugar ?? product.place,
                            decoration: InputDecoration(
                              labelText: 'Lugar del producto',
                              hintText: product.place
                            ),
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedLugar = newValue;
                              });
                            },
                            //TODO: cargar lista de lugares
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
                      //TODO: Aceptar agregar tarea
                      if (_formularioKey2.currentState!.validate()) {
                        if(_tituloController.text.isEmpty) {
                          _tituloController.text = product.title!;
                        }
                        _selectedLugar ??= product.place;
                        // print("Valor por argumento: " + '${product.place ?? ' es nulo'}');
                        // print("Valor selected: " + '${_selectedLugar ?? ' es nulo'}');
                        bool respuesta = await Provider
                          .of<Appstate>(context, listen: false)
                          .updateProduct(product.key!,_tituloController.text, _selectedLugar!);
                        
                        if(respuesta) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Producto actualizado correctamente'),
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
                    child: const Text('Actualizar'),
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
                  //TODO: Agregar lugar a Firebase
                  bool response = await Provider
                    .of<Appstate>(context, listen: false)
                    .savePlace(_nuevoLugarController.text);

                  if(response) {
                    //!delete
                    // setState(() {
                    //   _lugares.add(_nuevoLugarController.text);
                    //   _selectedLugar = _nuevoLugarController.text;
                    // });
                    //! end delete

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