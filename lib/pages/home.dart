// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:myapp/models/product.dart';
import 'package:myapp/models/shoppinglist.dart';
import 'package:myapp/services/appstate.dart';
import 'package:myapp/values/theme.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Appstate? state;

  @override
  Widget build(BuildContext context1) {
    state = Provider.of<Appstate>(context1, listen: true);

    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder<ShoppingList>(
          future: state!.getLatestShoppingList(),
          builder: (BuildContext context, AsyncSnapshot<ShoppingList> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text('Cargando...');
            } else if (snapshot.hasError) {
              return const Text('Error');
            } else if (!snapshot.hasData || snapshot.data == null) {
              return const Text('No hay listas de compras disponibles');
            } else {
              ShoppingList shoppingList = snapshot.data!;
              return Text('Lista de compras: ${shoppingList.name}');
            }
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_shopping_cart),
            onPressed: () {
              Navigator.pushNamed(context1, '/list-shopping');
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var shoppingList = await state!.getLatestShoppingList();
          Navigator.pushNamed(
            context1, 
            '/new-product',
            arguments: shoppingList.key
          );
        }, 
        backgroundColor: primary,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<ShoppingList>(
        //? Obtener la lista más reciente
        future: state!.getLatestShoppingList(),
        builder: (BuildContext context, AsyncSnapshot<ShoppingList> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } 
          else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('No hay listas de compras disponibles'));
          }

          ShoppingList shoppingList = snapshot.data!;
          return FutureBuilder<List<Product>>(
            future: state!.getProducts(shoppingList.key!),
            builder: (BuildContext context, AsyncSnapshot<List<Product>> productSnapshot) {
              if (productSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (productSnapshot.hasError) {
                return Center(child: Text('Error: ${productSnapshot.error}'));
              } else if (!productSnapshot.hasData || productSnapshot.data == null) {
                return const Center(child: Text('No hay productos disponibles'));
              }

              //? Pintar la lista de compras más reciente
              List<Product> misproducts = productSnapshot.data!;
              return ListView(
                children: [
                  for (Product product in misproducts)
                    Slidable(
                      key: Key(product.key!),
                      endActionPane: ActionPane(
                        motion: const ScrollMotion(),
                        dismissible: DismissiblePane(
                          onDismissed: () {                      
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Producto eliminado correctamente'),
                                backgroundColor: Colors.green,
                              ),
                            );
                          },
                          confirmDismiss: () async {
                            return await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text("Confirmación"),
                                  content: const Text("¿Estas seguro de eliminar este producto?"),
                                  actions: <Widget>[
                                    ElevatedButton(
                                      onPressed: () async {
                                        if (product.isChecked) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(
                                              content: Text("Solo se pueden eliminar productos que no estan marcados"),
                                              backgroundColor: Colors.indigo,
                                            ),
                                          );
                                          Navigator.of(context).pop(false);
                                          return;
                                        }

                                        bool result = await state!.deleteProduct(product.key!);
                                        if (result) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text("${product.title} eliminado"),
                                              backgroundColor: Colors.green,
                                            ),
                                          );
                                          Navigator.of(context).pop(true);
                                        } else {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text("Error al eliminar ${product.title}"))
                                          );
                                          Navigator.of(context).pop(false);
                                        }
                                      },
                                      child: const Text("Eliminar"),
                                    ),
                                    ElevatedButton(
                                      onPressed: () => Navigator.of(context).pop(false),
                                      child: const Text("Cancelar"),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                        children: [
                          SlidableAction(
                            onPressed: (context) {
                              Navigator.pushNamed(
                                context1, 
                                '/edit-product', 
                                arguments: {
                                  'product': product,
                                  'key': shoppingList.key,
                                },
                              );
                            },
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            icon: Icons.edit,
                            label: 'Editar',
                          ),
                          SlidableAction(
                            onPressed: (context) {},
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            icon: Icons.delete,
                            label: 'Eliminar',
                          ),
                        ],
                      ),
                      child: GestureDetector(
                        onDoubleTap: () {
                          setState(() {
                            product.isChecked = !product.isChecked;
                            state!.updateProductCheckStatus(product.key!, product.isChecked);
                          });
                        },
                        child: ListTile(
                          title: Text(
                            product.title!, 
                            style: TextStyle(
                              decoration: product.isChecked ? TextDecoration.lineThrough : TextDecoration.none,
                              color: product.isChecked ? Colors.blue : Colors.black,
                            ),
                          ),
                          subtitle: Text(
                            product.place!,
                            style: TextStyle(
                              decoration: product.isChecked ? TextDecoration.lineThrough : TextDecoration.none,
                              color: product.isChecked ? Colors.blue : Colors.black,
                            ),
                          ),  
                        ),
                      ),
                    ),
                ],
              );
            },
          );
        },
      ), 
    );
  }
}