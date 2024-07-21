import 'package:flutter/material.dart';
import 'package:prototahpp/pages/conceptos_page.dart';
import 'package:prototahpp/pages/consideraciones_page.dart';
import 'package:prototahpp/pages/crear1_page.dart';
import 'package:prototahpp/pages/home_page.dart';
import 'package:prototahpp/pages/nuevoExt_page.dart';
import 'package:prototahpp/pages/portah_page.dart';
import 'package:prototahpp/pages/ver_page.dart';
import 'package:prototahpp/pages/viewpdf_page.dart';
import 'package:prototahpp/pages/viewpdf_page2.dart';

class RouteGenerator {
  static Route<dynamic> createRouteHomePage() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => const HomePage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }

  static Route<dynamic> createRouteCrear1Page(RouteSettings? settings, {required Map arguments}) {
    switch (settings?.name) {
      case '/crear1Page':
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => Crear1Page(),
          settings: RouteSettings(arguments: arguments),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        );

      default:
        return createRouteHomePage();
    }
  }

  static Route<dynamic> createRouteNuevoExtPage() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => NuevoExtPage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }

  static Route<dynamic> createRouteVerPage() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => VerPage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }

  static Route<dynamic> createRouteConceptosPage() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => const ConceptosPage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }

  static Route<dynamic> createRouteConsideracionesPage() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => const ConsideracionesPage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }

  static Route<dynamic> createRoutePortafolioPage() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => PortahPage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }

   static Route<dynamic> createRouteViewPdfPage2(RouteSettings? settings, {required Map arguments}) {
    switch (settings?.name) {
      case '/viewpdfPage2':
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => ViewPdfPage2(),
          settings: RouteSettings(arguments: arguments),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        );

      default:
        return createRouteHomePage();
    }
  }

  static Route<dynamic> createRouteViewPdfPage(RouteSettings? settings, {required Map arguments}) {
    switch (settings?.name) {
      case '/viewpdfPage':
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => ViewPdfPage(),
          settings: RouteSettings(arguments: arguments),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        );

      default:
        return createRouteHomePage();
    }
  }


}
