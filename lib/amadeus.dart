// import dependencies
import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';

class Amadeus{

  String? token;

  Future<String?> generateAccessToken() async{

    // fetch client id and client secret key from .env file
    String clientId = dotenv.env['client_id'] as String;
    String clientSecret = dotenv.env['client_secret'] as String;

    // Amadeus authorization endpoint
    Uri authorizationUri = Uri.parse("https://test.api.amadeus.com/v1/security/oauth2/token");

    Response response;
    print(clientSecret);
    print(clientId);

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

  void getHotelOffers() async{
    print("before token generation");

    String? accessToken = token == null ? await generateAccessToken() : token.toString();
    Uri uri = Uri.parse("https://test.api.amadeus.com/v3/shopping/hotel-offers?hotelIds=HLLON101&adults=1");
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


    // print("access token --> $accessToken");
  }
}