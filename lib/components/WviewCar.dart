// ignore_for_file: deprecated_member_use

import 'package:autotec/car_rental/Car_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:autotec/models/user_data.dart';
import 'package:flutter_geocoder/geocoder.dart';
import '../car_rental/Car_details.dart';
import '../car_rental/cars.dart';


class WidgetViewCar extends StatefulWidget {
  final Car car;
  const WidgetViewCar({
    Key? key,
    required this.car,
  }) : super(key: key);

  @override
  State<WidgetViewCar> createState() => _WidgetViewCarState();
}

class _WidgetViewCarState extends State<WidgetViewCar> {
  var _carLocation;
  bool circular =true;
  bool carCircular=true;
  @override
  void initState(){
    super.initState();
    getCarFromFirestore();
  }
  void getCarFromFirestore() async{
    try{
      DocumentSnapshot variable=await FirebaseFirestore.instance.collection('CarLocation').doc(widget.car.numeroChassis).get();

      setState(() {
        _carLocation=variable;
        circular=false;
      });

    }catch(e){
      print(e.toString());

    }
  }

  Future<String> _getAdress(double latitude, double longitude)async{
    final coordinates = Coordinates(latitude, longitude);
    var addresses = await Geocoder.google ('AIzaSyCNdS-eHQeAsWyQ6xIEwROKmkgaA7zm6a4').findAddressesFromCoordinates(
        coordinates);
    var first = addresses.first;
    print('1. ${first.locality}, 2. ${first.adminArea}, 3. ${first.subLocality}, '
        '4. ${first.subAdminArea}, 5. ${first.addressLine}, 6. ${first.featureName},'
        '7, ${first.thoroughfare}, 8. ${first.subThoroughfare}');

    return first.addressLine!;
  }
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: ()async{
            await UserCredentials.refresh();
            String depart_adr= await _getAdress(_carLocation['latitude'], _carLocation['longitude']);

            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CarDetail(car: widget.car, carLocation: _carLocation, carPlace: depart_adr, circular: circular,)),
            );

          },
          child: Container(
            margin: const EdgeInsets.only(top:10.0, left: 10.0, right: 10.0),
            height: 140,
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
                  top:10.0,
                  left: 10.0,
                  child: Image.network(widget.car.imageVehicule,width: 120),
                ),
                Positioned(
                  top:10.0,
                 left: 145,
                  child:
                      Container(
                        height: 50,
                        width: 150,
                        child: Text(widget.car.modele,
                          maxLines: 2,
                          style: const TextStyle(
                            color: Colors.black,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),),
                      ),
                ),
                Positioned(
                  bottom: 10,
                  left: 50,
                  child: Text(widget.car.tarification.toString()+" DA",
                  style: const TextStyle(
                    color: Colors.blueGrey,
                    fontSize: 13,

                  ),),),
                Positioned(
                  bottom:0.0,
                  right: 0.0,
                  child:Column(
                    children:  [
                      FlatButton(
                          onPressed :()async{
                            await UserCredentials.refresh();
                            String depart_adr= await _getAdress(_carLocation['latitude'], _carLocation['longitude']);
                            
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => CarDetail(car: widget.car, carLocation: _carLocation, carPlace: depart_adr, circular: circular,)),
                            );
                          } ,
                          color: const Color(0xff2E9FB0),
                          textColor: Colors.white,
                          minWidth: 140,
                          height: 50,
                          shape:  const RoundedRectangleBorder(
                            borderRadius:  BorderRadius.only(
                              topLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            ),
                          ),
                          child: const Text('Details')),

                    ],
                  ) ,
                ),
              ],
            ),
          ),
        ),

      ],

    );
  }
}