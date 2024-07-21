import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:prototahpp/components/route_generator.dart';
import 'package:prototahpp/components/threeDots.dart';
import 'package:prototahpp/util/pdfgen.dart';

class ViewPdfPage2 extends StatefulWidget {
  const ViewPdfPage2({super.key});

  @override
  State<ViewPdfPage2> createState() => _ViewPdfPage2State();
}

class _ViewPdfPage2State extends State<ViewPdfPage2> {
  int _indexPlantilla = 0;
  PrintingInfo? printingInfo;

  @override
  void initState() {
    super.initState();
    // TODO: implement initState
    _init();
  }

  Future<void> _init() async {
    final info = await Printing.info();
    setState(() {
      printingInfo = info;
    });
  }

  @override
  Widget build(BuildContext context) {
    Object? objDatos = ModalRoute.of(context)!.settings.arguments;

    Map<dynamic, dynamic>? mapaDatos = objDatos as Map<dynamic, dynamic>?;
    _indexPlantilla = mapaDatos?['indexPlantilla'] as int;

    pw.RichText.debug = true;

    return Scaffold(
      appBar: AppBar(
          title: Text('VISUALIZAR', style: Theme.of(context).textTheme.displaySmall),
          centerTitle: true,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          shadowColor: Colors.transparent,
          surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
          automaticallyImplyLeading: false,
          elevation: 0,
          leading: Builder(
            builder: (context) => IconButton(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              icon: SvgPicture.asset('assets/backButton.svg'),
              onPressed: ()  {
                   
                 Navigator.pop(context);
                 Navigator.of(context).push(RouteGenerator.createRouteVerPage());
              },
            ),
          ),
          actions: [
              ThreeDots2(_indexPlantilla),
            ],
          ),
      body: SafeArea(
        child: InteractiveViewer(
          minScale: 0.5,
          maxScale: 5.0,
          child: buildPdf(_indexPlantilla),
          
        ),
      ),
    );
  }
}
