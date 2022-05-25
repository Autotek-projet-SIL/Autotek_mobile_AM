import 'dart:convert';

import 'package:autotec/car_rental/CarsList.dart';
import 'package:autotec/components/WTache.dart';
import 'package:autotec/taches/tache.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../components/WBack.dart';
import '../profile/profile.dart';
import '../taches/taches_list.dart';
import 'package:autotec/models/user_data.dart';


class TachesList extends StatefulWidget {

  TachesList({Key? key}) : super(key: key);

  @override
  State<TachesList> createState() => _TachesListState();
}

class _TachesListState extends State<TachesList> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [

            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Row(
                children: [
                  WidgetArrowBack(),
                  SizedBox(width: 20,),
                  Text(
                    'Mes Taches',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color:  Color(0xff2E9FB0),
                      fontSize: 24  ,
                    ),
                  ),
                ],
              ),
            ),

            Center(
              child: TacheListView(),
            ),

          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape:const CircularNotchedRectangle(),

        color: Colors.white,
        child: Row(

          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(50.0, 5, 20, 5),
              child: IconButton(
                onPressed: ()async{
                  await userCredentials.refresh();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CarsList()),
                  );
                },
                icon: Icon(Icons.directions_car, color: Colors.grey,size: 30),
                tooltip: 'rent a car',
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(50.0, 5, 20, 5),
              child: IconButton(
                onPressed: ()async{
                  await userCredentials.refresh();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TachesList()),
                  );
                },
                icon: Icon(Icons.library_books_sharp, color: Color(0xff2E9FB0),size: 30),
                tooltip: 'rent a car',
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(50.0, 5, 50, 5),
              child: IconButton(
                onPressed: () async {
                  //TODO navigate to profil
                  await userCredentials.refresh();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>
                        Profile()
                    ),
                  );

                },
                icon: Icon(Icons.person_outlined, color: Colors.grey,size: 30),
                tooltip: 'open profil',
              ),
            ),



          ],
        ),
        notchMargin: 5,
      ),
    );
  }
}

class TacheListView extends StatelessWidget{

  TacheListView({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Tache>>(
      future: _fetchTaches(context),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Tache>? data = snapshot.data;
          return SizedBox(
              height: MediaQuery.of(context).size.height*0.8,
              width: 350,
              child: _TachesListView(data));
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return  CircularProgressIndicator();
      },
    );
  }

  Future<void> _showFailDialog( BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: SingleChildScrollView(
                child: SizedBox(
                  height: 160,
                  width: 280,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child:
                      Text("aucune voiture n'est disponible en ce moment, veuillez réessayer plus tard")
                      ),
                      Center(
                        child: FlatButton(
                            onPressed: (){
                              //TODO send a post with rejected demande de location
                              Navigator.pop(context);
                            },
                            child: Text("ok")),
                      )
                    ],
                  ),
                )
            ),
          );
        });
  }

  Future<List<Tache>> _fetchTaches(BuildContext context) async {

    var Url = Uri.http("autotek-server.herokuapp.com","/authentification_mobile/am_connexion/${userCredentials.email}");
    print (Url.toString());
    final response = await http.get(Url, headers: {'token':userCredentials.token!,'id_sender':userCredentials.uid!});

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      List<Tache> list =  jsonResponse.map((json) => new Tache.fromJson(json)).toList();
      //recuperer ceux dispo et batterie > 20

      if(list.isEmpty){
        _showFailDialog(context);
      }
      return list;
    } else if (response.statusCode == 403) {
      throw Exception('access forbiden');
    }else{

      throw Exception('Failed to load Taches from API');
    }
  }

  ListView _TachesListView(data) {
    return ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          return WidgetTache(tache:data[index]);
        });
  }
}