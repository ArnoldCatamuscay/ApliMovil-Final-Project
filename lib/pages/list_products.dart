import 'package:flutter/material.dart';
import 'package:myapp/models/product.dart';
import 'package:myapp/models/shoppinglist.dart';
import 'package:myapp/services/appstate.dart';
import 'package:myapp/values/theme.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class ListProducts extends StatefulWidget {
  const ListProducts({super.key});

  @override
  State<ListProducts> createState() => _ListProductsState();
}

class _ListProductsState extends State<ListProducts> {
  Appstate? state;

  @override
  Widget build(BuildContext context1) {
    final ShoppingList shoppingList = ModalRoute.of(context)!.settings.arguments as ShoppingList;

    state = Provider.of<Appstate>(context1, listen: true);
    return Scaffold(
      appBar: AppBar(title: Text('Lista de compras: ${shoppingList.name}')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
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
      body: FutureBuilder(
        future: state!.getProducts(shoppingList.key!), 
        builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
          List misproducts = snapshot.data ?? [];
          return ListView(
            children: [
              for (Product product in misproducts)
              ListTile(
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
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Checkbox(
                      value: product.isChecked, 
                      onChanged: (bool? value){
                        setState(() {
                          product.isChecked = value!;
                          state!.updateProductCheckStatus(shoppingList.key!, product.key!, value);
                        });
                      },
                    ),
                    IconButton(
                      onPressed: () => Navigator.pushNamed(
                        context1, 
                        '/edit-product', 
                        arguments: {
                          'product': product,
                          'key': shoppingList.key,
                        }
                      ), 
                      icon: const Icon(Icons.edit),
                      color: primary,
                    ),
                  ],
                ),   
              )  
            ],
          );
        }), 
    );
  }
}

