import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:prototahpp/components/endDrawer.dart';
import 'package:prototahpp/util/customUI.dart';

class ConceptosPage extends StatefulWidget {
  const ConceptosPage({super.key});

  @override
  State<ConceptosPage> createState() => _ConceptosPageState();
}

class _ConceptosPageState extends State<ConceptosPage> {
  final _conceptosDB = Hive.box('conceptosDB');
  final List<ConceptoBD> conceptosBDList = [];

  Map<int, Map<String, TextEditingController>> mapaControllers = {};

  void rellenarConceptosBDList() {
    for (int i = 0; i < _conceptosDB.length; i++) {
      mapaControllers[i] = {
        'nombre': TextEditingController(),
        'cantidad': TextEditingController(),
        'unidad': TextEditingController(),
        'precio': TextEditingController(),
        'descr': TextEditingController()
      };

      mapaControllers[i]!['nombre']!.text =
          _conceptosDB.getAt(i)['nombre'] as String;
      mapaControllers[i]!['cantidad']!.text =
          _conceptosDB.getAt(i)['cantidad'].toString();
      mapaControllers[i]!['unidad']!.text =
          _conceptosDB.getAt(i)['unidad'] as String;
      mapaControllers[i]!['precio']!.text =
          NumberFormat.currency(locale: 'es_MX', symbol: '\$')
              .format(_conceptosDB.getAt(i)['precio']);
      mapaControllers[i]!['descr']!.text =
          _conceptosDB.getAt(i)['descr'] as String;

      int indexConcepto = _conceptosDB.getAt(i)['indexConcepto'] as int;

      setState(() {
        conceptosBDList.add(ConceptoBD(
          indexConceptoBD: indexConcepto,
          nombreContr: mapaControllers[i]?['nombre'],
          cantidadContr: mapaControllers[i]?['cantidad'],
          unidadContr: mapaControllers[i]?['unidad'],
          precioContr: mapaControllers[i]?['precio'],
          descrContr: mapaControllers[i]?['descr'],
          onDelete: (context) => deleteConceptoBD(indexConcepto),
        ));
      });
    }
  }

  void addConceptoBD() {
    int indexConcepto = Random().nextInt(10000);

    if (conceptosBDList
        .any((concepto) => concepto.indexConceptoBD == indexConcepto)) {
      indexConcepto = Random().nextInt(10000);
    }

    mapaControllers[conceptosBDList.length] = {
      'nombre': TextEditingController(),
      'cantidad': TextEditingController(),
      'unidad': TextEditingController(),
      'precio': TextEditingController(),
      'descr': TextEditingController()
    };

    setState(() {
      conceptosBDList.add(ConceptoBD(
        indexConceptoBD: indexConcepto,
        nombreContr: mapaControllers[conceptosBDList.length]?['nombre'],
        cantidadContr: mapaControllers[conceptosBDList.length]?['cantidad'],
        unidadContr: mapaControllers[conceptosBDList.length]?['unidad'],
        precioContr: mapaControllers[conceptosBDList.length]?['precio'],
        descrContr: mapaControllers[conceptosBDList.length]?['descr'],
        onDelete: (context) => deleteConceptoBD(indexConcepto),
      ));
    });
  }

  void deleteConceptoBD(int index) {
    setState(() {
      conceptosBDList
          .removeWhere((element) => element.indexConceptoBD == index);
    });
  }

