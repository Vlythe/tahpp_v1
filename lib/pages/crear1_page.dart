import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:prototahpp/components/conceptos.dart';
import 'package:prototahpp/components/endDrawer.dart';
import 'package:prototahpp/components/route_generator.dart';
import 'package:prototahpp/pages/subpages/subpage1_proyecto.dart';
import 'package:prototahpp/pages/subpages/subpage2_conceptos.dart';
import 'package:prototahpp/pages/subpages/subpage3_honorarios.dart';
import 'package:prototahpp/pages/subpages/subpage4_consideraciones.dart';
import 'package:prototahpp/util/customUI.dart';
import 'package:rive/rive.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Crear1Page extends StatefulWidget {
  @override
  State<Crear1Page> createState() => _Crear1PageState();
}

class _Crear1PageState extends State<Crear1Page>
    with SingleTickerProviderStateMixin {
  final List<Concepto> _conceptosList = [];
  final TextEditingController _nombreProyectoController =
      TextEditingController();
  final TextEditingController _clienteController = TextEditingController();
  final TextEditingController _noCotiController = TextEditingController();
  final TextEditingController _fechaController = TextEditingController();
  final TextEditingController _codigoController = TextEditingController();
  final TextEditingController _totalController = TextEditingController();
  final TextEditingController _honorariosController = TextEditingController();

  Map<int, Map<String, TextEditingController>> mapaControllers = {};
  int _conceptosCount = 0;
  List<bool> listaSeSuma = [];
  double total = 0;

  final List _footnotesList = [];

  final _plantillasDB = Hive.box('plantillasDB');

  int _indexPlantilla = 0;

  bool _hayQueRellenar = true;
  String? tipo;
  int nuevoIndex = 0;
  Map datos = {};

  double beltPage = 0;

  SMIBool? _isBackButtonEnabled;
  bool isBackButtonEnabledBool = false;

  SMINumber? _toReadyPage;
  double toReadyPage = 0;

  final _pageController = PageController(keepPage: true);

  var hoy = DateTime.now();

  bool? vieneDeView = false;

  void addConcepto() {
    int indexConcepto = Random().nextInt(10000);

    if (_conceptosList
        .any((concepto) => concepto.indexConcepto == indexConcepto)) {
      indexConcepto = Random().nextInt(10000);
    }

    mapaControllers[_conceptosCount] = {
      'nombre': TextEditingController(),
      'cantidad': TextEditingController(),
      'precio': TextEditingController(),
      'unidad': TextEditingController(),
      'subtotal': TextEditingController(),
      'descr': TextEditingController(),
    };

    listaSeSuma.add(false);

    setState(() {
      print(
          '******** _conceptosCount es: [$_conceptosCount] y _conceptosList.length es: ${_conceptosList.length}');

      _conceptosList.add(Concepto(
          indexConcepto,
          mapaControllers[_conceptosCount]?['nombre'],
          mapaControllers[_conceptosCount]?['cantidad'],
          mapaControllers[_conceptosCount]?['precio'],
          mapaControllers[_conceptosCount]?['unidad'],
          _conceptosCount,
          listaSeSuma,
          mapaControllers[_conceptosCount]?['subtotal'],
          mapaControllers[_conceptosCount]?['descr'],
          calcularTotal,
          (context) => deleteConcepto(indexConcepto)));
    });

    _conceptosCount++;
  }

  void calcularTotal() {
    total = 0;
    bool hubosuma = false;

    //******Se suman sólo los conceptos indicados */
    if (_conceptosCount > 0) {
      for (int i = 0; i < _conceptosList.length; i++) {
        if (listaSeSuma[i] == true) {
          hubosuma = true;
          String numericString = _conceptosList[i]
              .subtotalController!
              .text
              .replaceAll(RegExp(r'[^0-9.]'), '');
          
          if (numericString.isEmpty) {
            numericString = '0';
          }

          double subtotal = double.parse(numericString);

          total += subtotal;

          String formattedString = NumberFormat.currency(
                  locale: 'es_MX', symbol: '\$', decimalDigits: 2)
              .format(total);
          setState(() {
            _totalController.text = formattedString;
          });
        }
      }
      if (!hubosuma) {
        String formattedString = NumberFormat.currency(
                locale: 'es_MX', symbol: '\$', decimalDigits: 2)
            .format(total);
        setState(() {
          _totalController.text = formattedString;
        });
      }
    }
  }

  //******* deleteConcepto */
  void deleteConcepto(int indexConcepto) {
    setState(() {
      _conceptosList
          .removeWhere((element) => element.indexConcepto == indexConcepto);

      if (_conceptosList.isEmpty) {
        _conceptosCount = 0;
      }
    });
    calcularTotal();
  }

  void rellenarPlantilla(int? _indexPlantilla) {
    //*****Rellenar datos de encabezado */
    _nombreProyectoController.text =
        _plantillasDB.getAt(_indexPlantilla!)['nombreProyecto'];
    _clienteController.text = _plantillasDB.getAt(_indexPlantilla)['cliente'];
    _noCotiController.text = _plantillasDB.getAt(_indexPlantilla)['noCoti'];
    _fechaController.text = _plantillasDB.getAt(_indexPlantilla)['fecha'];
    _codigoController.text = _plantillasDB.getAt(_indexPlantilla)['codigo'];
    _totalController.text =
        _plantillasDB.getAt(_indexPlantilla)['total'].toString();

    //*****Rellenar widgets en _conceptosList */
    for (int i = 0;
        i < _plantillasDB.getAt(_indexPlantilla)['conceptos'].length;
        i++) {
      mapaControllers[_conceptosCount] = {
        'nombre': TextEditingController(),
        'cantidad': TextEditingController(),
        'precio': TextEditingController(),
        'unidad': TextEditingController(),
        'subtotal': TextEditingController(),
        'descr': TextEditingController(),
      };

      mapaControllers[_conceptosCount]!['nombre']!.text = _plantillasDB
          .getAt(_indexPlantilla)['conceptos'][i]['nombreConcepto'] as String;
      mapaControllers[_conceptosCount]!['cantidad']!.text = _plantillasDB
          .getAt(_indexPlantilla)['conceptos'][i]['cantidad']
          .toString();
      mapaControllers[_conceptosCount]!['precio']!.text = _plantillasDB
          .getAt(_indexPlantilla)['conceptos'][i]['precio']
          .toString();
      mapaControllers[_conceptosCount]!['unidad']!.text = _plantillasDB
          .getAt(_indexPlantilla)['conceptos'][i]['unidad'] as String;
      mapaControllers[_conceptosCount]!['subtotal']!.text = _plantillasDB
          .getAt(_indexPlantilla)['conceptos'][i]['subtotal']
          .toString();
      mapaControllers[_conceptosCount]!['descr']!.text = _plantillasDB
          .getAt(_indexPlantilla)['conceptos'][i]['descr'] as String;

      listaSeSuma.insert(_conceptosCount,
          _plantillasDB.getAt(_indexPlantilla)['conceptos'][i]['seSuma']);

      int indexConcepto =
          _plantillasDB.getAt(_indexPlantilla)['conceptos'][i]['indexConcepto'];

      setState(() {
        _conceptosList.add(Concepto(
          indexConcepto,
          mapaControllers[_conceptosCount]?['nombre'],
          mapaControllers[_conceptosCount]?['cantidad'],
          mapaControllers[_conceptosCount]?['precio'],
          mapaControllers[_conceptosCount]?['unidad'],
          _conceptosCount,
          listaSeSuma,
          mapaControllers[_conceptosCount]?['subtotal'],
          mapaControllers[_conceptosCount]?['descr'],
          calcularTotal,
          (context) => deleteConcepto(indexConcepto),
        ));
      });

      _conceptosCount++;
    }

    //*****Rellenar datos de honorarios */
    _honorariosController.text =
        _plantillasDB.getAt(_indexPlantilla)['honorarios'].toString();

    //*****Rellenar datos de footnotes */
    setState(() {
      for (int i = 0;
          i < _plantillasDB.getAt(_indexPlantilla)['footnotes'].length;
          i++) {
        _footnotesList.add([
          _plantillasDB.getAt(_indexPlantilla)['footnotes'][i]['nombre'],
          _plantillasDB.getAt(_indexPlantilla)['footnotes'][i]['descr'],
          _plantillasDB.getAt(_indexPlantilla)['footnotes'][i]
              ['footnoteChecked'],
          TextEditingController()
        ]);
      }
    });
    _hayQueRellenar = false;
  }

  void _changeNextPage() {
    setState(() {
      if (beltPage != 3) {
        beltPage = _pageController.page!.round() + 1;
        _toReadyPage!.value = beltPage;
        _pageController.nextPage(
            duration: Duration(milliseconds: 750),
            curve: Curves.easeInOutQuart);
      }

      if (beltPage != 0) {
        isBackButtonEnabledBool = true;
        _isBackButtonEnabled!.change(isBackButtonEnabledBool);
      }
    });
  }

  void _changePageBackwards() {
    setState(() {
      beltPage = _pageController.page!.round() - 1;
      _toReadyPage!.value = beltPage;
      _pageController.previousPage(
          duration: Duration(milliseconds: 750), curve: Curves.easeInOutQuart);

      if (beltPage == 0) {
        isBackButtonEnabledBool = false;
        _isBackButtonEnabled!.change(isBackButtonEnabledBool);
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    String dia = DateFormat('dd').format(hoy);
    String mes = DateFormat('MM').format(hoy);
    String anio = DateFormat('yyyy').format(hoy);

    _fechaController.text = '$dia/$mes/$anio';

    _honorariosController.text =
        'Una vez aprobado el prespuesto se seguirá la siguiente estructura de pagos:';
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    //******Traer datos de pantalla anterior */
    Object? objDatos = ModalRoute.of(context)!.settings.arguments;
    Map<dynamic, dynamic>? mapaDatos = objDatos as Map<dynamic, dynamic>?;

    tipo = mapaDatos?['tipo'] as String?;
    vieneDeView = mapaDatos?['vieneDeView'] as bool?;

    //if (currentPage == 0) _totalController.text = '0.00';

    //******Convertir datos en int para el index Plantilla si se viene de VER o SELECCIONAR*/
    switch (tipo) {
      case 'editar':
        {
          _indexPlantilla = mapaDatos?['indexPlantilla'] as int;

          if (_hayQueRellenar) {
            rellenarPlantilla(_indexPlantilla);
            calcularTotal();
          }
        }
      case 'duplicar':
        {
          _indexPlantilla = mapaDatos?['indexPlantilla'] as int;

          if (_hayQueRellenar) {
            rellenarPlantilla(_indexPlantilla);
            calcularTotal();
          }

          nuevoIndex = _plantillasDB.length;
        }
      case 'nuevo':
        {
          _indexPlantilla = _plantillasDB.length;
        }
    }

    double bottomBarHeight = MediaQuery.of(context).padding.bottom;

    double screenW = MediaQuery.of(context).size.width;
    double screenH = MediaQuery.of(context).size.height - bottomBarHeight;

    return SafeArea(
      top: false,
      bottom: false,
      child: Scaffold(
        appBar: AppBar(
          title: Text('CREAR', style: Theme.of(context).textTheme.displaySmall),
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
                if (_nombreProyectoController.text.isEmpty &&
                    _clienteController.text.isEmpty &&
                    _noCotiController.text.isEmpty &&
                    _codigoController.text.isEmpty &&
                    _conceptosList.isEmpty) {
                  Navigator.pop(context, true);
                  Navigator.of(context)
                      .push(RouteGenerator.createRouteHomePage());
                } else if (vieneDeView == true) {
                  Navigator.pop(context, true);
                  Navigator.of(context)
                      .push(RouteGenerator.createRouteHomePage());
                } else {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return descartarDialog();
                      });
                }
              }),
              child: IconButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                icon: SvgPicture.asset('assets/backButton.svg'),
                onPressed: () {
                  if (_nombreProyectoController.text.isEmpty &&
                      _clienteController.text.isEmpty &&
                      _noCotiController.text.isEmpty &&
                      _codigoController.text.isEmpty &&
                      _conceptosList.isEmpty) {
                    Navigator.pop(context, true);
                    Navigator.of(context)
                        .push(RouteGenerator.createRouteHomePage());
                  } else if (vieneDeView == true) {
                    Navigator.pop(context, true);
                    Navigator.of(context)
                        .push(RouteGenerator.createRouteHomePage());
                  } else {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return descartarDialog();
                        });
                  }
                },
              ),
            ),
          ),
          actions: const <Widget>[BurgerButton()],
        ),
        body: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              beltPage = index.toDouble();
              if (_pageController.page!.round() == 0) {
                isBackButtonEnabledBool = false;
                _isBackButtonEnabled!.change(isBackButtonEnabledBool);
              } else {
                isBackButtonEnabledBool = true;
                _isBackButtonEnabled!.change(isBackButtonEnabledBool);
              }

              if (index == 3) {
                _toReadyPage!.value = 3;
              } else {
                _toReadyPage!.value = index.toDouble();
              }
            },
            children: [
              Page1_Proyecto(
                  nombreProyectoController: _nombreProyectoController,
                  clienteController: _clienteController,
                  fechaController: _fechaController,
                  noCotiController: _noCotiController,
                  codigoController: _codigoController),
              Page2_Conceptos(
                conceptosList: _conceptosList,
                addConcepto: addConcepto,
              ),
              Page3_Honorarios(honorariosController: _honorariosController),
              Page4_Consideraciones(footnotesList: _footnotesList),
            ]),

        //*******PIE DE PAGINA */
        bottomNavigationBar: Container(
          alignment: Alignment.topCenter,
          width: screenW,
          height: screenH * 0.15,
          padding: EdgeInsets.only(left: 10, right: 10, top: 10),
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Column(
            children: [
              Divider(
                indent: screenW * 0.03,
                endIndent: screenW * 0.03,
                color: Theme.of(context).dividerColor,
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 18.0),
                    child: Text(
                      'SUBTOTAL: ',
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(right: 18.0),
                    child: Text(_totalController.text,
                        style: Theme.of(context).textTheme.displaySmall),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  //***** BackPage Button */
                  GestureDetector(
                    onTap: () {
                      _changePageBackwards();
                    },
                    child: Container(
                        width: 80,
                        height: 50,
                        child: RiveAnimation.asset(
                            "assets/rive/backPageButton.riv", onInit: (art) {
                          _onRiveInitBackPage(art);
                        })),
                  ),

                  //***** Page Belt */

                  SmoothPageIndicator(
                      controller: _pageController,
                      count: 4,
                      effect: ScrollingDotsEffect(
                        dotWidth: 10,
                        dotHeight: 10,
                        dotColor: Theme.of(context).unselectedWidgetColor,
                        activeDotColor: Theme.of(context).highlightColor,
                      ),
                      onDotClicked: (index) {
                        beltPage = index.toDouble();
                        _pageController.animateToPage(index,
                            duration: Duration(milliseconds: 750),
                            curve: Curves.easeInOutQuart);
                        if (index == 0) {
                          isBackButtonEnabledBool = false;
                          _isBackButtonEnabled!.change(isBackButtonEnabledBool);
                        } else {
                          isBackButtonEnabledBool = true;
                          _isBackButtonEnabled!.change(isBackButtonEnabledBool);
                        }

                        if (index == 3) {
                          _toReadyPage!.value = 3;
                        } else {
                          _toReadyPage!.value = index.toDouble();
                        }
                      }),

                  //***** nextPage Button */
                  GestureDetector(
                      onTap: () {
                        _changeNextPage();
                        if (_pageController.page! >= 3) {
                          if (tipo == 'nuevo') {
                            addPlantilla();

                            Map datos = {
                              'indexPlantilla': _indexPlantilla,
                              'vieneDeView': false,
                            };

                            Navigator.of(context).push(
                                RouteGenerator.createRouteViewPdfPage(
                                    const RouteSettings(name: '/viewpdfPage'),
                                    arguments: datos));

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Cotización agregada con éxito.', style: Theme.of(context).textTheme.bodyMedium),
                                backgroundColor: Colors.white,
                              ),
                            );
                          } else if (tipo == 'editar') {
                            updatePlantilla();

                            Map datos = {
                              'indexPlantilla': _indexPlantilla,
                              'vieneDeView': false,
                            };

                            Navigator.of(context).push(
                                RouteGenerator.createRouteViewPdfPage(
                                    const RouteSettings(name: '/viewpdfPage'),
                                    arguments: datos));

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Cotización editada con éxito.', style: Theme.of(context).textTheme.bodyMedium),
                                backgroundColor: Colors.white,
                              ),
                            );
                          } else if (tipo == 'duplicar') {
                            duplicarPlantilla();
                            Map datos = {
                              'indexPlantilla': nuevoIndex,
                              'vieneDeView': false,
                            };

                            Navigator.of(context).push(
                                RouteGenerator.createRouteViewPdfPage(
                                    const RouteSettings(name: '/viewpdfPage'),
                                    arguments: datos));

                            ScaffoldMessenger.of(context).showSnackBar(
                               SnackBar(
                                content:
                                  Text('Cotización duplicada con éxito.', style: Theme.of(context).textTheme.bodyMedium),
                                  backgroundColor: Colors.white
                              ),
                            );
                          }
                        }
                      },
                      child: Container(
                          width: 80,
                          height: 50,
                          child: RiveAnimation.asset(
                              'assets/rive/nextPageButton.riv', onInit: (art) {
                            _onRiveInitNextPage(art);
                          }))),
                ],
              ),
            ],
          ),
        ),
        endDrawer: myEndDrawer(),
      ),
    );
  }

  _onRiveInitBackPage(art) {
    final controller =
        StateMachineController.fromArtboard(art, "backPageButtonSM");

    art.addController(controller!);

    _isBackButtonEnabled = controller.findInput<bool>('isEnabled') as SMIBool?;

    _isBackButtonEnabled!.change(isBackButtonEnabledBool);
  }

  _onRiveInitNextPage(art) {
    final controller =
        StateMachineController.fromArtboard(art, 'State Machine 1');

    art.addController(controller!);

    _toReadyPage = controller.findInput<double>('toReadyPage') as SMINumber?;

    _toReadyPage!.change(toReadyPage);
  }

  void quitarVacios(List<Concepto> _conceptosList) {
    print('**** Entra quitarVacíos****');
    for (int i = 0; i < _conceptosList.length; i++) {
      print(
          '**** _conceptosList[$i]:${_conceptosList[i].nombreController!.text}');

      if (_conceptosList[i].nombreController!.text == '') {
        print('se borra el concepto $i de la lista');
        setState(() {
          _conceptosList.removeAt(i);
        });
      }
    }
  }

  void addPlantilla() {
    print('******* Entra a addPlantilla');
    _plantillasDB.add('');
    _plantillasDB.putAt(_indexPlantilla, {
      'nombreProyecto': _nombreProyectoController.text,
      'cliente': _clienteController.text,
      'noCoti': _noCotiController.text,
      'fecha': _fechaController.text,
      'codigo': _codigoController.text,
      'conceptos': List.generate(_conceptosList.length, (index) {
        return {
          'indexConcepto': _conceptosList[index].indexConcepto,
          'nombreConcepto': _conceptosList[index].nombreController!.text,
          'cantidad': _conceptosList[index].cantidadController!.text,
          'precio': _conceptosList[index].precioController!.text,
          'unidad': _conceptosList[index].unidadController!.text,
          'seSuma': listaSeSuma[index],
          'subtotal': _conceptosList[index].subtotalController!.text.isEmpty ? '' : _conceptosList[index].subtotalController!.text,
          'descr': _conceptosList[index].descrController!.text,
        };
      }),
      'total': total,
      'honorarios': _honorariosController.text,
      'footnotes': List.generate(_footnotesList.length, (index) {
        return {
          'nombre': _footnotesList[index][0],
          'descr': _footnotesList[index][1],
          'footnoteChecked': _footnotesList[index][2],
        };
      }),
    });
  }

  void duplicarPlantilla() {
    print('******* Entra a duplicarPlantilla()');
    _plantillasDB.add('');
    _plantillasDB.putAt(nuevoIndex, {
      'nombreProyecto': _nombreProyectoController.text,
      'cliente': _clienteController.text,
      'noCoti': _noCotiController.text,
      'fecha': _fechaController.text,
      'codigo': _codigoController.text,
      'conceptos': List.generate(_conceptosList.length, (index) {
        return {
          'indexConcepto': _conceptosList[index].indexConcepto,
          'nombreConcepto': _conceptosList[index].nombreController!.text,
          'cantidad': _conceptosList[index].cantidadController!.text,
          'precio': _conceptosList[index].precioController!.text,
          'unidad': _conceptosList[index].unidadController!.text,
          'seSuma': listaSeSuma[index],
          'subtotal': _conceptosList[index].subtotalController!.text.isEmpty ? '' : _conceptosList[index].subtotalController!.text,
          'descr': _conceptosList[index].descrController!.text,
        };
      }),
      'total': total,
      'honorarios': _honorariosController.text,
      'footnotes': List.generate(_footnotesList.length, (index) {
        return {
          'nombre': _footnotesList[index][0],
          'descr': _footnotesList[index][1],
          'footnoteChecked': _footnotesList[index][2],
        };
      }),
    });
  }

  void updatePlantilla() {
    print('entra a updatePlantilla');
    _plantillasDB.putAt(_indexPlantilla, {
      'nombreProyecto': _nombreProyectoController.text,
      'cliente': _clienteController.text,
      'noCoti': _noCotiController.text,
      'fecha': _fechaController.text,
      'codigo': _codigoController.text,
      'conceptos': List.generate(_conceptosList.length, (index) {
        return {
          'indexConcepto': _conceptosList[index].indexConcepto,
          'nombreConcepto': _conceptosList[index].nombreController!.text,
          'cantidad': _conceptosList[index].cantidadController!.text,
          'precio': _conceptosList[index].precioController!.text,
          'unidad': _conceptosList[index].unidadController!.text,
          'seSuma': listaSeSuma[index],
          'subtotal': _conceptosList[index].subtotalController!.text.isEmpty ? '' : _conceptosList[index].subtotalController!.text,
          'descr': _conceptosList[index].descrController!.text,
        };
      }),
      'total': total,
      'honorarios': _honorariosController.text,
      'footnotes': List.generate(_footnotesList.length, (index) {
        return {
          'nombre': _footnotesList[index][0],
          'descr': _footnotesList[index][1],
          'footnoteChecked': _footnotesList[index][2],
        };
      }),
    });
  }
}
