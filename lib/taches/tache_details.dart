// ignore_for_file: avoid_print, deprecated_member_use


import 'package:autotec/taches/tache.dart';

import 'package:flutter/material.dart';

import '../components/w_Back.dart';
import '../components/w_raised_button.dart';

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
  double _currentSliderValue = 30.0;
  late bool enPanne;
  bool _status(){
    if(widget.tache.etat=="en cours"){
      setState(() {
        enPanne=false;
      });
      return true;
    }
    else{
      setState(() {
        enPanne=true;
      });
      return false;
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
              Text(widget.tache.objet,
                style: const TextStyle(
                fontWeight: FontWeight.w800,
                color:  Colors.black,
                fontSize: 24  ,
              ),),
              const SizedBox(
                height: 13,
              ),
              Text("${widget.tache.dateDebut.day}-${widget.tache.dateDebut.month}-${widget.tache.dateDebut.year}",
                style: const TextStyle(
                  color:  Colors.grey,
                  fontSize: 20  ,
                ),),
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
                 _status()? RaisedButton(
                    color: Colors.black,
                    hoverColor: Colors.black,
                    shape:RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),

                    child: const Text(
                      "En cours",
                      style: TextStyle(color: Colors.white, fontSize: 16),
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
        onPressed: (){},
      ),
                 _status()? RaisedButton(
                    color: const Color(0xff2E9FB0),
                    hoverColor: Colors.black,
                    shape:RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),

                    child: const Text(
                      "En panne",
                      style:  TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    onPressed: (){},
                  ):RaisedButton(
                   color: Colors.black,
                   hoverColor: Colors.black,
                   shape:RoundedRectangleBorder(
                       borderRadius: BorderRadius.circular(10)),
                   padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),

                   child: const Text(
                     "En panne",
                     style:  TextStyle(color: Colors.white, fontSize: 16),
                   ),
                   onPressed: (){},
                 ),

                ],
              ),
              const SizedBox(
                height: 35,
              ),
              const Text("Avancement",
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
                  value: _currentSliderValue,
                  label: _currentSliderValue.toString(),
                  onChanged: (value) {
                    setState(() {
                      _currentSliderValue = value;
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
              WidgetRaisedButton(text: "Notifier l'ATC",
                  press: (){print(_currentSliderValue);},
                  color: const Color(0xff2E9FB0), textColor: Colors.white)

            ]
          ),
        ),
      ),
    );
  }
}
