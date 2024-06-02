import 'package:flutter/material.dart';
import 'package:myapp/pages/edit-product.dart';
import 'package:myapp/pages/new_product.dart';
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
          "/new-product":(context) => const ModalNewProduct(),
          "/edit-product":(context) => const ModalEditProduct(),
        },
      )
    );
  }
}
