import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:prototahpp/components/route_generator.dart';
import 'package:prototahpp/util/customUI.dart';

class myEndDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.of(context).size.width;
    return Drawer(
      shadowColor: Colors.transparent,
      elevation: 0,
      width: screenW,
      backgroundColor: Colors.transparent,
      child: Stack(
        
        children: [ 
          
          //Background SVG 
            Positioned.fill(
              child: SvgPicture.asset(
                'assets/sidebar2.svg',
                fit: BoxFit.cover)
                ),
          
          ListView(
          children: [
          
            //***** Botón CERRAR */

            myCloseButton(),
        
            //***** Botón CREAR */
            ListTile(
              selectedTileColor: Colors.transparent,
              selectedColor: Colors.transparent,
              splashColor: Colors.transparent,
              title: Text(
                'CREAR',
                textAlign: TextAlign.end,
                style: Theme.of(context).textTheme.displaySmall,
              ),
              titleAlignment: ListTileTitleAlignment.center,
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context)
                          .push(RouteGenerator.createRouteNuevoExtPage());
              },
            ),
        
            //***** Botón VER */
        
            ListTile(
              title: Text(
                'VER',
                textAlign: TextAlign.end,
                style: Theme.of(context).textTheme.displaySmall
              ),
              titleAlignment: ListTileTitleAlignment.center,
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(RouteGenerator.createRouteVerPage());
              },
            ),

            Divider(
              indent: screenW * 0.2,
              endIndent: screenW * 0.05,
              color: Theme.of(context).shadowColor,
              thickness: 2,),
              
            //***** Botón CONCEPTOS */
        
            ListTile(
              title: Text(
                'CONCEPTOS',
                textAlign: TextAlign.end,
                style: Theme.of(context).textTheme.displaySmall
              ),
              titleAlignment: ListTileTitleAlignment.center,
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(RouteGenerator.createRouteConceptosPage());
              },
            ),

            //***** Botón CONSIDERACIONES */

            ListTile(
              title: Text(
                'CONSIDERACIONES',
                textAlign: TextAlign.end,
                style: Theme.of(context).textTheme.displaySmall
              ),
              titleAlignment: ListTileTitleAlignment.center,
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(RouteGenerator.createRouteConsideracionesPage());
              },
            ),

            Divider(
              indent: screenW * 0.2,
              endIndent: screenW * 0.05,
              color: Theme.of(context).shadowColor,
              thickness: 2,),
        
            //***** Botón PROTOTAHPP */
            ListTile(
              title: Text(
                'PORTAFOLIO',
                textAlign: TextAlign.end,
                style: Theme.of(context).textTheme.displaySmall
              ),
              titleAlignment: ListTileTitleAlignment.center,
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(RouteGenerator.createRoutePortafolioPage());
              },
            ),
          ],
        )
        ],
      ),
    );
  }
}
