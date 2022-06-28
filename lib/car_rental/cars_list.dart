// ignore_for_file: deprecated_member_use, avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../profile/profile.dart';
import '../taches/taches_list.dart';
import 'cars.dart';
import '/components/WviewCar.dart';
import 'package:autotec/models/user_data.dart';


class CarsList extends StatefulWidget {

   const CarsList({Key? key}) : super(key: key);

  @override
  State<CarsList> createState() => _CarsListState();
}

class _CarsListState extends State<CarsList> {

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
                    SizedBox(width: 20,),
                    Text(
                      'Mes Vehicules',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        color:  Color(0xff2E9FB0),
                        fontSize: 24  ,
                      ),
                    ),
                  ],
                ),
              ),


              const Center(
                    child: CarListView(),
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
                    MaterialPageRoute(builder: (context) => const CarsList()),
                  );
                },
                icon: const Icon(Icons.directions_car, color: Color(0xff2E9FB0),size: 30),
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
                icon: const Icon(Icons.library_books_sharp, color: Colors.grey,size: 30),
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

class CarListView extends StatelessWidget{

  const CarListView({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Car>>(
      future: _fetchCars(context),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Car>? data = snapshot.data;
          return SizedBox(
              height: MediaQuery.of(context).size.height*0.8,
              width: 350,
              child: _carsListView(data));
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return  const CircularProgressIndicator();
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
                      Text("aucune voiture n'est disponible en ce moment, veuillez réessayer plus tard")
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

  Future<List<Car>> _fetchCars(BuildContext context) async {

    var url = Uri.http("autotek-server.herokuapp.com","/flotte/vehicule_am/${UserCredentials.uid}");
    final response = await http.get(url, headers: {'token':UserCredentials.token!,'id_sender':UserCredentials.uid!});

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      List<Car> list =  jsonResponse.map((json) =>  Car.fromJson(json)).toList();
      //recuperer ceux dispo et batterie > 20

      if(list.isEmpty){
         _showFailDialog(context);
      }
      return list;
    } else if (response.statusCode == 403) {
      throw Exception('access forbiden');
    }else{

      throw Exception('Failed to load Cars from API');
    }
  }

  ListView _carsListView(data) {
    return ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          return WidgetViewCar(car:data[index]);
        });
  }
}