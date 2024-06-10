// // ignore_for_file: use_build_context_synchronously

// import 'package:flutter/material.dart';
// import 'package:flutter_slidable/flutter_slidable.dart';
// import 'package:myapp/models/product.dart';
// import 'package:myapp/models/shoppinglist.dart';
// import 'package:myapp/services/appstate.dart';
// import 'package:myapp/values/theme.dart';
// import 'package:provider/provider.dart';

// // ignore: must_be_immutable
// class ListProducts extends StatefulWidget {
//   const ListProducts({super.key});

//   @override
//   State<ListProducts> createState() => _ListProductsState();
// }

// class _ListProductsState extends State<ListProducts> {
//   Appstate? state;

//   @override
//   Widget build(BuildContext context1) {
//     final ShoppingList shoppingList = ModalRoute.of(context)!.settings.arguments as ShoppingList;

//     state = Provider.of<Appstate>(context1, listen: true);
//     return Scaffold(
//       appBar: AppBar(title: Text('Lista de compras: ${shoppingList.name}')),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.pushNamed(
//             context1, 
//             '/new-product',
//             arguments: shoppingList.key
//           );
//         }, 
//         backgroundColor: primary,
//         foregroundColor: Colors.white,
//         child: const Icon(Icons.add),
//       ),
//       body: FutureBuilder(
//         future: state!.getProducts(shoppingList.key!), 
//         builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
//           List misproducts = snapshot.data ?? [];
//           return ListView(
//             children: [
//               for (Product product in misproducts)
//                 Slidable(
//                   key: Key(product.key!),
//                   endActionPane: ActionPane(
//                     motion: const ScrollMotion(),
//                     dismissible: DismissiblePane(
//                       onDismissed: () {                      
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           const SnackBar(
//                             content: Text('Producto eliminado correctamente'),
//                             backgroundColor: Colors.green,
//                           ),
//                         );
//                       },
//                      confirmDismiss: () async {
//                       return await showDialog(
//                         context: context,
//                         builder: (BuildContext context) {
//                           return AlertDialog(
//                             title: const Text("Confirmación"),
//                             content: const Text("¿Estas seguro de eliminar este producto?"),
//                             actions: <Widget>[
//                               ElevatedButton(
//                                 onPressed: () async {
//                                   if (product.isChecked) {
//                                     ScaffoldMessenger.of(context).showSnackBar(
//                                       const SnackBar(content: Text("Solo se pueden eliminar productos que no estan marcados"),backgroundColor: Colors.indigo,)
//                                     );
//                                     Navigator.of(context).pop(false);
//                                     return;
//                                   }

//                                   bool result = await state!.deleteProduct(/*shoppingList.key!,*/ product.key!);
//                                   if (result) {
//                                     ScaffoldMessenger.of(context).showSnackBar(
//                                       SnackBar(content: Text("${product.title} eliminado"),backgroundColor: Colors.green,)
//                                     );
//                                     Navigator.of(context).pop(true);
//                                   } else {
//                                     ScaffoldMessenger.of(context).showSnackBar(
//                                       SnackBar(content: Text("Error al eliminar ${product.title}"))
//                                     );
//                                     Navigator.of(context).pop(false);
//                                   }
//                                 },
//                                 child: const Text("Eliminar")
//                               ),
//                               ElevatedButton(
//                                 onPressed: () => Navigator.of(context).pop(false),
//                                 child: const Text("Cancelar"),
//                               ),
//                             ],
//                           );
//                         },
//                       );
//                     },
//                     ),
//                     // dragDismissible: false,
//                     children: [
//                       SlidableAction(
//                         onPressed: (context) {
//                           Navigator.pushNamed(
//                               context1, 
//                               '/edit-product', 
//                               arguments: {
//                                 'product': product,
//                                 'key': shoppingList.key,
//                               }
//                             );
//                         },
//                         backgroundColor: Colors.blue,
//                         foregroundColor: Colors.white,
//                         icon: Icons.edit,
//                         label: 'Editar',
//                       ),
//                       SlidableAction(
//                       onPressed: (context) => {
//                       },
//                       backgroundColor: Colors.red,
//                       foregroundColor: Colors.white,
//                       icon: Icons.delete,
//                       label: 'Eliminar',
//                     ),

//                     ],
//                   ),
//                   child: GestureDetector(
//                     onDoubleTap: () {
//                       setState(() {
//                         product.isChecked = !product.isChecked;
//                         state!.updateProductCheckStatus(/*shoppingList.key!,*/ product.key!, product.isChecked);
//                       });
//                     },
//                     child: ListTile(
//                       title: Text(
//                         product.title!, 
//                         style: TextStyle(
//                           decoration: product.isChecked ? TextDecoration.lineThrough : TextDecoration.none,
//                           color: product.isChecked ? Colors.blue : Colors.black,
//                         ),
//                       ),
//                       subtitle: Text(
//                         product.place!,
//                         style: TextStyle(
//                           decoration: product.isChecked ? TextDecoration.lineThrough : TextDecoration.none,
//                           color: product.isChecked ? Colors.blue : Colors.black,
//                         ),
//                       ),  
//                     ),
//                   ),
//                 ),
//             ],
//           );
//         }), 
//     );
//   }
// }