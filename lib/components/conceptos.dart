import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:rive/rive.dart';
import 'package:intl/intl.dart';


class Concepto extends StatefulWidget {
  final int indexConcepto;
  final int seSuma;
  final List<bool> listaSeSuma;
  final TextEditingController? nombreController;
  final TextEditingController? cantidadController;
  final TextEditingController? precioController;
  final TextEditingController? unidadController;
  final TextEditingController? descrController;
  final TextEditingController? subtotalController;
  final VoidCallback calcularTotal;
  final Function(BuildContext context) deleteConcepto;

  Concepto(
      this.indexConcepto,
      this.nombreController,
      this.cantidadController,
      this.precioController,
      this.unidadController,
      this.seSuma,
      this.listaSeSuma,
      this.subtotalController,
      this.descrController,
      this.calcularTotal,
      this.deleteConcepto,
      {Key? key})
      : super(key: key);

  @override
  State<Concepto> createState() => _ConceptoState();
}

class _ConceptoState extends State<Concepto> {
  int popMenuIndex = 0;
  List<PopupMenuEntry<int>> popMenuItems = [];
  final _conceptosDB = Hive.box('conceptosDB');
  bool isExpanded = false;
  SMIBool? _input;
  bool toggle1 = false;

  void addConceptosAPopUp() {
    for (var i = 0; i < _conceptosDB.length; i++) {
      popMenuItems.add(
        PopupMenuItem(
          labelTextStyle: WidgetStateProperty.all<TextStyle>(TextStyle(
            overflow: TextOverflow.ellipsis,
            color: Colors.black,
            fontSize: 18,
            fontFamily: 'Baskerville',
          )),
          textStyle: TextStyle(overflow: TextOverflow.ellipsis, fontSize: 3),
          value: i,
          child: Row(
            children: [
              Text(
                  _conceptosDB.getAt(i)['nombre'], 
                  ),
              Spacer(),
              Text('\$' +
                  _conceptosDB.getAt(i)['precio'].toString() +
                  ' ' +
                  _conceptosDB.getAt(i)['unidad'],
                  ),
            ],
          ),
        ),
      );
      popMenuItems.add(
        PopupMenuItem(
          height: 7,
          enabled: false,
          child: Container(
            height: 7,
            margin: EdgeInsets.symmetric(horizontal: 2),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(width: 0.5, color: Colors.grey), //
              ),
            ),
          ),
        ),
      );
    }
  }

  void calcularSubtotal() {
    try {
      double precio = double.parse(
          widget.precioController!.text.replaceAll(RegExp(r'[^0-9.]'), ''));

      double subtotal = double.parse(widget.cantidadController!.text) * precio;

      String formattedSubtotal =
          NumberFormat.currency(locale: 'es_MX', symbol: '\$').format(subtotal);

      widget.subtotalController?.text = formattedSubtotal;
    } catch (e) {
      print('error en calcularSubtotal: ' + e.toString());
      widget.subtotalController?.text =
          'Error en cantidades: revisar datos ingresados.';
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    addConceptosAPopUp();
    toggle1 = widget.listaSeSuma[widget.seSuma];
  }

  @override
  Widget build(BuildContext context) {
    double screenW = MediaQuery.of(context).size.width;
    double screenH = MediaQuery.of(context).size.height;
    double factorH = 0.0625;

    return Slidable(
      endActionPane: ActionPane(
        motion: StretchMotion(),
        children: [
          SlidableAction(
            icon: Icons.delete_sharp,
            backgroundColor: Theme.of(context).highlightColor,
            onPressed: widget.deleteConcepto,
          ),
        ],
      ),
      child: Center(
        child: SizedBox(
          width: screenW * 0.9,
          //height: screenH * 0.245,

          child: Column(
            children: [
              //********NOMBRE DEL CONCEPTO */
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  children: [
                    Container(
                      decoration:
                          BoxDecoration(color: Theme.of(context).shadowColor),
                      width: screenW * 0.7,
                     
                      //height: screenH * factorH,
                      child: TextField(
                        onTap: () {
                          setState(() {
                            isExpanded = false;
                          });
                        },
                        style: Theme.of(context).textTheme.labelMedium,
                        controller: widget.nombreController,
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
                    Spacer(),
                    Expanded(
                      flex: 10,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).shadowColor,
                          border: Border.all(
                              color: Theme.of(context).unselectedWidgetColor),
                        ),
                        width: screenW * 0.185,
                        
                        //height: screenH * factorH,
                        child: PopupMenuButton(
                            offset: Offset(1, -2),
                            surfaceTintColor: Colors.white,
                            constraints:
                                BoxConstraints.tightFor(width: screenW * 0.9),
                            position: PopupMenuPosition.over,
                            elevation: 10,
                            shadowColor: Colors.black,
                            shape: const RoundedRectangleBorder(
                                side: BorderSide(color: Colors.grey, width: 2.0),
                                borderRadius: BorderRadius.zero),
                            icon: SvgPicture.asset('assets/arrowDropdown.svg'),
                            itemBuilder: (context) => popMenuItems,
                            onOpened: () {
                              setState(() {
                                isExpanded = false;
                              });
                            },
                            onSelected: (value) {
                              widget.listaSeSuma[widget.seSuma] = true;
                              toggle1 = widget.listaSeSuma[widget.seSuma];
                              _input?.change(toggle1);
                              widget.nombreController!.text =
                                  _conceptosDB.getAt(value)['nombre'];
                              widget.cantidadController!.text = _conceptosDB
                                  .getAt(value)['cantidad']
                                  .toString();
                              widget
                                  .precioController!.text = NumberFormat.currency(
                                      locale: 'es_MX', symbol: '\$')
                                  .format(_conceptosDB.getAt(value)['precio']);
                              widget.unidadController!.text =
                                  _conceptosDB.getAt(value)['unidad'];
                              widget.descrController!.text =
                                  _conceptosDB.getAt(value)['descr'];
                              widget.subtotalController?.text =
                                  NumberFormat.currency(
                                          locale: 'es_MX', symbol: '\$')
                                      .format(
                                          _conceptosDB.getAt(value)['cantidad'] *
                                              _conceptosDB.getAt(value)['precio'])
                                      .toString();
                              widget.calcularTotal();
                            }),
                      ),
                    ),
                  ],
                ),
              ),
          
              //********CANTIDAD Y UNIDAD */
          
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).shadowColor,
                      ),
                      width: screenW * 0.44,
                      
                      //height: screenH * factorH,
                      child: Focus(
                        onFocusChange: (hasFocus) {
                          if (!hasFocus) {
                            calcularSubtotal();
                            widget.calcularTotal();
                          }
                        },
                        child: TextField(
                          style: Theme.of(context).textTheme.labelMedium,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(RegExp("[0-9\.]"))
                          ],
                          controller: widget.cantidadController,
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
                            labelText: 'Cantidad',
                            labelStyle: Theme.of(context).textTheme.labelSmall,
                          ),
                          onEditingComplete: () {
                            calcularSubtotal();
                            widget.calcularTotal();
                            FocusManager.instance.primaryFocus?.unfocus();
                          },
                          onTap: () {
                            setState(() {
                              isExpanded = false;
                            });
                          },
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
                        onTap: () {
                          setState(() {
                            isExpanded = false;
                          });
                        },
                        style: Theme.of(context).textTheme.labelMedium,
                        controller: widget.unidadController,
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
          
              //********PRECIO Y TOGGLE SE SUMA */
          
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).shadowColor,
                      ),
                      width: screenW * 0.44,
                     //height: screenH * factorH,
                      child: Focus(
                        onFocusChange: (hasFocus) {
                          if (!hasFocus) {
                            calcularSubtotal();
                            widget.calcularTotal();
                            widget.precioController!.text =
                                NumberFormat.currency(
                                        locale: 'es_MX', symbol: '\$')
                                    .format(double.parse(
                                        widget.precioController!.text));
                          }
                        },
                        child: TextField(
                          style: Theme.of(context).textTheme.labelMedium,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(RegExp("[0-9\.]"))
                          ],
                          controller: widget.precioController,
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
                            labelText: 'Precio unitario',
                            labelStyle: Theme.of(context).textTheme.labelSmall,
                          ),
                          onEditingComplete: () {
                            calcularSubtotal();
                            widget.calcularTotal();
                            FocusManager.instance.primaryFocus?.unfocus();
                          },
                          onTap: () {
                            setState(() {
                              isExpanded = false;
                            });
                          },
                        ),
                      ),
                    ),
                    Spacer(flex: 4),
                    Text('Sumar',
                        style: Theme.of(context).textTheme.labelMedium),
                    Spacer(flex: 2),
                    Container(
                      width: screenW * 0.175,
                      height: screenH * factorH,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            isExpanded = false;
                            toggle1 = !toggle1;
                            _input?.change(toggle1);
                            widget.listaSeSuma[widget.seSuma] = toggle1;
                            widget.calcularTotal();
                          });
                        },
                        onHorizontalDragEnd: (details) => setState(() {
                          isExpanded = false;
                          toggle1 = !toggle1;
                          _input?.change(toggle1);
                          widget.listaSeSuma[widget.seSuma] = toggle1;
                          widget.calcularTotal();
                        }),
                        child: RiveAnimation.asset('assets/rive/tahswitch.riv',
                            onInit: (art) {
                          _onRiveInit(art);
                        }),
                      ),
                    ),
                    Spacer(flex: 3),
                  ],
                ),
              ),
          
              //********SUBTOTAL */
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).shadowColor,
                  ),
                  //height: screenH * factorH,
                  child: TextField(
                    onTap: () {
                      setState(() {
                        isExpanded = false;
                      });
                    },
                    onEditingComplete: () {
                      FocusManager.instance.primaryFocus?.unfocus();
                      widget.calcularTotal();
                    },
                    style: Theme.of(context).textTheme.labelMedium,
                    controller: widget.subtotalController,
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
                      labelText: 'Subtotal',
                      labelStyle: Theme.of(context).textTheme.labelSmall,
                    ),
                  ),
                ),
              ),
          
              //********DESCRIPCION */
          
              Padding(
                padding: const EdgeInsets.only(bottom: 0.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).shadowColor,
                  ),
                  //height: isExpanded ? screenH * 0.2 : screenH * 0.07,
                  child: TextField(
                    
                    enableInteractiveSelection: true,
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
                    controller: widget.descrController,
                    decoration: InputDecoration(
                      
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).unselectedWidgetColor),
                          borderRadius: BorderRadius.circular(0)),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Theme.of(context).highlightColor),
                          borderRadius: BorderRadius.circular(0)),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(0)),
                      labelText: 'Descripción',
                      labelStyle: Theme.of(context).textTheme.labelSmall,
                    ),
                  ),
                ),
              ),
          
              //********DIVIDER */
              Divider(color: Theme.of(context).dividerColor),
            ],
          ),
        ),
      ),
    );
  }

  _onRiveInit(Artboard artboard) {
    final switchController =
        StateMachineController.fromArtboard(artboard, 'SM2');
    artboard.addController(switchController!);
    _input = switchController.findInput<bool>('Toggle1') as SMIBool?;

    _input?.change(toggle1);
  }
}
