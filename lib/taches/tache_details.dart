// ignore_for_file: avoid_print, deprecated_member_use


import 'package:autotec/taches/Car_details_tache.dart';
import 'package:autotec/taches/tache.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter_geocoder/geocoder.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../car_rental/Car_details.dart';
import '../components/w_Back.dart';
import '../components/w_raised_button.dart';
import 'package:http/http.dart' as http;
import 'package:autotec/models/user_data.dart';

class TacheDetails extends StatefulWidget {
  final Tache tache;
  const TacheDetails({
    Key? key,
    required this.tache
  }) : super(key: key);

  @override
  State<TacheDetails> createState() => _TacheDetailsState();
}

class _TacheDetailsState extends State<TacheDetails> {
  bool isCar=true;
   bool termine =false;
   bool enCours=false;
   var _carLocation;
   bool circular =true;
   bool carCircular=true;
   @override
   void initState(){
     super.initState();
     _status();
     _car();
     getCarFromFirestore();
   }
   void getCarFromFirestore() async{
     try{
       DocumentSnapshot variable=await FirebaseFirestore.instance.collection('CarLocation').doc(widget.tache.numeroChassis).get();

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
 void _status(){
    if(widget.tache.etat=="en cours" || widget.tache.etat=="En cours"){
      setState(() {
        enCours=true;
        termine=false;
      });
    }
   else{
      setState(() {
        enCours=false;
        termine=true;
      });

    }
  }
  void _car(){
    if(widget.tache.typeTache=="Tache affectée par un atc"){
      isCar=false;
    }
  }

  void UpdateAvancement(double avancement) async{
    var res=await http.put(
      Uri.parse('http://autotek-server.herokuapp.com/tache/modifier_etatavancement_tache/${widget.tache.idTache}'),
      body: {
        "token": "${UserCredentials.token}",
        "id_sender": "${UserCredentials.uid}",
        "etat_avancement": "$avancement"

      },
    );

    print(res.statusCode);
    if(res.statusCode==200){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("etat d'avancement updated successfully"),
        duration: Duration(milliseconds: 1200),
      ));
      print("etat d'avancement updated");
    }
    else{
      print('errorrrrr');
    }


  }
  void Update_to_EnCours() async{
    var res=await http.put(
      Uri.parse('http://autotek-server.herokuapp.com/tache/modifier_etat_tache/${widget.tache.idTache}'),
      body: {
        "token": "${UserCredentials.token}",
        "id_sender": "${UserCredentials.uid}",
        "etat": "En cours"

      },
    );

    print(res.statusCode);
    if(res.statusCode==200){
      setState(() {
        enCours=true;
        termine=false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("etat switched to 'En cours' successfully"),
        duration: Duration(milliseconds: 1200),
      ));
      print("etat updated to en cours");
    }
    else{
      print('errorrrrr');
    }


  }
  void Update_to_Termine() async{
    var res=await http.put(
      Uri.parse('http://autotek-server.herokuapp.com/tache/modifier_etat_tache/${widget.tache.idTache}'),
      body: {
        "token": "${UserCredentials.token}",
        "id_sender": "${UserCredentials.uid}",
        "etat": "Terminée"

      },
    );

    print(res.statusCode);
    if(res.statusCode==200){
      print("etat updated to terminée");
      setState(() {
        termine=true;
        enCours=false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("etat switched to 'Terminée' successfully"),
        duration: Duration(milliseconds: 1200),
      ));
    }
    else{
      print('errorrrrr');
    }


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:[
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: const [
                   WidgetArrowBack(),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Text("${widget.tache.objet}" ,
                style: const TextStyle(
                fontWeight: FontWeight.w800,
                color:  Colors.black,
                fontSize: 24  ,
              ),),
              const SizedBox(
                height: 13,
              ),
              Text("${widget.tache.typeTache}" ,
                style: const TextStyle(
                  color:  Colors.black,
                  fontSize: 20  ,
                ),),
              const SizedBox(
                height: 13,
              ),
              Row(
                children: [
                  Text("Date debut tache :"),
                  SizedBox(width: 8,),
                  Text("${widget.tache.dateDebut.day}-${widget.tache.dateDebut.month}-${widget.tache.dateDebut.year}",
                    style: const TextStyle(
                      color:  Colors.grey,
                      fontSize: 20  ,
                    ),),
                ],
              ),
              const SizedBox(
                height: 13,
              ),
              Row(
                children: [
                  Text("Date fin tache :"),
                  SizedBox(width: 8,),
                  Text("${widget.tache.dateFin.day}-${widget.tache.dateFin.month}-${widget.tache.dateFin.year}",
                    style: const TextStyle(
                      color:  Colors.grey,
                      fontSize: 20  ,
                    ),),
                ],
              ),
              const SizedBox(
                height: 35,
              ),
              const Text("Le vehicule associé",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color:  Colors.black,
                  fontSize: 22,
                ),),
              const SizedBox(
                height: 12,
              ),
              isCar? GestureDetector(
                onTap: () async {
                  await UserCredentials.refresh();
                  String depart_adr= await _getAdress(_carLocation['latitude'], _carLocation['longitude']);

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CarDetailTache(carLocation: _carLocation, carPlace: depart_adr, circular: circular, numeroChassis: widget.tache.numeroChassis, modele: widget.tache.modele, marque: widget.tache.marque, imageVehicule: widget.tache.imageVehicule, couleur: widget.tache.couleur ,)),
                  );
                },
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Text("${widget.tache.marque} ${widget.tache.modele}",
                    style: const TextStyle(fontSize: 24,fontWeight: FontWeight.bold,color:  Color(0xff2E9FB0)),textAlign: TextAlign.center,
                  ),
                ),
              ):SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Text("Tous les vehicules",
                  style: const TextStyle(fontSize: 24,fontWeight: FontWeight.bold,color:  Color(0xff2E9FB0)),textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(
                height: 35,
              ),
              const Text("Statut",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color:  Colors.black,
                  fontSize: 22,
                ),),
              const SizedBox(
                height: 12,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                 enCours? RaisedButton(
                    color: Colors.white,
                    hoverColor: Colors.black,
                    shape:RoundedRectangleBorder(
                      side: BorderSide(
                          color:  Color(0xff2E9FB0),
                          width: 3,
                          style: BorderStyle.solid
                      ),
                        borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),

                    child: const Text(
                      "En cours",
                      style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold, fontSize: 19),
                    ),
                    onPressed: (){},
                  ):RaisedButton(
            color: const Color(0xff2E9FB0),
        hoverColor: Colors.black,
        shape:RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),

        child: const Text(
          "En cours",
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        onPressed: (){
              Update_to_EnCours();
        },
      ),
                 termine? RaisedButton(
                    color: Colors.white,
                   hoverColor: Colors.black,
                   shape:RoundedRectangleBorder(
                       side: BorderSide(
                           color:  Color(0xff2E9FB0),
                           width: 3,
                           style: BorderStyle.solid
                       ),
                       borderRadius: BorderRadius.circular(10)),
                   padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),

                   child: const Text(
                     "Terminée",
                     style:  TextStyle(color: Colors.black,fontWeight: FontWeight.bold, fontSize: 19),
                   ),
                   onPressed: (){},
                  ):RaisedButton(
                   color: const Color(0xff2E9FB0),
                   hoverColor: Colors.black,
                   shape:RoundedRectangleBorder(
                       borderRadius: BorderRadius.circular(10)),
                   padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),

                   child: const Text(
                     "Terminée",
                     style:  TextStyle(color: Colors.white, fontSize: 16),
                   ),
                   onPressed: (){
                     Update_to_Termine();
                   },
                 ),

                ],
              ),
              const SizedBox(
                height: 35,
              ),
              Text("Avancement (${widget.tache.etatAvancement} %)",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color:  Colors.black,
                  fontSize: 22,
                ),),
              const SizedBox(
                height: 12,
              ),
              SliderTheme(
                data: SliderThemeData(
                  activeTrackColor:const Color(0xff2E9FB0) ,
                  inactiveTickMarkColor: Colors.grey,
                  thumbColor: const Color(0xff2E9FB0) ,
                  thumbShape: const RoundSliderThumbShape(
                    enabledThumbRadius: 12
                  ),
                  overlayColor: const Color(0xff2E9FB0).withOpacity(0.4),
                  trackHeight: 8,
                  valueIndicatorColor: const Color(0xff2E9FB0),
                  valueIndicatorTextStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold
                  )
                ),
                child: Slider(
                  min: 0,
                  max: 100,
                  divisions: 100,
                  value: widget.tache.etatAvancement.toDouble() ,
                  label: widget.tache.etatAvancement.toString(),
                  onChanged: (value) {
                    setState(() {
                      widget.tache.etatAvancement = value.toInt();
                    });
                  },

                ),
              ),
              const SizedBox(
                height: 35,
              ),

              const Text("Description de la tache",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color:  Colors.black,
                  fontSize: 22,
                ),),
              const SizedBox(
                height: 12,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Text(widget.tache.descriptif,
                style: const TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(
                height: 35,
              ),
              WidgetRaisedButton(text: "Modifier l'état ",
                  press: (){
                UpdateAvancement(widget.tache.etatAvancement.toDouble());

                },
                  color: const Color(0xff2E9FB0), textColor: Colors.white)

            ]
          ),
        ),
      ),
    );
  }
}
