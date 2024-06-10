import 'package:flutter/material.dart';
import 'package:myapp/models/shoppinglist.dart';
import 'package:myapp/pages/pages.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:myapp/services/appstate.dart';
import 'package:myapp/values/theme.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Crear una instancia de Appstate
  Appstate appState = Appstate();

  // Comprobar si existen listas de compras
  List<ShoppingList> shoppingLists = await appState.getShoppingLists();

  // Si no existen listas, crear una nueva con el nombre "Mi lista"
  if (shoppingLists.isEmpty) {
    await appState.saveShoppingList("Mi lista", null);
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => Appstate(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Lista Compras App',
        theme: myTheme(context),
        initialRoute: "/",
        routes: {
          "/":(context) => const HomePage(),
          "/list-shopping": (context) => const ListShopping(),
          "/new-product":(context) => const ModalNewProduct(),
          "/edit-product":(context) => const ModalEditProduct(),
          "/clone-list":(context) => const ModalCloneList(),
        },
      )
    );
  }
}