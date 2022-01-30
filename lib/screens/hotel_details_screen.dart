import 'package:flutter/material.dart';

import '../amadeus.dart';

class HotelDetailsScreen extends StatefulWidget {

  const HotelDetailsScreen({Key? key}) : super(key: key);

  static const routeName = "/hotel-details";

  @override
  _HotelDetailsScreenState createState() => _HotelDetailsScreenState();
}

class _HotelDetailsScreenState extends State<HotelDetailsScreen> {


  @override
  Widget build(BuildContext context) {
    final routeArgs = ModalRoute.of(context)?.settings.arguments as Map<String, String>;
    String hotelId = routeArgs['hotelId'] as String;
    // String hotelName = routeArgs['hotelName'] as String;
    print("hotel name ${routeArgs['hotelName']}");
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purpleAccent,
        centerTitle: true,
        title: Text(
          "${routeArgs['hotelName']}",
        ),
      ),
        body: Center(
          child: RaisedButton(
            onPressed: () => Amadeus().getHotelOffers(hotelId),
            child: Text('Press'),
          )
        ));
  }
}
