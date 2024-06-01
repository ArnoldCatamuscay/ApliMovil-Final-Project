
import 'package:flutter/material.dart';
import 'package:myapp/models/product.dart';
import 'package:myapp/services/userservices.dart';
// import 'package:myapp/pages/new_product.dart';
// import 'package:myapp/values/theme.dart';

// ignore: must_be_immutable
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lista Compras App')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/nuevo');
          // showModalBottomSheet(
          //   context: context,
          //   builder: (BuildContext context){
          //     return const ModalNewProduct();
          //   });
        }, 
        child: const Icon(Icons.add),
        ),
      body: FutureBuilder(
        future: UserServices().getProductos(), 
        builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
          List misproducts = snapshot.data ?? [];
          return ListView(
            children: [
              for (Product product in misproducts)
              ListTile(
                title: Text(product.title!),
                subtitle: Text(product.place!),
              )  
            ],
          );
        }), 
    );
  }
}

