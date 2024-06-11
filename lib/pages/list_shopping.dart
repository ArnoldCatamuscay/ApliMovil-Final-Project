import 'package:flutter/material.dart';
import 'package:myapp/models/shoppinglist.dart';
import 'package:myapp/services/appstate.dart';
import 'package:myapp/values/theme.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class ListShopping extends StatefulWidget {
  const ListShopping({super.key});

  @override
  State<ListShopping> createState() => _ListShoppingState();
}

class _ListShoppingState extends State<ListShopping> {
  Appstate? state;

  @override
  Widget build(BuildContext context1) {
    state = Provider.of<Appstate>(context1, listen: true);
    return Scaffold(
      appBar: AppBar(title: const Text('Crear nueva lista'), centerTitle: true,),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     Navigator.pushNamed(context1, '/new-list');
      //   }, 
      //   backgroundColor: primary,
      //   foregroundColor: Colors.white,
      //   child: const Icon(Icons.add),
      //   ),
      body: FutureBuilder(
        future: state!.getShoppingLists(), 
        builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
          List myShoppingLists = snapshot.data ?? [];
          return ListView(
            children: [
              for (ShoppingList shoppingList in myShoppingLists)
              ListTile(
                leading: IconButton(
                    onPressed: () => Navigator.pushNamed(
                      context1,
                      '/clone-list',
                      arguments:{
                        'shoppingList': shoppingList,
                        // 'products': shoppingList.products,
                      }
                    ),
                    icon: const Icon(Icons.copy),
                    color: primary,
                  ),
                title: Text(shoppingList.name!),
                subtitle: Text(shoppingList.createdAt!),
                // onTap: () => Navigator.pushNamed(
                //   context1, 
                //   '/list-products', 
                //   arguments: shoppingList
                // ),
              )  
            ],
          );
        }), 
    );
  }
}