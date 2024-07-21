import 'package:flutter/material.dart';

class menuConceptos extends StatelessWidget {
  const menuConceptos({super.key});

  @override
  Widget build(BuildContext context) {
    double screenW = MediaQuery.of(context).size.width;
    double screenH = MediaQuery.of(context).size.height;

    return PopupMenuButton(
              surfaceTintColor: Colors.white,
              constraints: BoxConstraints.tightFor(width: screenW * 0.9, height: screenH * 0.6),
              position: PopupMenuPosition.over,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
              icon: Icon(Icons.arrow_drop_down),
              itemBuilder: (context) => [
                PopupMenuItem(
                  child: Row(
                    children: [
                      Text('Unidad'),
                      Spacer(),
                      Text('\$00m2')
                    ],
                  ),
                  value: 1,
                ),
                PopupMenuItem(
                  child: Text('Kg'),
                  value: 2,
                ),
                PopupMenuItem(
                  child: Text('Lts'),
                  value: 3,
                ),
              ],
              onSelected: (value) {
              
              }
            );
  }
}