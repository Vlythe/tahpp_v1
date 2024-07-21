import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:prototahpp/components/endDrawer.dart';
import 'package:prototahpp/components/route_generator.dart';
import 'package:prototahpp/util/customUI.dart';
import 'package:rive/rive.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with TickerProviderStateMixin {
  final _conceptosDB = Hive.box('conceptosDB');
  final _footnotesDB = Hive.box('footnotesDB');
  final _plantillasDB = Hive.box('plantillasDB');
  final Widget logoSvg =
      SvgPicture.asset('assets/logoTAH.svg', semanticsLabel: 'logoSvg');
  late AnimationController _controller;
  late AnimationController _controllerFadeIn;
  late Animation<double> _animationMoveIn;
  late Animation<double> _animationFadeIn;

  SMIBool? input;
  bool loaded = false;

  @override
  void initState() {
    if (_conceptosDB.isEmpty) {

      print('${_conceptosDB.length} _conceptosDB vacío');
    } else {
      print('keys de _conceptosDB: ' + _conceptosDB.keys.toString());
    }

    if (_footnotesDB.isEmpty) {

      print('${_footnotesDB.length} _footnotesDB vacío');
    } else {
      print('keys de _footnotesDB: ' + _footnotesDB.keys.toString());
    }

    if (_plantillasDB.isEmpty) {
      print('plantillasDB vacio');
    } else {
      print('keys de _plantillasDB: ' + _plantillasDB.keys.toString());
    }

    // TODO: implement initState
    super.initState();

    //*****Controladores de animación */

    _controller = AnimationController(
      duration: const Duration(milliseconds: 750),
      vsync: this,
    );

    _controllerFadeIn = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _animationMoveIn = Tween<double>(
      begin: 500,
      end: 0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutQuart,
    ));

    _animationFadeIn = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutQuart,
    ));

    _controller.reset();
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    setState(() {
      _controller.reset();
      _controller.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenW = MediaQuery.of(context).size.width;
    double screenH = MediaQuery.of(context).size.height;

    return SafeArea(
      top: false,
      bottom: false,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          actions: const <Widget>[
            BurgerButton(),
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //********Logo con Rive*/
              AnimatedBuilder(
                animation: _controllerFadeIn,
                builder: (context, child) {
                  return FadeTransition(
                    opacity: _animationFadeIn, // Use _animation for controlling opacity
                    child: child,
                    );
                  },
                child: Container(
                  alignment: Alignment.center,
                  width: screenW * 0.48,
                  height: screenH * 0.22,
                  color: Colors.transparent,
                  child: RiveAnimation.asset("assets/rive/tahnim.riv",
                      onInit: (art) {
                    _onRiveInit(art);
                  }),
                ),
              ),

              //********Espacio entre logo y botones */
              SizedBox(
                height: screenH * 0.11,
              ),

              //*******Boton CREAR */
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, _animationMoveIn.value),
                    child: child,
                  );
                },
                child: MenuButton(
                  text: 'CREAR',
                  onPressed: () {
                    setState(() {
                      _controller.reverse();
                    });

                    Future.delayed(Duration(milliseconds: 750), () {
                      Navigator.of(context)
                          .push(RouteGenerator.createRouteNuevoExtPage());
                    });
                  },
                ),
              ),

              //********Boton VER */
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, _animationMoveIn.value),
                    child: child,
                  );
                },
                child: MenuButton(
                  text: 'VER',
                  onPressed: () {
                    setState(() {
                      _controller.reverse();
                    });

                    Future.delayed(Duration(milliseconds: 750), () {
                      Navigator.of(context).push(RouteGenerator.createRouteVerPage());
                    });
                  },
                ),
              ),

              //******Boton ELIMINAR PLANTILLAS */
              // ElevatedButton(
              //   onPressed: () {
              //     _plantillasDB.clear();

              //   },
              //   child: Text(
              //     'Eliminar plantillas',
              //   ),
              // ),
            ],
          ),
        ),
        endDrawer: myEndDrawer(),
      ),
    );
  }

  _onRiveInit(Artboard art) {
    final controller = StateMachineController.fromArtboard(art, "SM1");

    art.addController(controller!);
  }
}
