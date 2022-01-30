// import dependencies
import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';

import 'model/hotel.dart';

class Amadeus{

  String? token;

  Future<String?> generateAccessToken() async{

    // fetch client id and client secret key from .env file
    String clientId = dotenv.env['client_id'] as String;
    String clientSecret = dotenv.env['client_secret'] as String;

    // Amadeus authorization endpoint
    Uri authorizationUri = Uri.parse("https://test.api.amadeus.com/v1/security/oauth2/token");

    Response response;

    // send authorization request
    try {
      response = await post(authorizationUri,
          headers: {"Content-type": "application/x-www-form-urlencoded"},
          body: "grant_type=client_credentials&client_id=$clientId&client_secret=$clientSecret");
    }catch(e){
      print("error generating token --> $e");
      return "Unable to generate access token due to error $e";
    }

    Map data = jsonDecode(response.body);
    print(data);

    // get token from response
    token = data['access_token'];
    return token;
  }

  void getHotelOffers(String hotelId) async{

    String? accessToken = token == null ? await generateAccessToken() : token.toString();
    Uri uri = Uri.parse("https://test.api.amadeus.com/v3/shopping/hotel-offers?hotelIds=$hotelId&adults=1");
    print("access token --> $accessToken");
    Response response;

    // send authorization request
    print("before api call");
    try {
      response = await get(uri,
          headers: {"Authorization": "Bearer $accessToken"});
    }catch(e){
      print("error $e occurred");
      // return "Unable to generate access token due to error $e";
      return;
    }
    print("after api call");


    Map data = jsonDecode(response.body);
    print(data);


  }

  Future<List<Hotel>> fetchHotels(String name) async{
    String? accessToken = token == null ? await generateAccessToken() : token.toString();
    Uri uri = Uri.parse("https://test.api.amadeus.com/v1/reference-data/locations/hotel?keyword=$name&subType=HOTEL_GDS&lang=EN&max=20");
    print("access token --> $accessToken");
    Response response;
    print("the hotel name is $name");


    // send authorization request
    print("before api call");
    try {
      response = await get(uri,
          headers: {"Authorization": "Bearer $accessToken"});
    }catch(e){
      print("error $e occurred");
      return [];
    }
    print("after api call");

    List<dynamic> data = jsonDecode(response.body)['data'];

    List<Hotel> fetchedHotels = [];

    for(int i = 0; i < data.length; i++){
      Hotel hotel = Hotel(
          id: data[i]['id'],
          name: data[i]['name'],
        iataCode: data[i]['iataCode'],
        subType: data[i]['subType'],
        hotelIds: data[i]['hotelIds'][0],
        cityName: data[i]['address']['cityName'],
        countryCode: data[i]['address']['countryCode']
      );

    fetchedHotels.add(hotel);

    }

    return fetchedHotels;
  }


}