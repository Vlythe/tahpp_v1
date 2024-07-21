import 'package:flutter/material.dart';

class Page3_Honorarios extends StatefulWidget {
  final TextEditingController honorariosController;

  Page3_Honorarios({super.key, required this.honorariosController});

  @override
  State<Page3_Honorarios> createState() => _Page3_HonorariosState();
}

class _Page3_HonorariosState extends State<Page3_Honorarios> {
  bool isExpanded = true;
  double factorH = 0.06;

  @override
  Widget build(BuildContext context) {
    double screenH = MediaQuery.of(context).size.height;

    return Column(
      children: [
        //********SUBTITULO */
        Center(
            heightFactor: screenH * 0.0020,
            child: Text(
              'HONORARIOS',
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            )),

        Padding(
          padding: const EdgeInsets.only(right: 16, left: 16, bottom: 0.0),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).shadowColor,
            ),
            height: screenH * 0.4,
            child: TextField(
              keyboardType: TextInputType.multiline,
              style: Theme.of(context).textTheme.labelMedium,
              onTap: () {
                setState(() {
                  isExpanded = true;
                });
              },
              onEditingComplete: () {
                setState(() {

                  FocusManager.instance.primaryFocus?.unfocus();
                });
              },
              onTapOutside: (PointerDownEvent event) {
                setState(() {
                  FocusManager.instance.primaryFocus?.unfocus();
                });
              },
              expands: true,
              textAlign: TextAlign.left,
              textAlignVertical: TextAlignVertical.top,
              maxLines: null,
              controller: widget.honorariosController,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).unselectedWidgetColor),
                    borderRadius: BorderRadius.circular(0)),
                focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Theme.of(context).highlightColor),
                    borderRadius: BorderRadius.circular(0)),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(0)),
                labelText: 'Descripción de honorarios',
                labelStyle: Theme.of(context).textTheme.labelSmall,
              ),
            ),
          ),
        ),
      ],
    );
  }
}