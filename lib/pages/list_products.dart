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
      appBar: AppBar(title: const Text('Lista de compras')),
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
                title: Text(product.title!),
                subtitle: Text(product.place!),
                trailing: IconButton(
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
              )  
            ],
          );
        }), 
    );
  }
}

