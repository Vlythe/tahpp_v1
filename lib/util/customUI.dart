import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:prototahpp/components/route_generator.dart';
import 'package:rive/rive.dart';

class MenuButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const MenuButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.of(context).size.width;
    final screenH = MediaQuery.of(context).size.height;

    return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(Colors.transparent),
          foregroundColor: WidgetStateProperty.all(Colors.transparent),
          splashFactory: NoSplash.splashFactory,
          overlayColor: WidgetStateProperty.all(Colors.transparent),
          elevation: WidgetStateProperty.all(0),
          minimumSize:
              WidgetStateProperty.all(Size(screenW * 0.6, screenH * 0.08)),
          padding: WidgetStateProperty.all(
              const EdgeInsets.symmetric(horizontal: 16.0)),
          shape: WidgetStateProperty.all(const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(0.0)),
          ))),
      child: Text(
        text,
        style: Theme.of(context).textTheme.displaySmall,
      ),
    );
  }
}

class BurgerButton extends StatefulWidget {
  const BurgerButton({
    super.key,
  });

  @override
  State<BurgerButton> createState() => _BurgerButtonState();
}

class _BurgerButtonState extends State<BurgerButton> {
  Color _burgerClickColor = Colors.black;

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) => GestureDetector(
        onTapDown: (_) {
          setState(() {
            //Cambiar a naranja cuando se presiona el botón
            _burgerClickColor = Theme.of(context).highlightColor;
          });
        },
        onTapUp: (_) {
          // Regresar a negro cuando se suelta el botón
          setState(() {
            _burgerClickColor = Colors.black;
          });
        },
        onTapCancel: () {
          // Regresar a negro cuando se cancela el botón
          setState(() {
            _burgerClickColor = Colors.black;
          });
        },
        child: IconButton(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          padding: const EdgeInsets.only(right: 18.0),
          icon: ColorFiltered(
            colorFilter: ColorFilter.mode(
              _burgerClickColor,
              BlendMode.srcIn,
            ),
            child: SvgPicture.asset(
              'assets/burgerMenu.svg',
              height: 18,
              width: 18,
            ),
          ),
          onPressed: () {
            Scaffold.of(context).openEndDrawer();
          },
        ),
      ),
    );
  }
}

class myCloseButton extends StatefulWidget {
  const myCloseButton({super.key});

  @override
  State<myCloseButton> createState() => _myCloseButtonState();
}

class _myCloseButtonState extends State<myCloseButton> {
  Color _closeButtonColor = Colors.black;

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) => GestureDetector(
        onTapDown: (_) {
          setState(() {
            //Cambiar a naranja cuando se presiona el botón
            _closeButtonColor = Theme.of(context).highlightColor;
          });
        },
        onTapUp: (_) {
          // Regresar a negro cuando se suelta el botón
          setState(() {
            _closeButtonColor = Colors.black;
          });
        },
        onTapCancel: () {
          // Regresar a negro cuando se cancela el botón
          setState(() {
            _closeButtonColor = Colors.black;
          });
        },
        child: IconButton(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(top: 5, right: 25),
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          icon: ColorFiltered(
            colorFilter: ColorFilter.mode(
              _closeButtonColor,
              BlendMode.srcIn,
            ),
            child: SvgPicture.asset(
              'assets/tache.svg',
              height: 18,
              width: 18,
            ),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}

class myAlertDialog extends StatelessWidget {
  final String descripcion;
  final VoidCallback onSave;
  final VoidCallback onCancel;
  final TextEditingController footnoteController;

  myAlertDialog(
      {super.key,
      required this.descripcion,
      required this.onSave,
      required this.onCancel,
      required this.footnoteController});

  @override
  Widget build(BuildContext context) {
    double screenH = MediaQuery.of(context).size.height;
    footnoteController.text = descripcion;
    return AlertDialog(
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Colors.grey, width: 2.0),
        borderRadius: BorderRadius.circular(0)),
      backgroundColor: Colors.white,
      content: Container(
        height: screenH * 0.5,
        child: Column(children: [
          Expanded(
            child: TextField(
              expands: true,
              minLines: null,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              textAlign: TextAlign.justify,
              textAlignVertical: TextAlignVertical.top,
              controller: footnoteController,
              style: Theme.of(context).textTheme.labelMedium,
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
              ),
            ),
          ),
          SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MaterialButton(
              // ********* cancelar
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: Text('Cancelar', style: TextStyle(color: Theme.of(context).unselectedWidgetColor, fontSize: 18, fontFamily: 'Baskerville',)),
              elevation: 0,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Theme.of(context).unselectedWidgetColor),
                borderRadius: BorderRadius.circular(0),
              )
              ),
              SizedBox(width: 10),
              myAlertButton(text: 'Actualizar', onPressed: onSave),
            ],
          )
        ]),
      ),
    );
  }
}

class myAlertButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  myAlertButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Theme.of(context).primaryColor),
        borderRadius: BorderRadius.circular(0),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: Theme.of(context).textTheme.displaySmall,
      ),
    );
  }
}

class myLoadingScreen extends StatelessWidget {
  const myLoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).shadowColor,
      body: Center(
        child: Container(
          width: 50,
          height: 50,
          child: RiveAnimation.asset(
            'assets/rive/loadingIndi.riv',
          ),
        ),
      ),
    );
  }
}

class descartarDialog extends StatelessWidget {
  descartarDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        backgroundColor: Colors.white,
        content: Text('¿Descartar cambios?',
            style: Theme.of(context).textTheme.displaySmall),
        actionsAlignment: MainAxisAlignment.spaceAround,
        actionsPadding: EdgeInsets.only(right: 20.0, left: 20.0, bottom: 15.0),
        shape: const RoundedRectangleBorder(
            side: BorderSide(color: Colors.grey, width: 2.0),
            borderRadius: BorderRadius.all(Radius.circular(0.0))),
        actions: [
          TextButton(
              // ********* cancelar
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('Cancelar'),
              style: ButtonStyle(
                  shape: WidgetStateProperty.all(RoundedRectangleBorder(
                    side: BorderSide(
                    color: Theme.of(context).unselectedWidgetColor),
                    borderRadius: BorderRadius.circular(0.0),
                  )),
                  foregroundColor: WidgetStateProperty.all(
                      Theme.of(context).unselectedWidgetColor),
                  textStyle: WidgetStateProperty.all(
                      Theme.of(context).textTheme.displaySmall))),
          TextButton(
              onPressed: () {
                Navigator.pop(context, true);
                Navigator.of(context)
                    .push(RouteGenerator.createRouteHomePage());
              },
              child: const Text('Descartar'),
              style: ButtonStyle(
                  shape: WidgetStateProperty.all(RoundedRectangleBorder(
                    side: BorderSide(color: Theme.of(context).primaryColor),
                    borderRadius: BorderRadius.circular(0.0),
                  )),
                  foregroundColor:
                      WidgetStateProperty.all(Theme.of(context).primaryColor),
                  textStyle: WidgetStateProperty.all(
                      Theme.of(context).textTheme.displaySmall))),
        ]);
  }
}

class descartarConceptoBDDialog extends StatelessWidget {
  final void Function()? guardarCambios;

  const descartarConceptoBDDialog({required this.guardarCambios, super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        backgroundColor: Colors.white,
        content: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          child: Text('¿Guardar cambios realizados?',
              style: Theme.of(context).textTheme.labelMedium),
        ),
        actionsAlignment: MainAxisAlignment.center,
        alignment: Alignment.center,
        //actionsPadding: EdgeInsets.only(right: 20.0, left: 20.0, bottom: 15.0),
        shape: const RoundedRectangleBorder(
            side: BorderSide(color: Colors.grey, width: 2.0),
            borderRadius: BorderRadius.all(Radius.circular(0.0))),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                  // ********* cancelar
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: const Text('Cancelar'),
                  style: ButtonStyle(
                      shape: WidgetStateProperty.all(RoundedRectangleBorder(
                        side: BorderSide(
                            color: Theme.of(context).unselectedWidgetColor),
                        borderRadius: BorderRadius.circular(0.0),
                      )),
                      foregroundColor: WidgetStateProperty.all(
                          Theme.of(context).unselectedWidgetColor),
                      textStyle: WidgetStateProperty.all(
                          Theme.of(context).textTheme.displaySmall))),
              TextButton(
              // ********* cancelar
              onPressed: () {
                Navigator.pop(context, true);
                Navigator.pop(context, true);
              },
              child: const Text('Descartar'),
              style: ButtonStyle(
                  shape: WidgetStateProperty.all(RoundedRectangleBorder(
                    side: BorderSide(
                        color: Theme.of(context).unselectedWidgetColor),
                    borderRadius: BorderRadius.circular(0.0),
                  )),
                  foregroundColor: WidgetStateProperty.all(
                      Theme.of(context).unselectedWidgetColor),
                  textStyle: WidgetStateProperty.all(
                      Theme.of(context).textTheme.displaySmall))),
              TextButton(
                onPressed: guardarCambios,
                child: const Text('Guardar'),
                style: ButtonStyle(
                    shape: WidgetStateProperty.all(RoundedRectangleBorder(
                      side: BorderSide(color: Theme.of(context).primaryColor),
                      borderRadius: BorderRadius.circular(0.0),
                    )),
                    foregroundColor:
                        WidgetStateProperty.all(Theme.of(context).primaryColor),
                    textStyle: WidgetStateProperty.all(
                        Theme.of(context).textTheme.displaySmall))),
            ],
          ),
          
        ]);
  }
}


