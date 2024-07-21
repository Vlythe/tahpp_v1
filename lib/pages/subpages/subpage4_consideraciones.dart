import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:prototahpp/util/customUI.dart';

class Page4_Consideraciones extends StatefulWidget {
  final List footnotesList;

  Page4_Consideraciones({super.key, required this.footnotesList});

  @override
  State<Page4_Consideraciones> createState() => _Page4_ConsideracionesState();
}

class _Page4_ConsideracionesState extends State<Page4_Consideraciones> {
  final _footnotesDB = Hive.box('footnotesDB');

  void fillFootnotesList(List footnotesList) {
    print('footnotesList is empty: ${footnotesList.isEmpty}');
    for (int i = 0; i < _footnotesDB.length; i++) {
      footnotesList.add([
        _footnotesDB.getAt(i)['nombre'].toString(),
        _footnotesDB.getAt(i)['descr'],
        false,
        TextEditingController(),
      ]);
    }
  }

  void updateDescr(TextEditingController footnoteController, int index) {
    setState(() {
      widget.footnotesList[index][1] = footnoteController.text;
    });
  }

  void checkBoxChanged(bool? value, int index) {
    setState(() {
      widget.footnotesList[index][2] = !widget.footnotesList[index][2];
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (widget.footnotesList.isEmpty) {
      fillFootnotesList(widget.footnotesList);
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenH = MediaQuery.of(context).size.height;

    return Column(
      children: [
        //********SUBTITULO */
        Center(
            heightFactor: screenH * 0.0020,
            child: Text(
              'CONSIDERACIONES',
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            )),

        //************CONSIDERACIONES */
        Expanded(
          child: ListView.builder(
            itemCount: widget.footnotesList.length,
            itemBuilder: (context, index) {
              return Footnote(
                nombreFoot: widget.footnotesList[index][0],
                descrFoot: widget.footnotesList[index][1],
                index: index,
                isFootChecked: widget.footnotesList[index][2],
                footnoteController: widget.footnotesList[index][3],
                onChanged: (value) => checkBoxChanged(value, index),
                onSave: () =>
                    updateDescr(widget.footnotesList[index][3], index),
              );
            },
          ),
        ),
      ],
    );
  }
}

class Footnote extends StatelessWidget {
  final String nombreFoot;
  final String descrFoot;
  final bool isFootChecked;
  final Function(bool?)? onChanged;
  final TextEditingController footnoteController;
  final int index;
  final Function() onSave;

  Footnote(
      {required this.nombreFoot,
      required this.descrFoot,
      required this.isFootChecked,
      required this.index,
      required this.footnoteController,
      required this.onChanged,
      required this.onSave});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          Row(
            children: [
              Checkbox(
                  fillColor: isFootChecked
                      ? WidgetStateProperty.all(
                          Theme.of(context).dividerColor)
                      : WidgetStateProperty.all(
                          Theme.of(context).shadowColor),
                  checkColor: Theme.of(context).scaffoldBackgroundColor,
                  value: isFootChecked,
                  shape: RoundedRectangleBorder(
                      side: BorderSide(color: Theme.of(context).shadowColor)),
                  onChanged: onChanged),
              Text(
                nombreFoot,
                style: Theme.of(context).textTheme.labelMedium,
                overflow: TextOverflow.ellipsis,
              ),
              Spacer(),
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return myAlertDialog(
                        descripcion: descrFoot,
                        footnoteController: footnoteController,
                        onSave: () {
                          onSave();
                          Navigator.pop(context);
                        },
                        onCancel: () {
                          Navigator.pop(context);
                        },
                      );
                    },
                  );
                },
                child: Icon(Icons.edit_note_sharp,
                    color: Theme.of(context).unselectedWidgetColor),
              ),
              const SizedBox(
                width: 20,
              )
            ],
          ),
          Divider(
            color: Theme.of(context).shadowColor,
            thickness: 1,
          ),
        ],
      ),
    );
  }
}
