import 'package:flutter/material.dart';
import 'package:yum_quick/view/widgets/bottom_bar.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow.shade300,
      
     
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
         Padding(
           padding: const EdgeInsets.all(8.0),
           child: Row(
            children: [
              SizedBox(height: 25,),
                 
              
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    Container(
                      height: 35,
                      width: MediaQuery.of(context).size.width*0.5,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('search'),
                                    
                            CircleAvatar(
                              radius: 15,
                              backgroundColor: Colors.deepOrange,
                              child: Icon(Icons.tune,color: Colors.white,size: 20,),
                            ),
                          ],
                        ),
                      ),
                    ),
                
                
                
                    SizedBox(width: 15,),
                
                
                
                    Row(
                      children: [
                         
                         homeButton(icon: Icons.shopping_bag_outlined, onTap: () {
                      
                    },),
                
                    // SizedBox(width: 2,),
                
                    homeButton(icon: Icons.notifications_none_outlined, onTap: () {
                      
                    },),
                
                    SizedBox(width: 2,),
                
                    homeButton(icon: Icons.person_outline, onTap: () {
                      
                    },),
                
                      ],
                    ),
                
                  ],
                ),
              ),
            ],
           ),
         ),

         Padding(
           padding: const EdgeInsets.all(8.0),
           child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                
            Text('Good Morning',style: TextStyle(color: Colors.white,fontSize: 25,fontWeight: FontWeight.bold),),
           
           Text("Rise And Shine! It's Breakfast Time",style: TextStyle(color: Colors.deepOrange,fontWeight: FontWeight.w600),),
           
           
            ],
           ),
         ),

         
         SizedBox(height: 10,),

         Expanded(
           child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(25),
              topRight: Radius.circular(25)),
              color: Colors.white
            ),

            
           ),
         )
           
        ],
      ),
      bottomNavigationBar: const BottomNavBar(
        currentIndex: 0,
      ),
    );
  }

   Widget homeButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Icon(icon, size: 25, color: Colors.deepOrange),
      ),
    );
  }
  
}