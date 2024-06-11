
// // ignore_for_file: use_build_context_synchronously

// import 'package:flutter/material.dart';
// import 'package:myapp/services/appstate.dart';
// import 'package:provider/provider.dart';

// class ModalNewList extends StatefulWidget {
  
//   const ModalNewList({
//     super.key,
//   });
  
//   @override
//   State<ModalNewList> createState() => _ModalNewListState();
// }

// class _ModalNewListState extends State<ModalNewList> {
//   final TextEditingController _nameController = TextEditingController();
//   // final TextEditingController _dateController = TextEditingController();

//   final GlobalKey<FormState> _formularioKey = GlobalKey<FormState>();
//   Appstate? state;

//   @override
//   Widget build(BuildContext context) {
//     state = Provider.of<Appstate>(context, listen: true);
//     return Scaffold(
//       appBar: AppBar(title: const Text("Crear nueva lista de compras"),),
//       body: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//         child: Form(
//           key: _formularioKey,
//           child: SingleChildScrollView(
//             child: Column(
//             children: [
//               TextFormField(
//                 controller: _nameController,
//                 decoration: const InputDecoration(labelText: 'Nombre de la lista'),
//                 validator: (String? dato) {
//                   if(dato!.isEmpty) {
//                     return 'Este campo es requerido';
//                   }
//                   return null;
//                 }
//               ),
//               // TextFormField(
//               //   controller: _dateController,
//               //   decoration: const InputDecoration(
//               //     labelText: 'Fecha', 
//               //     filled: true,
//               //     prefixIcon: Icon(Icons.calendar_today),
//               //   ),
//               //   readOnly: true,
//               //   onTap: () async {
//               //     DateTime? picked = await showDatePicker(
//               //       context: context, 
//               //       initialDate: DateTime.now(),
//               //       firstDate: DateTime(2000), 
//               //       lastDate: DateTime(2100)
//               //     );
//               //     if(picked != null) {
//               //       setState(() {
//               //         _dateController.text = picked.toString().split(" ")[0];
//               //       });
//               //     }
//               //   },
//               //   validator: (String? dato) {
//               //     if(dato!.isEmpty) {
//               //       return 'Este campo es requerido';
//               //     }
//               //     return null;
//               //   }
//               // ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   ElevatedButton(
//                     onPressed: () async {
//                       if (_formularioKey.currentState!.validate()) {
//                         bool respuesta = await Provider
//                           .of<Appstate>(context, listen: false)
//                           .saveShoppingList(_nameController.text,null);
                        
//                         if(respuesta) {
//                           Navigator.pop(context);
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             const SnackBar(
//                               content: Text('Lista creada correctamente'),
//                               backgroundColor: Colors.green,
//                             ),
//                           );
//                         } else {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             const SnackBar(
//                               content: Text('Algo salió mal'),
//                               backgroundColor: Colors.red,
//                             ),
//                           );
//                         }
//                       }
//                     },
//                     style: ButtonStyle(
//                       backgroundColor: WidgetStateProperty.all(Colors.indigo),
//                       foregroundColor: WidgetStateProperty.all(Colors.white)
//                     ),
//                     child: const Text('Crear'),
//                   ),
//                   const SizedBox(width: 10),
//                   ElevatedButton(
//                     onPressed: () {
//                       Navigator.pop(context);
//                     },
//                     style: ButtonStyle(
//                       backgroundColor: WidgetStateProperty.all(Colors.pink),
//                       foregroundColor: WidgetStateProperty.all(Colors.white)
//                     ), 
//                     child: const Text('Cancelar'),
//                   ),
//                 ],
//               )
//             ],
//             )
//           )
//           ),
//     ),
//     );
//   }

//   @override
//   void dispose() {
//     _nameController.dispose();
//     // _dateController.dispose();
//     super.dispose();
//   }
// }
