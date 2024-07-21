import 'package:flutter/material.dart';
import 'package:prototahpp/components/duplicarAlertDialog.dart';

class PlantillaSimp extends StatefulWidget {
  final int indexPlantilla;
  final String nombreProyecto;
  final String fecha;
  final String total;
  const PlantillaSimp(
    this.indexPlantilla,
    this.nombreProyecto,
    this.fecha,
    this.total,
    {Key? key}) : super(key: key);
  @override
  _PlantillaSimpState createState() => _PlantillaSimpState();
}

class _PlantillaSimpState extends State<PlantillaSimp> {
  final TextEditingController nombrePlantController = TextEditingController();
  final TextEditingController fechaPlantController = TextEditingController();
  final TextEditingController totalPlantController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nombrePlantController.text =
        widget.nombreProyecto == '' ? '(Sin nombre)' : widget.nombreProyecto;
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

    return GestureDetector(
        onTap: () {
           showDialog(
              context: context,
              builder: (BuildContext context) {
                return DuplicarAlertDialog(widget.indexPlantilla);
              },
            );
        },
        child: Center(
          child: Container(
              width: screenW * .9,
              child: Column(
                children: [
                  //********FECHA Y TOTAL DE PLANTILLA */
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 0.0),
                        child: Container(
                          padding: EdgeInsets.only(left: 8.0),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.transparent),
                            borderRadius: BorderRadius.circular(0),
                          ),
                          alignment: Alignment.centerLeft,
                          width: screenW * 0.4,
                          height: screenH * factorH,
                          child: Text(fechaPlantController.text,
                              style: Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: 20, color: Theme.of(context).unselectedWidgetColor)),
                        ),
                      ),
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 0.0),
                        child: Container(
                          padding: EdgeInsets.only(right: 8.0),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.transparent),
                            borderRadius: BorderRadius.circular(0),
                          ),
                          alignment: Alignment.centerRight,
                          width: screenW * 0.4,
                          height: screenH * factorH,
                          child: Text('\$ ' + totalPlantController.text,
                              style: Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: 20, color: Theme.of(context).unselectedWidgetColor)),
                        ),
                      ),
                    ],
                  ),

                  //********Nombre */
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 0.0),
                      child: Container(
                        padding: EdgeInsets.only(left: 8.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(0),
                        ),
                        alignment: Alignment.centerLeft,
                        width: screenW * 0.9,
                        height: screenH * factorH,
                        child: Text(nombrePlantController.text,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 20)),
                      ),
                    ),
                  ),

                  //********Divider */
                  Divider(color: Theme.of(context).highlightColor),
                ],
              )),
        ));
  }
}
