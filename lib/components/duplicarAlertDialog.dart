import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:prototahpp/components/route_generator.dart';

class DuplicarAlertDialog extends StatelessWidget {
  final indexPlantilla;
  const DuplicarAlertDialog(this.indexPlantilla, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _plantillasDB = Hive.box('plantillasDB');
    return AlertDialog(
      title:
          Text('¿Duplicar?', style: Theme.of(context).textTheme.displaySmall),
      content: Text(
        'Se duplicará la cotización:  "${_plantillasDB.getAt(indexPlantilla)['nombreProyecto']}"',
        style: Theme.of(context).textTheme.displaySmall,
      ),
      actionsAlignment: MainAxisAlignment.spaceAround,
      actionsPadding: EdgeInsets.only(right: 20.0, left: 20.0, bottom: 15.0),
      shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.grey, width: 2.0),
          borderRadius: BorderRadius.all(Radius.circular(0.0))),
      actions: [
        TextButton(
            // ********* cancelar
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancelar'),
            style: ButtonStyle(
                shape: WidgetStateProperty.all(RoundedRectangleBorder(
                  side: BorderSide(
                      color: Theme.of(context).unselectedWidgetColor),
                  borderRadius: BorderRadius.circular(0.0),
                )),
                foregroundColor: WidgetStateProperty.all(
                    Theme.of(context).unselectedWidgetColor),
                textStyle: WidgetStateProperty.all(
                    Theme.of(context).textTheme.displaySmall))),
        TextButton(
            onPressed: () {
              // **********duplicar plantilla
              Map datos = {
                'tipo': 'duplicar',
                'indexPlantilla': indexPlantilla,
                'total': _plantillasDB.getAt(indexPlantilla)['total'],
                'vieneDeView': false,
              };
              Navigator.pop(context, true);
              Navigator.of(context).push(RouteGenerator.createRouteCrear1Page(
                  const RouteSettings(name: '/crear1Page'),
                  arguments: datos));
            },
            child: const Text('Confirmar'),
            style: ButtonStyle(
                shape: WidgetStateProperty.all(RoundedRectangleBorder(
                  side: BorderSide(color: Theme.of(context).primaryColor),
                  borderRadius: BorderRadius.circular(0.0),
                )),
                foregroundColor:
                    WidgetStateProperty.all(Theme.of(context).primaryColor),
                textStyle: WidgetStateProperty.all(
                    Theme.of(context).textTheme.displaySmall))),
      ],
    );
  }
}
