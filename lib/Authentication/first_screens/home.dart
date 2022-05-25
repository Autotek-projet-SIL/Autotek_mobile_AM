// ignore_for_file: deprecated_member_use


import 'package:flutter/material.dart';
import '../SignIn/sign_in.dart';


class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 50),
            const Text(
              'Bienvenue sur ',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            Image.asset(
              'assets/logo.png',
              width: 350,
            ),
            SizedBox(height: size.height * 0.01),
            Text('Agent de maintenace',style: TextStyle(fontWeight: FontWeight.bold),),
            SizedBox(height: size.height * 0.08),
            RaisedButton(
              color: const Color.fromRGBO(27, 146, 164, 0.7),
              hoverColor: Colors.black,
              shape: const StadiumBorder(),
              padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 14),
              child: const Text(
                'Se connecter',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignIn()),
                );
              },
            ),
            const SizedBox(height: 20),

          ],
        ),
      ),
    );
  }
}
