import 'package:flutter/material.dart';

import 'package:formvalidators/src/bloc/provider.dart';

import 'package:formvalidators/src/pages/home_page.dart';
import 'package:formvalidators/src/pages/login_page.dart';
import 'package:formvalidators/src/pages/producto_page.dart';
import 'package:formvalidators/src/pages/registro_page.dart';
import 'package:formvalidators/src/preferencias_usuario/preferencias_usuario.dart';
 
void main() async { 

  WidgetsFlutterBinding.ensureInitialized();
  final prefs = new PreferenciasUsuario();
  await prefs.initPrefs();

  runApp(MyApp());

} 
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final prefs = new PreferenciasUsuario();
    print(prefs.token);
    
    return Provider(
      child: MaterialApp(
        title: 'Login',
        debugShowCheckedModeBanner: false,
        initialRoute: 'login',
        routes: {
          'login'     : (BuildContext contex) => LoginPage(),
          'registro'  : (BuildContext contex) => RegistroPage(),
          'home'      : (BuildContext contex) => HomePage(),
          'producto'  : (BuildContext contex) => ProductoPage(),
        },
        theme: ThemeData(
          primaryColor: Colors.deepPurple
        ),
      )
    );
  
  }
}