import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter_svg/svg.dart';
import 'package:prototahpp/util/customUI.dart';
import 'package:share_plus/share_plus.dart';

Future<void> saveAsFile(
  final BuildContext context,
  final LayoutCallback build,
  final PdfPageFormat pageFormat,
) async {
  final bytes = await build(pageFormat);

  final appDocDir = await getExternalStorageDirectory();

  final appDocPath = appDocDir!.path;

  final file = File('$appDocPath/Cotización_TAH.pdf');

  print('Saving file to ${file.path}...');

  await file.writeAsBytes(bytes);

  await OpenFile.open(file.path);

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('Documento guardado en: ' + file.path),
    ),
  );
}

Future<void> shareFile(
  final BuildContext context,
  final LayoutCallback build,
  final PdfPageFormat pageFormat,
) async {
  final bytes = await build(pageFormat);
  final output = await getTemporaryDirectory();
  final file = File("${output.path}/Cotización_TAH.pdf");
  await file.writeAsBytes(bytes);
  Share.shareXFiles([XFile(file.path, name: 'Cotización_TAH.pdf')],
      text: 'Cotización TAH');
}

void showSharedToast(final BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('Cotización compartida con éxito.'),
    ),
  );
}

Widget buildPdf(
  final int _indexPlantilla,
) {
  final _plantillasDB = Hive.box('plantillasDB');

  pw.RichText.debug = true;
  final actions = <PdfPreviewAction>[
    if (!kIsWeb)
      PdfPreviewAction(
        icon: Icon(Icons.save_sharp, size: 30,),
        onPressed: saveAsFile,
      ),
    PdfPreviewAction(
        icon: SvgPicture.asset('assets/shareButton.svg', width: 20),
        onPressed: shareFile),
  ];

  return PdfPreview(
    allowPrinting: false,
    allowSharing: false,
    canDebug: false,
    pdfFileName:
        'Cotización_${_plantillasDB.getAt(_indexPlantilla)['noCoti']}.pdf',
    canChangeOrientation: false,
    canChangePageFormat: false,
    maxPageWidth: 700,
    actions: actions,
    onShared: showSharedToast,
    actionBarTheme: const PdfActionBarTheme(
      backgroundColor: Color.fromARGB(255, 240, 236, 225),
      iconColor: Colors.grey,
      elevation: 10,
      height: 70,
    ),
    loadingWidget: const myLoadingScreen(),
    build: (format) => generarPdf(_indexPlantilla, format),
  );
}

