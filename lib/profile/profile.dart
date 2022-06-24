import 'dart:convert';
import 'package:autotec/Authentication/SignIn/sign_in.dart';
import 'package:autotec/components/w_back.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import '../bloc/auth_bloc.dart';

import 'package:autotec/models/user_data.dart';

import '../car_rental/cars_list.dart';
import '../taches/taches_list.dart';
import 'edit_profile.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late String name;
  late String prenom;
  late String image;
  late String numero;
  late String mdp;
  late String nom;
  bool circular =true;
  late var userProfile;

  @override
  void initState(){
    super.initState();
    getUser();
  }

    void getUser() async{
    var res=await http.get(
        Uri.https('autotek-server.herokuapp.com','/authentification_mobile/am_connexion/${UserCredentials.email}'),
        headers: <String, String>{
          "token": "${UserCredentials.token}",
          "id_sender": "${UserCredentials.uid}"
          ,
        },
    );
    setState(() {
      userProfile=json.decode(res.body);
      circular=false;
      });

  }



  Widget profileContainer(String text){
    Size size = MediaQuery.of(context).size;
    return  Container(
      margin: const EdgeInsets.only(top:5.0,left: 10.0, right: 10.0),
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      height: 43,
      width: size.width*0.4,
      decoration: BoxDecoration(
        border: Border.all(
          color:const Color(0xff2E9FB0),
        ),
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          children: [
            Text(text,textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
  Widget labelContainer(String text){
    Size size = MediaQuery.of(context).size;
    return Row (
      children: [
        SizedBox(width: size.width*0.05,),
        Text(text,style: TextStyle(color: const Color(0xff696969).withOpacity(0.7),)),
      ],
    );
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
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
                icon: const Icon(Icons.person_outlined, color: Color(0xff2E9FB0),size: 30),
                tooltip: 'open profil',
              ),
            ),



          ],
        ),
        notchMargin: 5,
      ),
      body: circular?const Center(child: CircularProgressIndicator()): SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: const [
                      WidgetArrowBack(),
                      SizedBox(width: 20,),
                      Text(
                        'Mon Profil',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          color:  Color(0xff2E9FB0),
                          fontSize: 24  ,
                        ),
                      ),

                    ],
                  ),
                  IconButton(onPressed: () {
                    name="${userProfile[0]["nom"]}";
                    prenom="${userProfile[0]["prenom"]}";
                    numero="${userProfile[0]["numero_telephone"]}";
                    image="${userProfile[0]["photo_am"]}";
                    mdp="${userProfile[0]["mot_de_passe"]}";


                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>
                          EditProfile(image: image, nom: name, prenom: prenom)
                      ),
                    );
                  }, icon: const Icon(Icons.edit ,size: 30,), hoverColor: const Color(0xff2E9FB0),),

                ],
              ),
             /* RaisedButton(onPressed: (){
                //print(" token : ${UserCredentials.token}");
                //print(" id : ${UserCredentials.uid}");
               print("${userProfile[0]}");
              },
              child: Text("click me"),)*/
              SizedBox(height: size.height*0.01,),
              CircleAvatar(
                  radius: 85,
                  backgroundColor: const Color(0xff2E9FB0),
                  child: CircleAvatar(
                    backgroundColor:Colors.transparent ,
                    radius: 80,
                    backgroundImage:
                    NetworkImage("${userProfile[0]["photo_am"]}"),
                  )
              ),

              SizedBox(height: size.height*0.02,),
              labelContainer("Nom :"),
              profileContainer("${userProfile[0]["nom"]}"),
              SizedBox(height: size.height*0.015,),
              labelContainer("Prénom :"),
              profileContainer("${userProfile[0]["prenom"]}"),
              SizedBox(height: size.height*0.015,),
              labelContainer("Adresse mail :"),
              profileContainer("${userProfile[0]["email"]}"),
              SizedBox(height: size.height*0.015,),
              labelContainer("Numero de téléphone :"),
              profileContainer("${userProfile[0]["numero_telephone"]}"),

              SizedBox(height: size.height*0.03,),

              GestureDetector(
                onTap: () async {
                  context.read<AuthBloc>().add(SignOutRequested());
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SignIn()),
                        );

                  //await FirebaseAuth.instance.signOut();
                  //await FirebaseAuth.instance.signOut().then((value) => Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => CarsList()),(route) => false));
     },
                child: Container(
                  margin: const EdgeInsets.only(top:10.0,left: 10.0, right: 10.0),
                  padding: const EdgeInsets.only(left: 15.0, right: 8.0),
                  height: 50,
                  width: size.width*0.4,
                  decoration: BoxDecoration(
                    color: const Color(0xff2E9FB0),

                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10,bottom: 4,top: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: const [
                           // IconButton(onPressed: (){}, icon: Image.asset("assets/hello.png",width: 50,)),
                          Text("Deconnexion",textAlign: TextAlign.center,
                              style: TextStyle(fontWeight:FontWeight.bold,fontSize: 16,color: Colors.white),
                            ),
                          ],
                        ),
                        IconButton(onPressed: (){}, icon: const Icon(Icons.exit_to_app,color: Colors.white,))
                      ],
                    ),
                  ),
                ),
              ),
             /* RaisedButton(
                child: Text('click me'),
                onPressed: (){
                  print ("token : ${UserCredentials.token}");
                   print("id : ${UserCredentials.uid}");
                  //print ("token : ${UserCredentials.token}");
                 // print("id : ${UserCredentials.uid}");

                },
              )*/

            ],
          )
        ),
      ),
    );
  }
}
