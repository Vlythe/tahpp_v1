import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:prototahpp/components/endDrawer.dart';
import 'package:prototahpp/components/plantilla.dart';
import 'package:prototahpp/components/route_generator.dart';
import 'package:prototahpp/util/customUI.dart';

class VerPage extends StatefulWidget {
  @override
  State<VerPage> createState() => _VerPageState();
}

class _VerPageState extends State<VerPage> {
  final List<Plantilla> _plantillasList = [];

  //**** Para la búsqueda */
  final TextEditingController searchController = TextEditingController();
  List<Plantilla> filteredPlantillasList = [];

  final _plantillasDB = Hive.box('plantillasDB');

  void addPlantillasAList() {
    if (_plantillasDB.isNotEmpty) {
      for (int i = 0; i < _plantillasDB.length; i++) {
        _plantillasList.add(Plantilla(
            i,
            _plantillasDB.getAt(i)['nombreProyecto'] as String,
            _plantillasDB.getAt(i)['fecha'] as String,
            _plantillasDB.getAt(i)['total'].toString()));
      }
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

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop)  {
        
        Future.delayed(Duration(milliseconds: 200), () {
          Navigator.of(context).push(RouteGenerator.createRouteHomePage());
        });

        
      },
      child: SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              'VER',
              style: Theme.of(context).textTheme.displaySmall,
            ),
            centerTitle: true,
            automaticallyImplyLeading: false,
            leading: Builder(
              builder: (context) => IconButton(
                icon: SvgPicture.asset('assets/backButton.svg'),
                onPressed: () {
                  Future.delayed(Duration(milliseconds: 200), () {
                    Navigator.of(context)
                        .push(RouteGenerator.createRouteHomePage());
                  });
                },
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
                        print(
                          '***** fliteredPlantillasList: ${filteredPlantillasList[0].nombreProyecto}');
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
                  itemCount: filteredPlantillasList.length +
                      1, 
                  itemBuilder: (context, index) {
                    if (index == filteredPlantillasList.length) {
                      
                      return Center(
                        child: GestureDetector(
                          onTap: () {
                            Map datos = {
                              'tipo': 'nuevo',
                              'indexPlantilla': null,
                              'total': null,
                              'vieneDeView': false,
                            };
                            Navigator.of(context).push(
                              RouteGenerator.createRouteCrear1Page(
                                const RouteSettings(name: '/crear1Page'),
                                arguments: datos,
                              ),
                            );
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
                      );
                    } else {
                  
                        return filteredPlantillasList[index];
                      
                    }
                  },
                ),
              ),
            ],
          ),
          endDrawer: myEndDrawer(),
        ),
      ),
    );
  }
}
