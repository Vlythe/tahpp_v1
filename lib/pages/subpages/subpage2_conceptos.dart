import 'package:flutter/material.dart';
import 'package:prototahpp/components/conceptos.dart';

class Page2_Conceptos extends StatefulWidget {
  final List<Concepto> conceptosList;
  final Function addConcepto;

  Page2_Conceptos({required this.conceptosList, required this.addConcepto});

  @override
  State<Page2_Conceptos> createState() => _Page2_ConceptosState();
}

class _Page2_ConceptosState extends State<Page2_Conceptos> {

    @override
    Widget build(BuildContext context) {
      double screenH = MediaQuery.of(context).size.height;
      double screenW = MediaQuery.of(context).size.width;

      return Column(
        children: [
          //********SUBTITULO */
          Center(
              heightFactor: screenH * 0.0020,
              child: Text(
                'CONCEPTOS',
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              )),

          //************CONCEPTOS */
          Expanded(
            child: ListView(
              children: [
                const SizedBox(height: 5),
                Column(
                  children: widget.conceptosList,
                ),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      widget.addConcepto();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        borderRadius: BorderRadius.circular(0),
                      ),
                      height: screenH * 0.05,
                      width: screenW * 0.3,
                      child: Icon(
                        Icons.add_sharp,
                        color: Theme.of(context).dividerColor,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      );
    }
  }
