import 'package:flutter/material.dart';
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
      appBar: AppBar(title: const Text('Inicio'), centerTitle: true,),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context1, '/new-list');
        }, 
        backgroundColor: primary,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
        ),
      body: FutureBuilder(
        future: state!.getShoppingLists(), 
        builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
          List myShoppingLists = snapshot.data ?? [];
          return ListView(
            children: [
              for (ShoppingList shoppingList in myShoppingLists)
              ListTile(
                title: Text(shoppingList.name!),
                subtitle: Text(shoppingList.date!),
                onTap: () => Navigator.pushNamed(
                  context1, 
                  '/list-products', 
                  arguments: shoppingList
                ),
              )  
            ],
          );
        }), 
    );
  }
}

