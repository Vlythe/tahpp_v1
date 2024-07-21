import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:prototahpp/pages/conceptos_page.dart';
import 'package:prototahpp/pages/consideraciones_page.dart';
import 'package:prototahpp/pages/crear1_page.dart';
import 'package:prototahpp/pages/home_page.dart';
import 'package:prototahpp/pages/portah_page.dart';
import 'package:prototahpp/pages/seleccionar_page.dart';
import 'package:prototahpp/pages/ver_page.dart';
import 'package:prototahpp/pages/viewpdf_page.dart';
import 'package:prototahpp/pages/viewpdf_page2.dart';

void main() async {
  
  await Hive.initFlutter();

  var boxConceptos = await Hive.openBox('conceptosDB');
  var boxFootnotes = await Hive.openBox('footnotesDB');
  var boxPlantillas = await Hive.openBox('plantillasDB');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {

  


  const MyApp({super.key});

  // This widget is the root of your application.
  @override

  Widget build(BuildContext context) {

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MaterialApp(
      title: 'Tahpp',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        dividerColor: const Color.fromARGB(255, 204, 87, 55),
        primaryColor: Colors.black,
        highlightColor: const Color.fromARGB(255, 204, 87, 55),
        shadowColor: const Color.fromARGB(127, 219, 219, 219),
        unselectedWidgetColor: const Color.fromARGB(255, 100, 100, 100),
        scaffoldBackgroundColor: const Color.fromARGB(255, 240, 236, 225),
        textTheme: const TextTheme(
          displaySmall: TextStyle(color: Colors.black, fontSize: 18, fontFamily: 'Baskerville',),
          bodySmall: TextStyle(color: Colors.black, fontSize: 12, fontFamily: 'Baskerville',),
          labelSmall: TextStyle(color: Color.fromARGB(255, 100, 100, 100), fontSize: 14, fontFamily: 'Baskerville'),
          labelMedium: TextStyle(color: Colors.black, fontSize: 16, fontFamily: 'Baskerville'),
          bodyMedium: TextStyle(color: Color.fromARGB(255, 204, 87, 55), fontSize: 18, fontFamily: 'Baskerville',)
        ),
        appBarTheme: const AppBarTheme(
            backgroundColor: Color.fromARGB(255, 240, 236, 225), // Set your desired AppBar color here
          ),
      ),
      home: const HomePage(),
      routes: {
        '/homePage': (context) => const HomePage(),
        '/crear1Page': (context) => Crear1Page(),
        '/verPage': (context) => VerPage(),
        '/seleccionarPage': (context) => const SeleccionarPage(),
        '/portahPage': (context) => PortahPage(),
        '/viewpdfPage': (context) => const ViewPdfPage(),
        '/viewpdfPage2': (context) => const ViewPdfPage2(),
        '/conceptosPage': (context) => const ConceptosPage(),
        '/consideracionesPage': (context) => const ConsideracionesPage(),
      },
    );
  }
}
