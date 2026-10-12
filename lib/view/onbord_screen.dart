import 'package:flutter/material.dart';
import 'package:yum_quick/model/onbord_model.dart';
import 'package:yum_quick/view/login/login_page.dart';

class OnbordSs extends StatefulWidget {
  const OnbordSs({super.key});

  @override
  State<OnbordSs> createState() => _OnbordSsState();
}

class _OnbordSsState extends State<OnbordSs> {


  final PageController controller=PageController();

  int currentpage=0;

  void nextpage(){
    if(currentpage<2){
      controller.nextPage(duration: const Duration(milliseconds: 300), curve:Curves.easeInOut);
      print("pagenumber:${currentpage}");
    }
    else if(currentpage>1){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Loginscreen(),));
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: PageView.builder(
          controller: controller,
           itemCount: onPage.length,
          onPageChanged: (index) {
            setState(() {
              currentpage=index;
            });
          },
        
          itemBuilder: (context, index) {
            return Column(
              children: [
                Expanded(
                  flex: 6,
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius:  const BorderRadius.vertical(
                          top: Radius.circular(15),
                        ),
                        child: Image.asset(
                          onPage[index]["image"]!,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 15,
                        right: 15,
                        child:InkWell( 
                          onTap: () {
                            
            
            
                          },
                          child: Text("Skip >",style: TextStyle(color: Colors.orange.shade400,fontSize: 12,),)) )
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 310,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        index == 0
                        ? Icons.receipt_long_sharp
                        :index==1
                        ?Icons.credit_card
                        :Icons.delivery_dining,
                        color: Colors.deepOrange,
                        size: 30,
                      ),
                      const SizedBox(height: 10,),
                      
                      Text(
                        onPage[index]["title"]!,
                        style: TextStyle(color: Colors.deepOrange,
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                      ),
            
                      const SizedBox(height: 10,),
                      
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Text(
                          onPage[index]["description"]!,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 15,color: Colors.black),
                        ),
                      ),
            
                      SizedBox(height: 15,),
            
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          3,
                           (dot)=>Container(
                            margin: 
                            const EdgeInsets.symmetric(horizontal: 3),
                            height: 4,
                            width: 20,
                            decoration: BoxDecoration(
                              color: currentpage==dot?
                              Colors.deepOrange
                              :Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(10),
                            ),
                           ),),
            
                      ),
            
                      const SizedBox(height: 18,),
                      SizedBox(
                        width: 90,
                        height: 40,
                        child: ElevatedButton(onPressed: nextpage,
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.deepOrange,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),),), 
                        child:Text(
                          currentpage==2?
                          "Get started"
                          :"next",
                          style: const TextStyle(fontSize: 10),
                        ) ),
                      )
            
                    ],
                  ),
                )
              ],
            );
          },),
      ),
    );
  }
}