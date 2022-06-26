// ignore_for_file: avoid_print

import 'package:autotec/car_rental/map.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter_geocoder/geocoder.dart';

import '../components/w_back.dart';
import '../components/w_carInfo.dart';
import '../components/w_carSpecifications.dart';


class CarDetailTache extends StatefulWidget {
  final String numeroChassis;
  final String marque;
  final String modele;
  final String couleur;
  final String imageVehicule;
  final carLocation;
  bool circular ;
  final String carPlace;
   CarDetailTache( {Key? key,
    required this.numeroChassis,
     required this.marque,
     required this.modele,
     required this.couleur,
     required this.imageVehicule,
    required this.carLocation,
    required this.circular,
    required this.carPlace}) : super(key: key);

  @override
  State<CarDetailTache> createState() => _CarDetailTacheState();
}

class _CarDetailTacheState extends State<CarDetailTache> {


 void carAdress() async{


  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10,left: 10,bottom: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const WidgetArrowBack(),
                    const SizedBox(width: 10,),
                    Text(widget.marque.toUpperCase(),style: const TextStyle(fontSize: 22,fontWeight: FontWeight.bold),)
                  ],
                ),
              ),
              WidgetCarInfo(carName: widget.modele, carPrice:  "", carImage:  widget.imageVehicule),
              SizedBox(height: size.height*0.03,),
              const Text("Specifications: ",style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),),
              SizedBox(height: size.height*0.02,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  widget.circular?const CircularProgressIndicator(): WidgetCarSpecifications(titre: "${widget.carLocation['batterie']}%",image: "assets/battery.png",),
                  widget.circular?const CircularProgressIndicator():  WidgetCarSpecifications(titre: "${widget.carLocation['temperature']}°",image: "assets/temp.png",),
                 widget.circular?const CircularProgressIndicator(): WidgetCarSpecifications(titre: "${widget.carLocation['kilometrage']}km/h",image: "assets/speed.png",),
                ],
              ),
              SizedBox(height: size.height*0.03,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.directions_car_rounded,color:Color(0xff2E9FB0)),
                      const SizedBox(width: 5,),
                      Text(widget.couleur)
                    ],
                  ),


                ],
              ),
              SizedBox(height: size.height*0.03,),

              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                   /* Text("Localisation : ",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                    SizedBox(height: size.height*0.02,),
                    Row(
                      children: [
                        Icon(Icons.location_on ,color:Color(0xff2E9FB0) ,),
                        SizedBox(height: 5,),
                        Text("Oued Smar, Alger ,Algerie",style: TextStyle(fontSize: 16),),
                      ],
                    ),*/
                    SizedBox(height: size.height*0.01,),
                    const Text("Numero de chassis : ",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                    SizedBox(height: size.height*0.02,),
                  Text("${widget.numeroChassis}",style: TextStyle(fontSize: 20),),
                    SizedBox(height: size.height*0.03,),
                    const Text("Localisation : ",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                    SizedBox(height: size.height*0.02,),
                    GestureDetector(
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => CarMap(widget.numeroChassis)),
                        );
                      },
                      child: Row(
                        children:  [
                          Icon(Icons.location_on,color: Color(0xff2E9FB0),),
                          SizedBox(width: 10,),
                          Center(
                            child: SizedBox(
                                height: 60,
                                width: size.width*0.8,
                                child: Text("${widget.carPlace}",style: TextStyle(fontSize: 20),)),
                          ),
                        ],
                      ),
                    ),


                    SizedBox(height: size.height*0.03,),




                  ],
                ),
              ),

            ],
          ),
        )
    );
  }
}
