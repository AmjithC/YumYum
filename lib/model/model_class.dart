class Restaurant{

  final int? id;
  final String restaurantName;
  final String address;
  final String type;
  final bool parkinglot;

Restaurant({
  this.id,
  required this.restaurantName,
  required this.address,
  required this.type,
  required this.parkinglot,
});
factory Restaurant.fromjson(Map<String,dynamic>json){
  return Restaurant(
    restaurantName: json["id"],
   address: json["restaurantName"] ?? '', 
   type: json["type"] ?? '', 
   parkinglot: json["parkinglot"] ?? '',
   );

}
}