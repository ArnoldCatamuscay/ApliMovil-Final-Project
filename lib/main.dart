import 'package:flutter/material.dart';
import 'package:myapp/pages/new_product.dart';
import 'package:myapp/pages/pages.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:myapp/services/appstate.dart';
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
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        //home: const MyHomePage(title: 'Flutter Demo Home Page'),
        initialRoute: "/",
        routes: {
          "/":(context) => const HomePage(),
          "/nuevo":(context) => const ModalNewProduct(),
        },
        // home: const HomePage()//initial route
      )
    );
  }
}
