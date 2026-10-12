import 'dart:convert';

import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:yum_quick/model/model_class.dart';

class itemservice{
  final String baseurl="'https://fakerestaurantapi.runasp.net/api/Restaurantp";

  Future <List<Restaurant>> fetchiteam()async{
    final Response= await http.get(Uri.parse(baseurl));
    if(Response.statusCode==200){
      final List data=jsonDecode(Response.body);
      return data.map((item)=>Restaurant.fromjson(item)).toList();

    }else{
      throw Exception('failed to fectch items');
    }
  }
   
}