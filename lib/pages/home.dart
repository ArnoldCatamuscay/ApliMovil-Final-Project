
import 'package:flutter/material.dart';
import 'package:myapp/models/product.dart';
import 'package:myapp/services/appstate.dart';
import 'package:myapp/values/theme.dart';
// import 'package:myapp/services/userservices.dart';
import 'package:provider/provider.dart';
// import 'package:myapp/pages/new_product.dart';
// import 'package:myapp/values/theme.dart';

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
      appBar: AppBar(title: const Text('Lista Compras App')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context1, '/new-product');
        }, 
        backgroundColor: primary,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
        ),
      body: FutureBuilder(
        future: state!.getProducts(), 
        builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
          List misproducts = snapshot.data ?? [];
          return ListView(
            children: [
              for (Product product in misproducts)
              ListTile(
                title: Text(product.title!),
                subtitle: Text(product.place!),
                trailing: IconButton(
                  onPressed: () => Navigator.pushNamed(context1, '/edit-product', arguments: product), 
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