Future<Uint8List> generarPdf(int _indexPlantilla, PdfPageFormat format) async {
  final _plantillasDB = await Hive.openBox('plantillasDB');

  final doc = pw.Document(title: 'Cotización');

  String? logoT = await rootBundle.loadString('assets/logoTAH.svg');

  final pageTheme = await _myPageTheme(format);

  const tableHeaders = [
    'SERVICIOS',
    'CANTIDAD',
    'UNIDAD',
    'PRECIO',
    //'SUBTOTAL'
  ];

  final servicios = <Servicio>[];

  final List<pw.Widget> footnotes = <pw.Widget>[];

  for (int i = 0;
      i < _plantillasDB.getAt(_indexPlantilla)['conceptos'].length;
      i++) {
    servicios.add(Servicio(
      _plantillasDB.getAt(_indexPlantilla)['conceptos'][i]['nombreConcepto'] +
          '\n\n' +
          _plantillasDB.getAt(_indexPlantilla)['conceptos'][i]['descr'],
      _plantillasDB.getAt(_indexPlantilla)['conceptos'][i]['precio'],
      _plantillasDB.getAt(_indexPlantilla)['conceptos'][i]['cantidad'],
      _plantillasDB.getAt(_indexPlantilla)['conceptos'][i]['unidad'],
      _plantillasDB.getAt(_indexPlantilla)['conceptos'][i]['subtotal'],
    ));
  }

  for (int i = 0;
      i < _plantillasDB.getAt(_indexPlantilla)['footnotes'].length;
      i++) {
    if (_plantillasDB.getAt(_indexPlantilla)['footnotes'][i]
            ['footnoteChecked'] ==
        true) {
      footnotes.add(
          pw.Text(_plantillasDB.getAt(_indexPlantilla)['footnotes'][i]['descr'],
              textScaleFactor: 1,
              textAlign: pw.TextAlign.justify,
              style: pw.TextStyle(
                font: pw.Font.times(),
                fontSize: 9,
              )));
    }
  }

  doc.addPage(
    pw.MultiPage(
      pageTheme: pageTheme,
      header: (final context) => pw.Container(
        alignment: pw.Alignment.centerRight,
        padding: const pw.EdgeInsets.only(
            bottom: 5.0 * PdfPageFormat.mm, top: 5.0 * PdfPageFormat.mm),
        child: pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.center,
            children: <pw.Widget>[
              pw.Row(
                children: <pw.Widget>[
                  pw.Padding(
                      padding: pw.EdgeInsets.only(left: 8.0 * PdfPageFormat.mm),
                      child:
                          pw.Text('${context.pageNumber}/${context.pagesCount}',
                              style: pw.TextStyle(
                                font: pw.Font.times(),
                                fontSize: 10,
                              ))),
                  pw.Spacer(),
                  pw.Padding(
                      padding:
                          pw.EdgeInsets.only(right: 8.0 * PdfPageFormat.mm),
                      child:
                          pw.Text(_plantillasDB.getAt(_indexPlantilla)['fecha'],
                              style: pw.TextStyle(
                                font: pw.Font.times(),
                                fontSize: 10,
                              ))),
                ],
              ),
            ]),
      ),
      footer: (context) {
        return pw.Container(
            alignment: pw.Alignment.center,
            padding: const pw.EdgeInsets.only(
                bottom: 5.0 * PdfPageFormat.mm, top: 5.0 * PdfPageFormat.mm),
            child: pw.Column(children: [
              pw.Text(
                  'Av. Sin Nombre 12 A-555, Querétaro, Qro.',
                  style: pw.TextStyle(
                    font: pw.Font.times(),
                    fontSize: 9,
                  )),
              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    //******Instagram */
                    pw.Text('@tahmx',
                        style: pw.TextStyle(
                          font: pw.Font.times(),
                          fontSize: 9,
                        )),

                    pw.SizedBox(width: 20),

                    //******Correo */
                    pw.Text('info.tahmx@gmail.com',
                        style: pw.TextStyle(
                          font: pw.Font.times(),
                          fontSize: 9,
                        )),
                  ])
            ]));
      },
      build: (context) => [
        pw.Container(
            alignment: pw.Alignment.bottomLeft,
            padding: pw.EdgeInsets.only(
                left: 8 * PdfPageFormat.mm, right: 8 * PdfPageFormat.mm),
            child: pw.Column(
              children: [
                //***** Espacio entre fecha y logo */
                pw.SizedBox(height: 25),

                //******Row: Logo y datos de cotización  */
                pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children: [
                      //******Logo */
                      pw.Container(
                        alignment: pw.Alignment.centerLeft,
                        child: pw.SvgImage(
                            width: 75,
                            alignment: pw.Alignment.center,
                            svg: logoT),
                      ),

                      //******Datos de la cotización */
                      pw.Text(
                          'Cotización # ' +
                              _plantillasDB.getAt(_indexPlantilla)['noCoti'] +
                              ' \n' +
                              _plantillasDB.getAt(_indexPlantilla)['cliente'] +
                              '\n' +
                              _plantillasDB
                                  .getAt(_indexPlantilla)['nombreProyecto'] +
                              '\n' +
                              _plantillasDB.getAt(_indexPlantilla)['codigo'],
                          textAlign: pw.TextAlign.right,
                          style: pw.TextStyle(
                            lineSpacing: 5,
                            font: pw.Font.times(),
                            fontSize: 10,
                          ))
                    ]),
                pw.SizedBox(height: 25),
              ],
            )),

        //******Cuerpo de cotización */
        pw.Container(
          padding: pw.EdgeInsets.only(
              left: 8 * PdfPageFormat.mm, right: 8 * PdfPageFormat.mm),
          child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.start,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                //****** Título "Propuesta de Servicios Profesionales" */
                pw.Text('Propuesta de Servicios Profesionales',
                    textAlign: pw.TextAlign.left,
                    style: pw.TextStyle(
                      font: pw.Font.timesBold(),
                      fontSize: 17,
                    )),

                pw.Divider(height: 2, color: PdfColors.black, endIndent: 4),

                pw.SizedBox(height: 30),

                ///******* Tabla con servicios */
                pw.TableHelper.fromTextArray(
                  border: const pw.TableBorder(
                    verticalInside: pw.BorderSide.none,
                    horizontalInside: pw.BorderSide.none,
                    bottom: pw.BorderSide.none,
                  ),
                  headerPadding: pw.EdgeInsets.all(2 * PdfPageFormat.mm),
                  headerDecoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.white),
                  ),
                  cellAlignments: {
                    0: pw.Alignment.centerLeft,
                    1: pw.Alignment.topCenter,
                    2: pw.Alignment.topCenter,
                    3: pw.Alignment.topRight,
                    4: pw.Alignment.topRight,
                  },
                  columnWidths: {
                    0: pw.FlexColumnWidth(5),
                    1: pw.FlexColumnWidth(1),
                    2: pw.FlexColumnWidth(1),
                    3: pw.FlexColumnWidth(1),
                    4: pw.FlexColumnWidth(1),
                  },
                  headerStyle:
                      pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 7),
                  // headers: List<String>.generate(
                  //     tableHeaders.length, (index) => tableHeaders[index]),
                  data: List<List<pw.Widget>>.generate(
                    _plantillasDB.getAt(_indexPlantilla)['conceptos'].length,
                    (row) => List<pw.Widget>.generate(
                      tableHeaders.length,
                      (col) {
                        if (col == 0) {
                          int lengthNombre = _plantillasDB
                              .getAt(_indexPlantilla)['conceptos'][row]
                                  ['nombreConcepto']
                              .length;

                          return pw.Padding(
                              padding: pw.EdgeInsets.only(
                                bottom: 3 * PdfPageFormat.mm,
                                top: 2 * PdfPageFormat.mm,
                                left: -2 * PdfPageFormat.mm,
                              ),
                              child: pw.RichText(
                                  textAlign: pw.TextAlign.justify,
                                  text: pw.TextSpan(
                                    children: [
                                      pw.TextSpan(
                                        text: servicios[row]
                                            .getIndex(col)
                                            .substring(0, lengthNombre),
                                        style: pw.TextStyle(
                                            font: pw.Font.timesBold(),
                                            fontSize: 9,
                                            fontWeight: pw.FontWeight.bold),
                                      ),
                                      pw.TextSpan(
                                        text: servicios[row]
                                            .getIndex(col)
                                            .substring(lengthNombre),
                                        style: pw.TextStyle(
                                            font: pw.Font.times(),
                                            fontSize: 9,
                                            fontWeight: pw.FontWeight.normal),
                                      ),
                                    ],
                                  )));
                        } else {
                          return pw.Padding(
                              padding:
                                  pw.EdgeInsets.only(top: 2 * PdfPageFormat.mm),
                              child: pw.Text(servicios[row].getIndex(col),
                                  style: pw.TextStyle(
                                    font: pw.Font.times(),
                                    fontSize: 9,
                                  )));
                        }
                      },
                    ),
                  ),
                )
              ]),
        ),
        pw.SizedBox(height: 15),

        //*******Resumen de total */
        pw.Container(
          alignment: pw.Alignment.centerRight,
          padding: pw.EdgeInsets.only(right: 10 * PdfPageFormat.mm),
          child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.end,
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                //****** SUBTOTAL */
                pw.Padding(
                    padding: pw.EdgeInsets.only(bottom: 2 * PdfPageFormat.mm),
                    child: pw.Row(
                        crossAxisAlignment: pw.CrossAxisAlignment.end,
                        mainAxisAlignment: pw.MainAxisAlignment.end,
                        children: [
                          pw.Text(
                            'SUBTOTAL',
                            style: pw.TextStyle(
                              font: pw.Font.timesBold(),
                              fontSize: 9,
                            ),
                          ),
                          pw.SizedBox(width: 10),
                          pw.Text(
                            NumberFormat.currency(locale: 'es_MX', symbol: '\$')
                                .format(double.parse(_plantillasDB
                                    .getAt(_indexPlantilla)['total']
                                    .toString())),
                            style: pw.TextStyle(
                              font: pw.Font.times(),
                              fontSize: 9,
                            ),
                          ),
                        ])),

                //**** IVA */
                pw.Padding(
                    padding: pw.EdgeInsets.only(bottom: 2 * PdfPageFormat.mm),
                    child: pw.Row(
                        crossAxisAlignment: pw.CrossAxisAlignment.end,
                        mainAxisAlignment: pw.MainAxisAlignment.end,
                        children: [
                          pw.Text(
                            'IVA 16.00%',
                            style: pw.TextStyle(
                              font: pw.Font.timesBold(),
                              fontSize: 9,
                            ),
                          ),
                          pw.SizedBox(width: 16),
                          pw.Text(
                            NumberFormat.currency(locale: 'es_MX', symbol: '\$')
                                .format(_plantillasDB
                                        .getAt(_indexPlantilla)['total'] *
                                    0.16),
                            style: pw.TextStyle(
                              font: pw.Font.times(),
                              fontSize: 9,
                            ),
                            textAlign: pw.TextAlign.center,
                          ),
                        ])),

                pw.Padding(
                    padding: pw.EdgeInsets.only(bottom: 2 * PdfPageFormat.mm),
                    child: pw.Divider(
                        indent: 20, height: 2, color: PdfColors.black)),

                //**** TOTAL */

                pw.Padding(
                    padding: pw.EdgeInsets.only(bottom: 2 * PdfPageFormat.mm),
                    child: pw.Row(
                        crossAxisAlignment: pw.CrossAxisAlignment.end,
                        mainAxisAlignment: pw.MainAxisAlignment.end,
                        children: [
                          pw.Text(
                            'TOTAL',
                            style: pw.TextStyle(
                              font: pw.Font.timesBold(),
                              fontSize: 9,
                            ),
                          ),
                          pw.SizedBox(width: 10),
                          pw.Text(
                            NumberFormat.currency(locale: 'es_MX', symbol: '\$')
                                .format(_plantillasDB
                                        .getAt(_indexPlantilla)['total'] *
                                    1.16),
                            style: pw.TextStyle(
                              font: pw.Font.times(),
                              fontSize: 9,
                            ),
                          ),
                        ])),
              ]),
        ),
        pw.SizedBox(height: 15),

        //******Honorarios y Formas de pago */
        pw.Container(
            padding: pw.EdgeInsets.only(
              left: 8 * PdfPageFormat.mm,
              right: 8 * PdfPageFormat.mm,
            ),
            child: pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.start,
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('Honorarios y Formas de Pago',
                      style: pw.TextStyle(
                        font: pw.Font.timesBold(),
                        fontSize: 9,
                      )),
                  pw.SizedBox(height: 15),
                  pw.Text(_plantillasDB.getAt(_indexPlantilla)['honorarios'],
                      style: pw.TextStyle(
                        font: pw.Font.times(),
                        fontSize: 9,
                      )),
                  pw.SizedBox(height: 15),
                ])),

        //*******Footnotes */
        pw.Container(
            padding: const pw.EdgeInsets.only(
              left: 8 * PdfPageFormat.mm,
              right: 8 * PdfPageFormat.mm,
            ),
            child: pw.Text('Consideraciones',
                style: pw.TextStyle(
                  font: pw.Font.timesBold(),
                  fontSize: 9,
                ))),

        pw.Container(
            padding: const pw.EdgeInsets.only(
              left: 8 * PdfPageFormat.mm,
              right: 40 * PdfPageFormat.mm,
            ),
            child: pw.TableHelper.fromTextArray(
                border: null,
                cellHeight: 20,
                cellAlignment: pw.Alignment.centerLeft,
                cellAlignments: {
                  0: pw.Alignment.centerLeft,
                },
                cellPadding: pw.EdgeInsets.only(top: 5),
                data: List<List<pw.Widget>>.generate(
                    footnotes.length,
                    (row) => List<pw.Widget>.generate(1, (col) {
                          return footnotes[row];
                        })))),
      ],
    ),
  );

  return doc.save();
}

Future<pw.PageTheme> _myPageTheme(PdfPageFormat format) async {
  return pw.PageTheme(
    margin: pw.EdgeInsets.all(10 * PdfPageFormat.mm),
    textDirection: pw.TextDirection.ltr,
    orientation: pw.PageOrientation.portrait,
  );
}

class Servicio {
  //const tableHeaders = ['Servicios', 'Precio Unitario', 'Cantidad', 'Unidad', 'Subtotal', 'Total'];
  Servicio(
    this.nombreYdescr,
    this.precio,
    this.cantidad,
    this.unidad,
    this.subtotal,
  );

  String nombreYdescr;
  String precio;
  String cantidad;
  String unidad;
  String subtotal;

  String getIndex(int index) {
    if (subtotal == '' || subtotal == '0') {
      precio = '';
      cantidad = '';
      unidad = '';
      subtotal = '';
    }

    switch (index) {
      case 0:
        return nombreYdescr;
      case 1:
        return cantidad;
      case 2:
        return unidad;
      case 3:
        return precio;
      case 4:
        return subtotal;
      default:
        return '';
    }
  }
}