  void guardarCambios() async {
    await _conceptosDB.clear();

    for (int i = 0; i < conceptosBDList.length; i++) {
      _conceptosDB.put(i, {
        'indexConcepto': conceptosBDList[i].indexConceptoBD,
        'nombre': conceptosBDList[i].nombreContr!.text,
        'cantidad': double.parse(conceptosBDList[i].cantidadContr!.text),
        'unidad': conceptosBDList[i].unidadContr!.text,
        'precio': double.parse(conceptosBDList[i]
            .precioContr!
            .text
            .replaceAll(RegExp(r'[^0-9.]'), '')),
        'descr': conceptosBDList[i].descrContr!.text
      });
    }

    Future.delayed(const Duration(milliseconds: 200), () {
      Navigator.pop(context);
      Navigator.pop(context);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    rellenarConceptosBDList();
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
          title: Text('CONCEPTOS',
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
                        return descartarConceptoBDDialog(
                            guardarCambios: guardarCambios);
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
                    children: conceptosBDList,
                  ),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        addConceptoBD();
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

class ConceptoBD extends StatefulWidget {
  final int indexConceptoBD;
  final TextEditingController? nombreContr;
  final TextEditingController? cantidadContr;
  final TextEditingController? unidadContr;
  final TextEditingController? precioContr;
  final TextEditingController? descrContr;
  final Function(BuildContext context) onDelete;

  ConceptoBD({
    super.key,
    required this.indexConceptoBD,
    required this.nombreContr,
    required this.cantidadContr,
    required this.unidadContr,
    required this.precioContr,
    required this.descrContr,
    required this.onDelete,
  });

  @override
  State<ConceptoBD> createState() => _ConceptoBDState();
}

class _ConceptoBDState extends State<ConceptoBD> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    double screenW = MediaQuery.of(context).size.width;
    //double screenH = MediaQuery.of(context).size.height;

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
                              color: Theme.of(context).unselectedWidgetColor),
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

              //**** CANTIDAD Y UNIDAD */
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).shadowColor,
                      ),
                      width: screenW * 0.44,
                      //height: screenH * factorH,
                      child: TextField(
                        style: Theme.of(context).textTheme.labelMedium,
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(RegExp("[0-9\.]"))
                        ],
                        controller: widget.cantidadContr,
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
                          labelText: 'Cantidad',
                          labelStyle: Theme.of(context).textTheme.labelSmall,
                        ),
                      ),
                    ),
                    Spacer(),
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).shadowColor,
                      ),
                      width: screenW * 0.44,
                      //height: screenH * factorH,
                      child: TextField(
                        style: Theme.of(context).textTheme.labelMedium,
                        controller: widget.unidadContr,
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
                          labelText: 'Unidad',
                          labelStyle: Theme.of(context).textTheme.labelSmall,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              //**** PRECIO */
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).shadowColor,
                  ),
                  child: Focus(
                    onFocusChange: (context) {
                      String numberPrecio = widget.precioContr!.text
                          .replaceAll(RegExp(r'[^0-9.]'), '');

                      widget.precioContr!.text =
                          NumberFormat.currency(locale: 'es_MX', symbol: '\$')
                              .format(double.parse(numberPrecio));
                    },
                    child: TextField(
                      style: Theme.of(context).textTheme.labelMedium,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp("[0-9\.]"))
                      ],
                      controller: widget.precioContr,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).unselectedWidgetColor),
                            borderRadius: BorderRadius.circular(0)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).highlightColor),
                            borderRadius: BorderRadius.circular(0)),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0)),
                        labelText: 'Precio unitario',
                        labelStyle: Theme.of(context).textTheme.labelSmall,
                      ),
                      onEditingComplete: () {
                        String numberPrecio = widget.precioContr!.text
                            .replaceAll(RegExp(r'[^0-9.]'), '');

                        widget.precioContr!.text =
                            NumberFormat.currency(locale: 'es_MX', symbol: '\$')
                                .format(double.parse(numberPrecio));
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
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
                    // height:
                    //     isExpanded ? screenH * 0.3 : screenH * 0.06,
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
                      // expands: isExpanded,
                      maxLines: isExpanded ? 5:1,
                      minLines: 1,
                      textAlign: TextAlign.left,
                      //textAlignVertical: TextAlignVertical.top,
                      controller: widget.descrContr,
                      decoration: InputDecoration(
                        isDense: false,
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).unselectedWidgetColor),
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
          ),
        ),
      ),
    );
  }
}
