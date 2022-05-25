import 'package:autotec/taches/taches_list.dart';
import 'package:flutter/material.dart';

import '../taches/tache.dart';
import '../taches/tache_details.dart';


class WidgetTache extends StatelessWidget {

  final Tache tache;
  const WidgetTache({
    Key? key,
    required this.tache,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: (){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TacheDetails(tache: tache,)),
            );
          },
          child: Container(
            margin: const EdgeInsets.only(top:10.0, left: 10.0, right: 10.0),
            height: 90,
            decoration: const BoxDecoration(

              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                topLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  spreadRadius: 2,
                  blurRadius: 10,
                  offset: Offset(0,2), // changes position of shadow
                ),
              ],
              color: Colors.white,
            ),
            child: Stack(
                children:  [
                  Positioned(
                      top: 10,
                      bottom: 10,
                      left: 20.0,
                      child: Icon(Icons.warning_amber_rounded,color: Color(0xff2E9FB0),size: 50,)
                    //Image.asset("assets/vector.png"),
                  ),
                  Positioned(
                    top:22.0,
                    left: 100,
                    child:
                    Column(
                      children: [
                        Text(tache.objet,
                          maxLines: 2,
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),),

                        Text("${tache.dateDebut.day}-${tache.dateDebut.month}-${tache.dateDebut.year}",
                          maxLines: 2,
                          style: TextStyle(
                            color: Colors.grey,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom:10.0,
                    right: 10.0,
                    child:Column(
                      children:  [
                        Text(tache.etat,
                          maxLines: 2,
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),),

                      ],
                    ) ,
                  ),

                ]
            ),
          ),
        ),

      ],

    );
  }
}