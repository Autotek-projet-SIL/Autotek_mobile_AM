import 'dart:convert';
import 'package:autotec/components/text_field_password.dart';
import 'package:autotec/components/w_back.dart';
import 'package:autotec/profile/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../components/pop_ups.dart';
import '../components/w_raised_button.dart';
import '../components/text_field.dart';
import 'package:autotec/repositories/image_storage_repository.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/user_data.dart';
import 'dart:io';

class EditProfile extends StatefulWidget {
  final String image;
  final String nom;
  final String prenom;
  const EditProfile({Key? key,
    required this.image,
    required this.nom,
    required this.prenom,

  }) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  XFile? imageFile;
  String? imageChanged;
  bool loading=true;
  bool _passwordVisible=false;
  //final Storage storage = Storage();
  final ImagePicker _picker = ImagePicker();

  _openGallery(BuildContext context) async {
    imageFile = (await _picker.pickImage(source: ImageSource.gallery));
    // final String fileName  = path.basename(imageFile!.path);
    // final File filePath = File(imageFile!.path);

    // await storage.uploadFile(filePath.path, fileName).then((value) => debugPrint("done"));
    imageChanged = imageFile!.path;
    setState(() {});
    Navigator.of(context).pop();
  }

  _openCamera(BuildContext context) async {
    imageFile = (await _picker.pickImage(source: ImageSource.camera));
    imageChanged = imageFile!.path;
    setState(() {});
    Navigator.of(context).pop();
  }

  Future<void> _showChoiceDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  GestureDetector(
                    child: const Text('Gallery'),
                    onTap: () {
                      _openGallery(context);
                    },
                  ),
                  const Padding(padding: EdgeInsets.all(8.0)),
                  GestureDetector(
                    child: const Text('Camera'),
                    onTap: () {
                      _openCamera(context);
                    },
                  )
                ],
              ),
            ),
          );
        });
  }


  void _changePassword(String currentPassword, String newPassword) async {
    await UserCredentials.refresh();
    final user = await FirebaseAuth.instance.currentUser;
    final cred = EmailAuthProvider.credential(
        email: user!.email.toString(), password: currentPassword);

    user?.reauthenticateWithCredential(cred).then((value) {
      user.updatePassword(newPassword).then((_) {
        //Success, do something
      }).catchError((error) {
        //Error, show something
      });
    }).catchError((err) {

    });}


  void updatePassword(String newPassword) async{
    var res=await http.put(
      Uri.parse('http://autotek-server.herokuapp.com/gestionprofils/modifier_am/modifier_mot_de_passe/${UserCredentials.uid}'),
      body: {
        "token": "${UserCredentials.token}",
        "id_sender": "${UserCredentials.uid}",
        "mot_de_passe": newPassword

      },
    );

    print(res.statusCode);
    if(res.statusCode==200){
      print("Password is updated successfully");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Password is updated successfully"),
        duration: Duration(milliseconds: 1200),
      ));
    }
    else{
      print('errorrrrr');
    }


  }

  void updateImage(String newImage) async{
    var res=await http.put(
      Uri.parse('http://autotek-server.herokuapp.com/gestionprofils/modifier_am/modifier_photo/${UserCredentials.uid}'),
      body: {
        "token": "${UserCredentials.token}",
        "id_sender": "${UserCredentials.uid}",
        "photo_am": newImage

      },
    );

    print(res.statusCode);
    if(res.statusCode==200){
      print("Image is updated successfully");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Image is updated successfully"),
        duration: Duration(milliseconds: 1200),
      ));

    }
    else{
      print('errorrrrr');
    }


  }

void updateUser(String newImage, String  currentPassword,String newPassword){
  setState(() {
    loading=false;
  });
    updateImage(newImage);
    _changePassword(currentPassword, newPassword);
    updatePassword(newPassword);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) =>
          Profile()
      ),
    );
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
          color:Color(0xff2E9FB0),
        ),
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          children: [
            Text(text,textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),
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
        Text(text,style: TextStyle(color: Color(0xff696969).withOpacity(0.7),)),
      ],
    );
  }



  @override
  Widget build(BuildContext context) {
    TextEditingController currentPasswordController=TextEditingController(text: '');
    TextEditingController newPasswordController=TextEditingController(text: '');
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
            padding: EdgeInsets.all(35.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    WidgetArrowBack()
                  ],
                ),
                SizedBox(height: size.height*0.02,),
                /* RaisedButton(onPressed: (){
                  //print(" token : ${userCredentials.token}");
                  //print(" id : ${userCredentials.uid}");
                 print("${userProfile[0]}");
                },
                child: Text("click me"),)*/
                //SizedBox(height: size.height*0.0001,),
                CircleAvatar(
                    radius: 85,
                    backgroundColor: Color(0xff2E9FB0),
                    child: CircleAvatar(
                      backgroundColor:Colors.transparent ,
                      radius: 80,
                      backgroundImage:
                      imageChanged==null? NetworkImage(widget.image) :Image.file(File(imageFile!.path)).image,

                      child: IconButton(
                        icon:Icon(Icons.edit),
                        iconSize: 40,
                        onPressed: () { _showChoiceDialog(context); },),
                    )
                ),

                SizedBox(height: size.height*0.02,),
                labelContainer("Current password :"),
                TextFieldPassword(controller: currentPasswordController, visibleMdp: !_passwordVisible,),
                SizedBox(height: size.height*0.015,),
                labelContainer("New password :"),
                TextFieldPassword(controller: newPasswordController, visibleMdp: !_passwordVisible,),
                SizedBox(height: size.height*0.015,),

                SizedBox(height: size.height*0.03,),
                WidgetRaisedButton(press: () async {
                  //print(widget.image);
                  // print(widget.mdp);
                  // print(numController.text);
                  if(loading){
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return EnCours(text: "Traitement",);
                        });
                  }
                  FirebaseStorage.instance.refFromURL(widget.image).delete();
                  // print ("token : ${userCredentials.token}");
                  // print("id : ${userCredentials.uid}");
                  var img_url = await Storage.uploadFile(imageFile!.path, "Selfies/"+widget.nom!+" "+widget.prenom!);
                  imageChanged = img_url ;
                  print(img_url);
                  updateUser(img_url,currentPasswordController.text,newPasswordController.text);

                }, text: 'Modifier',color: Color(0xff2E9FB0),textColor: Colors.white,),


                /* RaisedButton(
                  child: Text('click me'),
                  onPressed: () async {
                    FirebaseStorage.instance.refFromURL(widget.image).delete();
                   // print ("token : ${userCredentials.token}");
                   // print("id : ${userCredentials.uid}");
                    var img_url = await Storage.uploadFile(imageFile!.path, "Selfies/"+widget.nom!+" "+widget.prenom!);
                    imageChanged = img_url ;
                    print(img_url);
                  },
                )*/
              ],
            )
        ),
      ),
    );
  }
}