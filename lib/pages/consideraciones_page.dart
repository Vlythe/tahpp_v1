import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive/hive.dart';
import 'package:prototahpp/components/endDrawer.dart';
import 'package:prototahpp/util/customUI.dart';

class ConsideracionesPage extends StatefulWidget {
  const ConsideracionesPage({super.key});

  @override
  State<ConsideracionesPage> createState() => _ConsideracionesPageState();
}

class _ConsideracionesPageState extends State<ConsideracionesPage> {
  final _footnotesDB = Hive.box('footnotesDB');
  final List<FootnoteDB> footnotesBDList = [];

  Map<int, Map<String, TextEditingController>> mapaControllers = {};

  void rellenarFootnoteBDList() {
    for (int i = 0; i < _footnotesDB.length; i++) {
      mapaControllers[i] = {
        'nombre': TextEditingController(text: _footnotesDB.getAt(i)['nombre']),
        'descr': TextEditingController(text: _footnotesDB.getAt(i)['descr']),
      };

      int indexFoot = _footnotesDB.getAt(i)['indexFoot'] as int;

      setState(() {
        footnotesBDList.add(FootnoteDB(
          indexFoot: indexFoot,
          nombreContr: mapaControllers[i]!['nombre'],
          descrContr: mapaControllers[i]!['descr'],
          onDelete: (context) => deleteFootnoteDB(indexFoot),
        ));
      });
    }
  }

  void addFootnoteDB() {
    int indexFoot = Random().nextInt(10000);

    if (footnotesBDList.any((concepto) => concepto.indexFoot == indexFoot)) {
      indexFoot = Random().nextInt(10000);
    }

    mapaControllers[footnotesBDList.length] = {
      'nombre': TextEditingController(),
      'descr': TextEditingController()
    };

    setState(() {
      footnotesBDList.add(FootnoteDB(
        indexFoot: indexFoot,
        nombreContr: mapaControllers[footnotesBDList.length]?['nombre'],
        descrContr: mapaControllers[footnotesBDList.length]?['descr'],
        onDelete: (context) => deleteFootnoteDB(indexFoot),
      ));
    });
  }

  void deleteFootnoteDB(int indexFoot) {
    setState(() {
      footnotesBDList.removeWhere((element) => element.indexFoot == indexFoot);
    });
  }

  void guardarCambios() async {
    await _footnotesDB.clear();

    for (int i = 0; i < footnotesBDList.length; i++) {
      _footnotesDB.put(i, {
        'indexFoot': footnotesBDList[i].indexFoot,
        'nombre': footnotesBDList[i].nombreContr!.text,
        'descr': footnotesBDList[i].descrContr!.text
      });
    }

    Future.delayed(const Duration(milliseconds: 500), () {
      Navigator.pop(context);
      Navigator.pop(context);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    rellenarFootnoteBDList();
  }

  @override
  Widget build(BuildContext context) {
    double screenH = MediaQuery.of(context).size.height;
    double screenW = MediaQuery.of(context).size.width;
    return SafeArea(
      top: false,
      bottom: false,
      child: Scaffold(
        appBar: AppBar(
          title: Text('CONSIDERACIONES',
              style: Theme.of(context).textTheme.displaySmall),
          centerTitle: true,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          shadowColor: Colors.transparent,
          surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
          automaticallyImplyLeading: false,
          elevation: 0,
          leading: Builder(
            builder: (context) => PopScope(
              canPop: false,
              onPopInvoked: ((didPop) {
                if (didPop) {
                  return;
                }
                showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return descartarConceptoBDDialog(
                            guardarCambios: guardarCambios);
                      });
              }),
              child: IconButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                icon: SvgPicture.asset('assets/backButton.svg'),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return descartarConceptoBDDialog(guardarCambios: guardarCambios);
                      });
                },
              ),
            ),
          ),
          actions: const <Widget>[BurgerButton()],
        ),
        body: Column(
          children: [
            //************CONCEPTOS */
            Expanded(
              child: ListView(
                children: [
                  const SizedBox(height: 5),
                  Column(
                    children: footnotesBDList,
                  ),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        addFootnoteDB();
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
        ),
        endDrawer: myEndDrawer(),
      ),
    );
  }
}

class FootnoteDB extends StatefulWidget {
  final int indexFoot;
  final TextEditingController? nombreContr;
  final TextEditingController? descrContr;
  final Function(BuildContext context)? onDelete;

  const FootnoteDB(
      {required this.indexFoot,
      required this.nombreContr,
      required this.descrContr,
      required this.onDelete,
      super.key});

  @override
  State<FootnoteDB> createState() => _FootnoteDBState();
}

class _FootnoteDBState extends State<FootnoteDB> {
  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    //double screenH = MediaQuery.of(context).size.height;
    double screenW = MediaQuery.of(context).size.width;
    //double factorH = 0.05;
    return Slidable(
      endActionPane: ActionPane(
        motion: StretchMotion(),
        children: [
          SlidableAction(
            icon: Icons.delete_sharp,
            backgroundColor: Theme.of(context).highlightColor,
            onPressed: widget.onDelete,
          ),
        ],
      ),
      child: Center(
          child: SizedBox(
              width: screenW * 0.9,
              child: Column(
                children: [
                  //**** NOMBRE DE CONCEPTO */
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0, top: 8.0),
                    child: Container(
                      decoration:
                          BoxDecoration(color: Theme.of(context).shadowColor),
                      width: screenW * 0.9,
                      //height: screenH * factorH,
                      child: TextField(
                        style: Theme.of(context).textTheme.labelMedium,
                        controller: widget.nombreContr,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color:
                                      Theme.of(context).unselectedWidgetColor),
                              borderRadius: BorderRadius.circular(0)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).highlightColor),
                              borderRadius: BorderRadius.circular(0)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(0)),
                          labelText: 'Nombre de concepto',
                          labelStyle: Theme.of(context).textTheme.labelSmall,
                        ),
                      ),
                    ),
                  ),

                  //**** DESCRIPCION */
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Focus(
                      onFocusChange: (hasFocus) {
                        if (!hasFocus) {
                          setState(() {
                            isExpanded = false;
                          });
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).shadowColor,
                        ),
                        // height: isExpanded
                        //     ? screenH * 0.2
                        //     : screenH * (factorH + 0.01),
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
                              isExpanded = false;
                              FocusManager.instance.primaryFocus?.unfocus();
                            });
                          },
                          onTapOutside: (PointerDownEvent event) {
                            setState(() {
                              isExpanded = false;
                              FocusManager.instance.primaryFocus?.unfocus();
                            });
                          },
                          //expands: isExpanded,
                          maxLines: isExpanded ? 5:1,
                          minLines: 1,
                          textAlign: TextAlign.left,
                          textAlignVertical: TextAlignVertical.top,
                          controller: widget.descrContr,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .unselectedWidgetColor),
                                borderRadius: BorderRadius.circular(0)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).highlightColor),
                                borderRadius: BorderRadius.circular(0)),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(0)),
                            labelText: 'Descripción',
                            labelStyle: Theme.of(context).textTheme.labelSmall,
                          ),
                        ),
                      ),
                    ),
                  ),

                  //**** DIVIDER */
                  Divider(color: Theme.of(context).dividerColor, thickness: 1),
                ],
              ))),
    );
  }
}
