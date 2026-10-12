import 'dart:async';

import 'package:flutter/material.dart';
import 'package:yum_quick/view/onbord_screen.dart';

class LogSign extends StatefulWidget {
  const LogSign({super.key});

  @override
  State<LogSign> createState() => _LogSignState();
}

class _LogSignState extends State<LogSign> {
  @override
 void initState(){
    super.initState();
    Timer(Duration(seconds: 3), 
    () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const OnbordSs () ,));
    },);
  }


  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 46, 10),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/Capa_2 (1).png',height: 220,),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'YUM',
                    style: TextStyle(
                      color: Colors.amberAccent,
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
              SizedBox(height: 25),
              Text(
                'Lorem ipsum dolor sit amet, consectetur',
                style: TextStyle(color: Colors.white,
                fontSize: 15,fontWeight: FontWeight.w500
                ),
              ),
              Text('adipiscing elit, sed do eiusmod',style: TextStyle(
                color: Colors.white,
                fontSize: 15,fontWeight: FontWeight.w500,
              ),),
              SizedBox(height: 25),
              Container(
                height: 40,
                width: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.amberAccent,
                ),
                child: Center(
                  child: Text(
                    'Log In',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              SizedBox(height: 10,),
              Container(
                height: 40,
                width: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.amberAccent.shade100,
                ),
                child: Center(
                  child: Text(
                    'Sign Up',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

  
