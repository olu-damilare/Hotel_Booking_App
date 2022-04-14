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

    // get token from response
    token = data['access_token'];
    return token;
  }

  Future<Hotel?> getHotelOffers(String hotelId) async{

    String? accessToken = token == null ? await generateAccessToken() : token.toString();
    Uri uri = Uri.parse("https://test.api.amadeus.com/v3/shopping/hotel-offers?hotelIds=MCLONGHM");
    print("access token --> $accessToken");
    Response response;

    // send authorization request
    try {
      response = await get(uri,
          headers: {"Authorization": "Bearer $accessToken"});
    }catch(e){
      print("error $e occurred");
      // return "Unable to generate access token due to error $e";
      return null;
    }

    Map data = jsonDecode(response.body);

    print("data --> $data");
    Hotel hotel = Hotel(
      id: data['data'][0]['hotel']['hotelId'],
      name: data['data'][0]['hotel']['name'],
      hotelId: data['data'][0]['hotel']['hotelId'],
      location: data['data'][0]['hotel']['cityCode'],
      roomCategory: data['data'][0]['offers'][0]['room']['typeEstimated']['category'],
      beds: data['data'][0]['offers'][0]['room']['typeEstimated']['beds'],
      bedType: data['data'][0]['offers'][0]['room']['typeEstimated']['bedType'],
      description: data['data'][0]['offers'][0]['room']['description']['text'],
      currency: data['data'][0]['offers'][0]['price']['currency'],
      price: data['data'][0]['offers'][0]['price']['total'],
      offerId: data['data'][0]['offers'][0]['id']
    );

    return hotel;

  }

  Future<bool> isAvailable(String hotelId, String adults, String checkInDate, String checkOutDate, String roomQuantity) async{
    String? accessToken = token == null ? await generateAccessToken() : token.toString();
    Uri uri = Uri.parse("https://test.api.amadeus.com/v3/shopping/hotel-offers?hotelIds=$hotelId&adults=$adults&roomQuantity=$roomQuantity&checkInDate=$checkInDate&checkOutDate=$checkOutDate");
    Response response;

    // send authorization request
    try {
      response = await get(uri,
          headers: {"Authorization": "Bearer $accessToken"});
    }catch(e){
      print("error $e occurred");
      // return "Unable to generate access token due to error $e";
      return false;
    }

    Map data = jsonDecode(response.body);
    print('data --> $data');

    return data['data'][0]['available'];

  }

  Future<List<Hotel>> fetchHotels(String name) async{
    String? accessToken = token == null ? await generateAccessToken() : token.toString();
    Uri uri = Uri.parse("https://test.api.amadeus.com/v1/reference-data/locations/hotel?keyword=$name&subType=HOTEL_GDS&lang=EN&max=20");
    Response response;

    // send authorization request
    try {
      response = await get(uri,
          headers: {"Authorization": "Bearer $accessToken"});
    }catch(e){
      print("error $e occurred");
      return [];
    }

    List<dynamic> data = jsonDecode(response.body)['data'];

    List<Hotel> fetchedHotels = [];

    // create new Hotel instances using the data returned from the API call.
    for(int i = 0; i < data.length; i++){
      Hotel hotel = Hotel(
          name: data[i]['name'],
        iataCode: data[i]['iataCode'],
        subType: data[i]['subType'],
        hotelId: data[i]['hotelIds'][0],
        cityName: data[i]['address']['cityName'],
        countryCode: data[i]['address']['countryCode']
      );

    fetchedHotels.add(hotel);

    }

    return fetchedHotels;
  }


  Future<void> bookRoom({
    required String offerId,
    required String title,
    required String firstName,
    required String lastName,
    required String phoneNumber,
    required String email,
  }) async{
    String? accessToken = token == null ? await generateAccessToken() : token.toString();
    Uri bookingUri = Uri.parse("https://test.api.amadeus.com/v1/booking/hotel-bookings");

    Response response;

    // request body sent to the hotel booking API
    Map requestBody = {
      "data": {
        "offerId": offerId,
        "guests": [
          {
            "name": {
              "title": title,
              "firstName": firstName,
              "lastName": lastName
            },
            "contact": {
              "phone": phoneNumber,
              "email": email
            }
          }
        ],
        "payments": [
          {
            "method": "creditCard",
            "card": {
              "vendorCode": "VI",
              "cardNumber": "4111111111111111",
              "expiryDate": "2023-01"
            }
          }
        ]
      }
    };

    var body = json.encode(requestBody);

    // send authorization request
    try {
      response = await post(bookingUri,
          headers: {"Content-Type": "application/json",
            "Authorization": "Bearer $accessToken"},
          body: body);
    }catch(e){
      print("error generating token --> $e");
      return;
    }

    Map data = jsonDecode(response.body);
    print("response data --> $data");
  }


}