import 'package:flutter/material.dart';

import '../car_rental/cars.dart';

class CarLocation{

  CarLocation._privateConstructor();

  // the info related to the location
  int? id;
  DateTime? dateDebut;
  TimeOfDay? heureDebut;
  TimeOfDay? heureFin;

  bool? enCours; // si y a une location en cours ou non
  String? etat;// none,
               // en attente (suivi du vehicule avant deverrouillage),
               // deverrouillage
               // trajet (suivi du trajet)
              // payement
  String? region;
  String? numeroChassis;

  String? pointDepart;
  double? latitudeDepart;
  double? longitudeDepart;

  String? pointArrive;
  double? latitudeArrive;
  double? longitudeArrive;

  Car? car;

  static final CarLocation _instance = CarLocation._privateConstructor();

  factory CarLocation(){
    return _instance;
  }
}
