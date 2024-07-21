import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:prototahpp/components/route_generator.dart';
import 'package:prototahpp/util/pdfgen.dart';

import '../components/threeDots.dart';

class ViewPdfPage extends StatefulWidget {
  const ViewPdfPage({super.key});

  @override
  State<ViewPdfPage> createState() => _ViewPdfPageState();
}

class _ViewPdfPageState extends State<ViewPdfPage> {
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

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) {
          return;
        }
        Map datos = {
          'tipo': 'editar',
          'indexPlantilla': _indexPlantilla,
          'total': null,
          'vieneDeView': true,
        };

        Navigator.pop(context, true);

        Navigator.of(context).push(RouteGenerator.createRouteCrear1Page(
            const RouteSettings(name: '/crear1Page'),
            arguments: datos));
      },
      child: SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
          appBar: AppBar(
            title: Text('VISUALIZAR',
                style: Theme.of(context).textTheme.displaySmall),
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
                onPressed: () {
                  Map datos = {
                    'tipo': 'editar',
                    'indexPlantilla': _indexPlantilla,
                    'total': null,
                    'vieneDeView': true,
                  };

                  Navigator.pop(context, true);

                  Navigator.of(context).push(
                      RouteGenerator.createRouteCrear1Page(
                          const RouteSettings(name: '/crear1Page'),
                          arguments: datos));
                },
              ),
            ),
            actions: [
              ThreeDots(_indexPlantilla),
            ],
          ),
          body: SafeArea(
            child: InteractiveViewer(
              minScale: 0.5,
              maxScale: 5.0,
              child: buildPdf(_indexPlantilla),
            ),
          ),
        ),
      ),
    );
  }
}
