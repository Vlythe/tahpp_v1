import 'package:flutter/material.dart';
import 'package:prototahpp/components/duplicarAlertDialog.dart';
import 'package:prototahpp/components/route_generator.dart';

class Plantilla extends StatefulWidget {
  final int indexPlantilla;
  final String nombreProyecto;
  final String fecha;
  final String total;

  const Plantilla(
    this.indexPlantilla, 
    this.nombreProyecto, 
    this.fecha,
    this.total,
    {Key? key})
      : super(key: key);
  @override
  State<Plantilla> createState() => _PlantillaState();
}

class _PlantillaState extends State<Plantilla> {
  final TextEditingController nombrePlantController = TextEditingController();
  final TextEditingController fechaPlantController = TextEditingController();
  final TextEditingController totalPlantController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nombrePlantController.text =
        widget.nombreProyecto == ''
            ? '(Sin nombre)'
            : widget.nombreProyecto;
    fechaPlantController.text =
        widget.fecha;
    totalPlantController.text =
        widget.total;
  }

  @override
  Widget build(BuildContext context) {
    double screenW = MediaQuery.of(context).size.width;
    double screenH = MediaQuery.of(context).size.height;
    double factorH = 0.05;

    return Center(
        child: Container(
            width: screenW * .9,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                //********FECHA Y TOTAL DE PLANTILLA */
                GestureDetector(
                  onTap: () {
                    Map datos = {
                      'indexPlantilla': widget.indexPlantilla,
                      'vieneDeView': false,
                    };

                    Navigator.of(context).push(
                        RouteGenerator.createRouteViewPdfPage2(
                            const RouteSettings(name: '/viewpdfPage2'),
                            arguments: datos));
                  },
                  child: Row(
                    children: [
                      //********FECHA */
                      Padding(
                        padding: const EdgeInsets.only(left: 16, right: 16),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.transparent),
                            borderRadius: BorderRadius.circular(0),
                          ),
                          alignment: Alignment.centerLeft,
                          width: screenW * 0.3,
                          height: screenH * factorH,
                          child: Text(fechaPlantController.text,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(
                                      fontSize: 20,
                                      color: Theme.of(context)
                                          .unselectedWidgetColor)),
                        ),
                      ),

                      Spacer(),

                      //********TOTAL */
                      Padding(
                        padding: const EdgeInsets.only(left: 16, right: 28),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.transparent),
                            borderRadius: BorderRadius.circular(0),
                          ),
                          alignment: Alignment.centerRight,
                          width: screenW * 0.4,
                          height: screenH * factorH,
                          child: Text(
                            '\$ ' + totalPlantController.text,
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                    fontSize: 20,
                                    color: Theme.of(context)
                                        .unselectedWidgetColor),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                //********Nombre y botón de duplicar */

                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 16, right: 16, bottom: 0.0),
                      child: GestureDetector(
                        onTap: () {
                          Map datos = {
                            'indexPlantilla': widget.indexPlantilla,
                            'vieneDeView': false,
                          };

                          Navigator.of(context).push(
                              RouteGenerator.createRouteViewPdfPage2(
                                  const RouteSettings(name: '/viewpdfPage2'),
                                  arguments: datos));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.transparent),
                            borderRadius: BorderRadius.circular(0),
                          ),
                          alignment: Alignment.centerLeft,
                          width: screenW * 0.5,
                          height: screenH * factorH,
                          child: Text(nombrePlantController.text,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(fontSize: 20)),
                        ),
                      ),
                    ),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(left: 16, bottom: 0.0),
                      child: Container(
                        width: screenW * 0.25,
                        height: screenH * 0.04,
                        child: GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return DuplicarAlertDialog(
                                    widget.indexPlantilla);
                              },
                            );
                          },
                          child: Icon(Icons.copy_sharp,
                              color: Theme.of(context).unselectedWidgetColor),
                        ),
                      ),
                    ),
                  ],
                ),
                Divider(color: Theme.of(context).dividerColor),
              ],
            )));
  }
}
