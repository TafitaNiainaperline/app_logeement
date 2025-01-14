import 'package:flutter/material.dart';
import 'pages/login_page.dart';
import 'pages/register_page.dart';
import 'pages/home_page.dart';
import 'pages/mes_annonces_page.dart';
import 'pages/profil_page.dart';
import 'pages/edit_profilepage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Application de Logements',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/login',  
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/edit-profile':
            return MaterialPageRoute(builder: (_) => EditProfilePage());
          case '/login':
            return MaterialPageRoute(builder: (_) => LoginPage());
          case '/register':
            return MaterialPageRoute(builder: (_) => RegisterPage());
          case '/home':
            return MaterialPageRoute(builder: (_) => HomePage());
          case '/mes-annonces':
            return MaterialPageRoute(builder: (_) => MesAnnoncesPage());
          case '/profil':
            return MaterialPageRoute(builder: (_) => ProfilPage());
          
          default:
            return MaterialPageRoute(builder: (_) => LoginPage()); // Route par défaut
        }
      },
    );
  }
}
