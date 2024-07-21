import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:prototahpp/components/duplicarAlertDialog.dart';
import 'package:prototahpp/components/route_generator.dart';

class ThreeDots extends StatelessWidget {
  final int _indexPlantilla;
  const ThreeDots(this._indexPlantilla, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _plantillasDB = Hive.box('plantillasDB');

    return PopupMenuButton<String>(
      color: Colors.white,
      icon: SvgPicture.asset('assets/threeDotsIcon.svg'),
      surfaceTintColor: Colors.white,
      tooltip: 'Opciones',
      shadowColor: Colors.white,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Theme.of(context).shadowColor, width: 2.0),
        borderRadius: BorderRadius.circular(0.0),
      ),
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        PopupMenuItem<String>(
          value: 'editar',
          child: Container(
              padding: EdgeInsets.only(right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(Icons.edit_sharp,
                      color: Theme.of(context).primaryColor, size: 20),
                  SizedBox(width: 10),
                  Text('Editar',
                      style: Theme.of(context).textTheme.labelMedium),
                ],
              )),
        ),
        PopupMenuItem<String>(
          value: 'duplicar',
          child: Container(
              padding: EdgeInsets.only(right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(
                    Icons.copy,
                    color: Theme.of(context).primaryColor,
                    size: 20,
                  ),
                  SizedBox(width: 10),
                  Text('Duplicar',
                      style: Theme.of(context).textTheme.labelMedium),
                ],
              )),
        ),
      ],
      onSelected: (String value) {
        // Handle menu item selection here
        if (value == 'editar') {
          // Handle "Editar plantilla" button press
          Map datos = {
            'tipo': 'editar',
            'indexPlantilla': _indexPlantilla,
            'total': _plantillasDB.getAt(_indexPlantilla)['total'],
            'vieneDeView': false,
          };
          Navigator.of(context).push(RouteGenerator.createRouteCrear1Page(
              const RouteSettings(name: '/crear1Page'),
              arguments: datos));
        } else if (value == 'duplicar') {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return DuplicarAlertDialog(_indexPlantilla);
            },
          );
        }
      },
    );
  }
}

class ThreeDots2 extends StatelessWidget {
  final int _indexPlantilla;
  const ThreeDots2(this._indexPlantilla, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _plantillasDB = Hive.box('plantillasDB');

    return PopupMenuButton<String>(
      color: Colors.white,
      icon: SvgPicture.asset('assets/threeDotsIcon.svg'),
      surfaceTintColor: Colors.white,
      tooltip: 'Opciones',
      shadowColor: Colors.white,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Theme.of(context).shadowColor, width: 2.0),
        borderRadius: BorderRadius.circular(0.0),
      ),
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        PopupMenuItem<String>(
          value: 'editar',
          child: Container(
              padding: EdgeInsets.only(right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(Icons.edit_sharp,
                      color: Theme.of(context).primaryColor, size: 20),
                  SizedBox(width: 10),
                  Text('Editar',
                      style: Theme.of(context).textTheme.labelMedium),
                ],
              )),
        ),
        PopupMenuItem<String>(
          value: 'duplicar',
          child: Container(
              padding: EdgeInsets.only(right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(
                    Icons.copy,
                    color: Theme.of(context).primaryColor,
                    size: 20,
                  ),
                  SizedBox(width: 10),
                  Text('Duplicar',
                      style: Theme.of(context).textTheme.labelMedium),
                ],
              )),
        ),
        PopupMenuItem<String>(
          value: 'eliminar',
          child: Container(
              padding: EdgeInsets.only(right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(
                    Icons.delete_sharp,
                    color: Theme.of(context).primaryColor,
                    size: 20,
                  ),
                  SizedBox(width: 10),
                  Text('Eliminar',
                      style: Theme.of(context).textTheme.labelMedium),
                ],
              )),
        ),
      ],
      onSelected: (String value) {
        // Handle menu item selection here
        if (value == 'editar') {
          // Handle "Editar plantilla" button press
          Map datos = {
            'tipo': 'editar',
            'indexPlantilla': _indexPlantilla,
            'total': _plantillasDB.getAt(_indexPlantilla)['total'],
            'vieneDeView': false,
          };
          Navigator.of(context).push(RouteGenerator.createRouteCrear1Page(
              const RouteSettings(name: '/crear1Page'),
              arguments: datos));
        } else if (value == 'duplicar') {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return DuplicarAlertDialog(_indexPlantilla);
            },
          );
        } else if (value == 'eliminar') {
          // Handle "Eliminar plantilla" button press
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Eliminar plantilla',
                    style: Theme.of(context).textTheme.displaySmall),
                content: Text(
                    '¿Estás seguro de que deseas eliminar la plantilla: "${_plantillasDB.getAt(_indexPlantilla)['nombreProyecto']}"?',
                    style: Theme.of(context).textTheme.labelMedium),
                backgroundColor: Colors.white,
                actionsAlignment: MainAxisAlignment.spaceEvenly,
                actionsPadding:
                    EdgeInsets.only(right: 20.0, left: 20.0, bottom: 15.0),
                shape: const RoundedRectangleBorder(
                    side: BorderSide(color: Colors.grey, width: 2.0),
                    borderRadius: BorderRadius.all(Radius.circular(0.0))),
                actions: <Widget>[
                  TextButton(
                    style: ButtonStyle(
                        shape: WidgetStateProperty.all(RoundedRectangleBorder(
                          side: BorderSide(
                              color: Theme.of(context).unselectedWidgetColor),
                          borderRadius: BorderRadius.circular(0.0),
                        )),
                        foregroundColor: WidgetStateProperty.all(
                            Theme.of(context).unselectedWidgetColor),
                        textStyle: WidgetStateProperty.all(
                            Theme.of(context).textTheme.displaySmall)),
                    onPressed: () {
                      
                      Navigator.of(context).pop();
                    },
                    child: Text('Cancelar',
                        style: Theme.of(context).textTheme.displaySmall),
                  ),
                  TextButton(
                    style: ButtonStyle(
                        shape: WidgetStateProperty.all(RoundedRectangleBorder(
                          side:
                              BorderSide(color: Theme.of(context).primaryColor),
                          borderRadius: BorderRadius.circular(0.0),
                        )),
                        foregroundColor: WidgetStateProperty.all(
                            Theme.of(context).primaryColor),
                        textStyle: WidgetStateProperty.all(
                            Theme.of(context).textTheme.displaySmall)),
                    onPressed: () {
                      // Handle "Eliminar" button press
                      _plantillasDB.deleteAt(_indexPlantilla);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          elevation: 10,
                          content: Text('Cotización eliminada.',
                              style: Theme.of(context).textTheme.bodyMedium),
                          backgroundColor: Colors.white,
                        ),
                      );
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                      Navigator.of(context)
                          .push(RouteGenerator.createRouteHomePage());
                    },
                    child: Text('Eliminar',
                        style: Theme.of(context).textTheme.displaySmall),
                  ),
                ],
              );
            },
          );
        }
      },
    );
  }
}
