import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:prototahpp/components/endDrawer.dart';
import 'package:prototahpp/components/plantillaSimp.dart';
import 'package:prototahpp/components/route_generator.dart';
import 'package:prototahpp/util/customUI.dart';

class SeleccionarPage extends StatefulWidget {
  const SeleccionarPage({super.key});

  @override
  State<SeleccionarPage> createState() => _SeleccionarPageState();
}

class _SeleccionarPageState extends State<SeleccionarPage> {
  final List<PlantillaSimp> _plantillasList = [];
  List<PlantillaSimp> filteredPlantillasList = [];
  final TextEditingController searchController = TextEditingController();

  final _plantillasDB = Hive.box('plantillasDB');

  void addPlantillasAList() {
    for (int i = 0; i < _plantillasDB.length; i++) {
      _plantillasList.add(PlantillaSimp(
                                  i,
                                  _plantillasDB.getAt(i)['nombreProyecto'] as String,
                                  _plantillasDB.getAt(i)['fecha'] as String,
                                  _plantillasDB.getAt(i)['total'].toString()
        ));
    }
  }

  filtrarPlantillas() {
    final query = searchController.text.toLowerCase();
    final tempPlantillas =  _plantillasList.where((plantilla) {
      return plantilla.nombreProyecto.toLowerCase().contains(query);
    }).toList();

    setState(() {
      filteredPlantillasList = tempPlantillas;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    addPlantillasAList();
    filteredPlantillasList = _plantillasList;
  }

  @override
  Widget build(BuildContext context) {
    double screenW = MediaQuery.of(context).size.width;
    double screenH = MediaQuery.of(context).size.height;

    return SafeArea(
      top: false,
      bottom: false, 
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'SELECCIONAR',
            style: Theme.of(context).textTheme.displaySmall,
          ),
          centerTitle: true,
          automaticallyImplyLeading: false,
          leading: Builder(
            builder: (context) => IconButton(
              icon: SvgPicture.asset('assets/backButton.svg'),
              onPressed: () => Navigator.of(context).push(RouteGenerator.createRouteNuevoExtPage()),
            ),
          ),
          actions: const <Widget>[BurgerButton()],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Container(
                height: screenH * 0.06,
                width: screenW * 0.9,
                child: TextField(
                  controller: searchController,
                  style: Theme.of(context).textTheme.labelMedium,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(0)),
                    labelText: 'Buscar cotización',
                    labelStyle: Theme.of(context).textTheme.labelSmall,
                    suffixIcon: Icon(Icons.search),
                    focusColor: Theme.of(context).highlightColor,
                    suffixIconConstraints:
                        BoxConstraints(minWidth: 50, minHeight: 23),
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Theme.of(context).highlightColor),
                        borderRadius: BorderRadius.circular(0)),
                  ),
                  onChanged: (value) {
                    filtrarPlantillas();
                  },
                  onTapOutside: (PointerDownEvent event) {
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                ),
              ),
            ),
            Divider(
              indent: screenW * 0.05,
              endIndent: screenW * 0.05,
              color: Theme.of(context).dividerColor,
            ),
            Expanded(
              child: ListView.builder(
                key: UniqueKey(),
                itemCount: filteredPlantillasList.length,
                itemBuilder: (context, index) {
                  return filteredPlantillasList[index];
                },
                
              ),
            ),
          ],
        ),
        endDrawer: myEndDrawer(),
      ),
    );
  }
}
