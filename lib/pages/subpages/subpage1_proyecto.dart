import 'package:flutter/material.dart';

class Page1_Proyecto extends StatelessWidget {
  final TextEditingController nombreProyectoController;
  final TextEditingController clienteController;
  final TextEditingController noCotiController;
  final TextEditingController fechaController;
  final TextEditingController codigoController;

  Page1_Proyecto(
      {required this.nombreProyectoController,
      required this.clienteController,
      required this.noCotiController,
      required this.fechaController,
      required this.codigoController});

  @override
  Widget build(BuildContext context) {
    double screenW = MediaQuery.of(context).size.width;
    double screenH = MediaQuery.of(context).size.height;
    double factorH = 0.06;

    return Column(
      children: [
        //********SUBTITULO */
        Center(
            heightFactor: screenH * 0.0020,
            child: Text(
              'PROYECTO',
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            )),
        // List of widgets
        Expanded(
          child: ListView(
            children: [
              //************HEADER */
              Center(
                child: Container(
                    width: screenW * .9,
                    //height: screenH * 0.2,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.transparent)),
                    child: Column(
                      children: [
                        //********Nombre del proyecto */
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0, top: 4.0),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Theme.of(context).shadowColor),
                            height: screenH * factorH,
                            child: TextField(
                              style: Theme.of(context).textTheme.displaySmall,
                              controller: nombreProyectoController,
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context)
                                            .unselectedWidgetColor),
                                    borderRadius: BorderRadius.circular(0)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color:
                                            Theme.of(context).highlightColor),
                                    borderRadius: BorderRadius.circular(0)),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(0)),
                                labelText: 'Nombre del proyecto',
                                labelStyle:
                                    Theme.of(context).textTheme.labelSmall,
                              ),
                            ),
                          ),
                        ),

                        //********Cliente del proyecto */
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Theme.of(context).shadowColor),
                            height: screenH * factorH,
                            child: TextField(
                              style: Theme.of(context).textTheme.displaySmall,
                              controller: clienteController,
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context)
                                            .unselectedWidgetColor),
                                    borderRadius: BorderRadius.circular(0)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color:
                                            Theme.of(context).highlightColor),
                                    borderRadius: BorderRadius.circular(0)),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(0)),
                                labelText: 'Cliente',
                                labelStyle:
                                    Theme.of(context).textTheme.labelSmall,
                              ),
                            ),
                          ),
                        ),

                        //********No. de coti*/
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Theme.of(context).shadowColor),
                            height: screenH * factorH,
                            child: TextField(
                              style: Theme.of(context).textTheme.displaySmall,
                              controller: noCotiController,
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context)
                                            .unselectedWidgetColor),
                                    borderRadius: BorderRadius.circular(0)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color:
                                            Theme.of(context).highlightColor),
                                    borderRadius: BorderRadius.circular(0)),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(0)),
                                labelText: 'No. de coti.',
                                labelStyle:
                                    Theme.of(context).textTheme.labelSmall,
                              ),
                            ),
                          ),
                        ),

                        //********Fecha*/
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Theme.of(context).shadowColor),
                            height: screenH * factorH,
                            child: TextField(
                              style: Theme.of(context).textTheme.displaySmall,
                              controller: fechaController,
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context)
                                            .unselectedWidgetColor),
                                    borderRadius: BorderRadius.circular(0)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color:
                                            Theme.of(context).highlightColor),
                                    borderRadius: BorderRadius.circular(0)),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(0)),
                                labelText: 'Fecha',
                                labelStyle:
                                    Theme.of(context).textTheme.labelSmall,
                              ),
                            ),
                          ),
                        ),

                        //********Código del proyecto */

                        Padding(
                          padding: const EdgeInsets.only(bottom: 0.0),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Theme.of(context).shadowColor),
                            height: screenH * factorH,
                            child: TextField(
                              style: Theme.of(context).textTheme.displaySmall,
                              controller: codigoController,
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context)
                                            .unselectedWidgetColor),
                                    borderRadius: BorderRadius.circular(0)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color:
                                            Theme.of(context).highlightColor),
                                    borderRadius: BorderRadius.circular(0)),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(0)),
                                labelText: 'Código de proyecto',
                                labelStyle:
                                    Theme.of(context).textTheme.labelSmall,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )),
              ),
            ],
          ),
        ),
      ],
    );
  }
}