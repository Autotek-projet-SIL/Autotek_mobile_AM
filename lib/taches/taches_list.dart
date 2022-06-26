// ignore_for_file: deprecated_member_use, avoid_print

import 'dart:convert';

import 'package:autotec/car_rental/cars_list.dart';
import 'package:autotec/components/w_tache.dart';
import 'package:autotec/taches/tache.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../components/w_back.dart';
import '../profile/profile.dart';
import 'package:autotec/models/user_data.dart';


class TachesList extends StatefulWidget {

  const TachesList({Key? key}) : super(key: key);

  @override
  State<TachesList> createState() => _TachesListState();
}

class _TachesListState extends State<TachesList> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Column(
            children: [

              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Row(
                  children: const [
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
      ),
      bottomNavigationBar: BottomAppBar(
        shape:const CircularNotchedRectangle(),

        color: Colors.white,
        child: Row(

          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(40.0, 5, 15, 5),
              child: IconButton(
                onPressed: ()async{
                  await UserCredentials.refresh();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CarsList()),
                  );
                },
                icon: const Icon(Icons.directions_car, color: Colors.grey,size: 30),
                tooltip: 'rent a car',
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(40.0, 5, 15, 5),
              child: IconButton(
                onPressed: ()async{
                  await UserCredentials.refresh();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const TachesList()),
                  );
                },
                icon: const Icon(Icons.library_books_sharp, color: Color(0xff2E9FB0),size: 30),
                tooltip: 'rent a car',
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(40.0, 5, 15, 5),
              child: IconButton(
                onPressed: () async {
                  //TODO navigate to profil
                  await UserCredentials.refresh();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>
                        const Profile()
                    ),
                  );

                },
                icon: const Icon(Icons.person_outlined, color: Colors.grey,size: 30),
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

  const TacheListView({Key? key}) : super(key: key);


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
              child: _tachesListView(data));
        } else if (snapshot.hasError) {
          return Center(child: Text("${snapshot.error}"));
        }
        return  const Center(child: CircularProgressIndicator());
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
                      const Expanded(child:
                      Text("aucune tache n'est disponible en ce moment, veuillez réessayer plus tard")
                      ),
                      Center(
                        child: FlatButton(
                            onPressed: (){
                              //TODO send a post with rejected demande de location
                              Navigator.pop(context);
                            },
                            child: const Text("ok")),
                      )
                    ],
                  ),
                )
            ),
          );
        });
  }

  Future<List<Tache>> _fetchTaches(BuildContext context) async {

    var url = Uri.http("autotek-server.herokuapp.com","/tache/get_tache_byidam/${UserCredentials.uid}");
    print (url.toString());
    final response = await http.get(url, headers: {'token':UserCredentials.token!,'id_sender':UserCredentials.uid!});

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      List<Tache> list =  jsonResponse.map((json) => Tache.fromJson(json)).toList();
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

  ListView _tachesListView(data) {
    return ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
              if(data[index].etat=="en cours" || data[index].etat=="En cours" )
            return WidgetTache(tache:data[index],colorTache:Colors.white );
             else
                return WidgetTache(tache:data[index],colorTache:Colors.grey );



        });
  }
}