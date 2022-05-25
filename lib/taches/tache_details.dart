import 'package:autotec/components/WBack.dart';
import 'package:autotec/components/WraisedButton.dart';
import 'package:autotec/taches/tache.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
  late bool en_panne;
  bool _status(){
    if(widget.tache.etat=="en cours"){
      setState(() {
        en_panne=false;
      });
      return true;
    }
    else{
      setState(() {
        en_panne=true;
      });
      return false;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:[
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  WidgetArrowBack(),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Text(widget.tache.objet,
                style: TextStyle(
                fontWeight: FontWeight.w800,
                color:  Colors.black,
                fontSize: 24  ,
              ),),
              SizedBox(
                height: 13,
              ),
              Text("${widget.tache.dateDebut.day}-${widget.tache.dateDebut.month}-${widget.tache.dateDebut.year}",
                style: TextStyle(
                  color:  Colors.grey,
                  fontSize: 20  ,
                ),),
              SizedBox(
                height: 35,
              ),
              Text("Statut",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color:  Colors.black,
                  fontSize: 22,
                ),),
              SizedBox(
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
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 14),

                    child: Text(
                      "En cours",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    onPressed: (){},
                  ):RaisedButton(
            color: Color(0xff2E9FB0),
        hoverColor: Colors.black,
        shape:RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)),
        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 14),

        child: Text(
          "En cours",
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        onPressed: (){},
      ),
                 _status()? RaisedButton(
                    color: Color(0xff2E9FB0),
                    hoverColor: Colors.black,
                    shape:RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 14),

                    child: Text(
                      "En panne",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    onPressed: (){},
                  ):RaisedButton(
                   color: Colors.black,
                   hoverColor: Colors.black,
                   shape:RoundedRectangleBorder(
                       borderRadius: BorderRadius.circular(10)),
                   padding: EdgeInsets.symmetric(horizontal: 40, vertical: 14),

                   child: Text(
                     "En panne",
                     style: TextStyle(color: Colors.white, fontSize: 16),
                   ),
                   onPressed: (){},
                 ),

                ],
              ),
              SizedBox(
                height: 35,
              ),
              Text("Avancement",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color:  Colors.black,
                  fontSize: 22,
                ),),
              SizedBox(
                height: 12,
              ),
              SliderTheme(
                data: SliderThemeData(
                  activeTrackColor:Color(0xff2E9FB0) ,
                  inactiveTickMarkColor: Colors.grey,
                  thumbColor: Color(0xff2E9FB0) ,
                  thumbShape: RoundSliderThumbShape(
                    enabledThumbRadius: 12
                  ),
                  overlayColor: Color(0xff2E9FB0).withOpacity(0.4),
                  trackHeight: 8,
                  valueIndicatorColor: Color(0xff2E9FB0),
                  valueIndicatorTextStyle: TextStyle(
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
              SizedBox(
                height: 35,
              ),
              Text("Description de la tache",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color:  Colors.black,
                  fontSize: 22,
                ),),
              SizedBox(
                height: 12,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Text(widget.tache.descriptif,
                style: TextStyle(fontSize: 18),
                ),
              ),
              SizedBox(
                height: 35,
              ),
              WidgetRaisedButton(text: "Notifier l'ATC",
                  press: (){print(_currentSliderValue);},
                  color: Color(0xff2E9FB0), textColor: Colors.white)

            ]
          ),
        ),
      ),
    );
  }
}
