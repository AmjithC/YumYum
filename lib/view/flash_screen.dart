import 'dart:async';


import 'package:flutter/material.dart';
import 'package:yum_quick/view/log_sign.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  @override
   void initState(){
    super.initState();
    Timer(Duration(seconds: 3), 
    () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LogSign() ,));
    },);
  }

@override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.amberAccent,
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/Capa_2.png', height: 220,width: 220,),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'YUM',
                    style: TextStyle(
                      color: const Color.fromARGB(255, 246, 95, 49),
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'QUICK',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

  


