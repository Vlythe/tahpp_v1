import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:prototahpp/components/endDrawer.dart';
import 'package:prototahpp/components/route_generator.dart';
import 'package:prototahpp/util/customUI.dart';

class NuevoExtPage extends StatefulWidget {
  @override
  _NuevoExtPageState createState() => _NuevoExtPageState();
}

class _NuevoExtPageState extends State<NuevoExtPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //*****Controladores de animación */
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _animation = Tween<double>(
      begin: 750,
      end: 0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutQuart,
    ));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.reset();
      _controller.forward();
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    //double screenW = MediaQuery.of(context).size.width;
    double screenH = MediaQuery.of(context).size.height;

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop)  {

         setState(() {
                    _controller.reverse();
                  });
        
        Future.delayed(Duration(milliseconds: 500), () {
          Navigator.of(context).push(RouteGenerator.createRouteHomePage());
        });

        
      },
      child: SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            automaticallyImplyLeading: false,
            leading: Builder(
              builder: (context) => IconButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                icon: SvgPicture.asset('assets/backButton.svg'),
                onPressed: () {
                  setState(() {
                    _controller.reverse();
                  });
      
                  Future.delayed(Duration(milliseconds: 500), () {
                    Navigator.of(context)
                        .push(RouteGenerator.createRouteHomePage());
                  });
                },
              ),
            ),
            actions: <Widget>[BurgerButton()],
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //****Separador para botones */
                SizedBox(
                  height: screenH * 0.28,
                ),
                AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, -(_animation.value)),
                      child: child,
                    );
                  },
                  child: MenuButton(
                    text: 'NUEVO',
                    onPressed: () {
                      Map datos = {
                        'tipo': 'nuevo',
                        'indexPlantilla': null,
                        'total': null,
                      };
      
                      setState(() {
                        _controller.reverse();
                      });
      
                      Future.delayed(Duration(milliseconds: 500), () {
                        
                        Navigator.of(context)
                            .push(RouteGenerator.createRouteCrear1Page(
                                const RouteSettings(name: '/crear1Page'),
                                arguments: datos))
                            .then((result) {
                          _controller.reset();
                          _controller.forward();
                          
                        });
                      });
                    },
                  ),
                ),
      
                AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, _animation.value),
                      child: child,
                    );
                  },
                  child: MenuButton(
                    text: 'DUPLICAR',
                    onPressed: () {
                      setState(() {
                        _controller.reverse();
                      });
      
                      // Handle button 2 press
                      Future.delayed(Duration(milliseconds: 500), () {
                        Navigator.pushNamed(context, '/seleccionarPage');
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          endDrawer: myEndDrawer(),
        ),
      ),
    );
  }
}
